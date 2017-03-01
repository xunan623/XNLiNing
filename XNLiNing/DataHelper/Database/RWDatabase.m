//
//  RWDatabase.m
//  Test0701
//
//  Created by Ranger on 16/7/1.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWDatabase.h"

#ifdef DEBUG
# define DBLog(...) NSLog(__VA_ARGS__);
#else
# define DBLog(...);
#endif

#define STRCMP_ENCODE(__type__)        strcmp([obj objCType], @encode(__type__)) == 0
#define SQLITE_BIND_INT(__type__)      sqlite3_bind_int(pStmt, idx, [obj __type__])
#define SQLITE_BIND_INT64(__type__)    sqlite3_bind_int64(pStmt, idx, [obj __type__])
#define SQLITE_BIND_TEXT(__value__)    sqlite3_bind_text(pStmt, idx, [__value__ UTF8String], -1, SQLITE_STATIC)
#define SQLITE_BIND_DOUBLE_VALUE(__value__) sqlite3_bind_double(pStmt, idx, __value__)
#define SQLITE_BIND_DOUBLE(__type__)   SQLITE_BIND_DOUBLE_VALUE([obj __type__])

@interface RWDatabase () {
    @package
    sqlite3             *_db;                  //!< 数据库操作对象
    NSMutableSet        *_openResultSet;       //!< 打开数据库获取数据的结果集
    NSTimeInterval      _startBusyRetryTime;   //!< 数据库繁忙时 开始重试的时间
    NSMutableDictionary *_cachedStatements;    //!< 缓存sqlite语句
    BOOL                _isExecutingStatement; //!< 正在使用sqlite语句
    NSDateFormatter     *_dateFormat;          //!< 日期格式化
}

@end

@implementation RWDatabase

@dynamic open, close;
@dynamic rollback, commit, beginDeferredTransaction, beginTransaction;
@dynamic lastErrorCode, hadError, lastError ,lastErrorMessage;

@synthesize maxBusyRetryTimeInterval = _maxBusyRetryTimeInterval;
@synthesize inTransaction = _inTransaction;

+ (instancetype)databaseWithPath:(NSString *)aPath {
    return [[self alloc] initWithPath:aPath];
}

- (instancetype)init {
    return [self initWithPath:nil];
}

- (instancetype)initWithPath:(NSString *)aPath {
    // 当 sqlite3_threadsafe() 返回0时， 这货禁用所有的mutex锁，并发使用时会出错
    // 恩，就是线程不靠谱不安全了
    assert(sqlite3_threadsafe());
    
    if (self == [super init]) {
        _dbPath                   = aPath;
        _openResultSet            = [NSMutableSet set];
        _db                       = nil;
        _maxBusyRetryTimeInterval = 2.0f;
        _crashOnErrors            = NO;
        _logsErrors               = YES;
    }
    
    return self;
}

- (BOOL)tableExists:(NSString*)tableName {
    tableName = [tableName lowercaseString];
    RWResultSet *rs = [self executeQuery:@"select [sql] from sqlite_master where [type] = 'table' and lower(name) = ?", tableName];
    
    BOOL returnBool = [rs next];
    [rs close];
    
    return returnBool;
}

#pragma mark-  打开和关闭数据库

- (BOOL)open {
    if (_db) return YES;
    
    int err = sqlite3_open([self sqlitePath], &_db);
    if(err != SQLITE_OK) {
        DBLog(@"打开数据库发生错误：%d", err);
        return NO;
    }
    
    if (_maxBusyRetryTimeInterval > 0.0) {
        // 设置最大数据库操作的重试时间间隔  在初始化时默认2.0s
        [self setMaxBusyRetryTimeInterval:_maxBusyRetryTimeInterval];
    }
    return YES;
}

- (BOOL)close {
    
    [self clearCachedStatements];
    [self closeOpenResultSet];
    
    if (!_db) return YES;
    
    int  rc;
    BOOL retry;
    BOOL triedFinalizingOpenStatements = NO;
    
    do {
        retry   = NO;
        rc      = sqlite3_close(_db);
        // 如果数据库被占用 正在使用等等  强行关闭
        if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
            if (!triedFinalizingOpenStatements) {
                triedFinalizingOpenStatements = YES;
                sqlite3_stmt *pStmt;
                while ((pStmt = sqlite3_next_stmt(_db, nil)) != 0) {
                    DBLog(@"强行关闭正在使用的执行语句");
                    sqlite3_finalize(pStmt);
                    retry = YES;
                }
            }
        }
        else if (SQLITE_OK != rc) { DBLog(@"关闭数据库时发生错误：%d", rc); }
    }
    while (retry);
    
    _db = nil;
    return YES;
}

#pragma mark-  配置sqlite

- (const char *)sqlitePath {
    if (!_dbPath)  return ":memory:"; // ?
    if (!_dbPath.length)  return "";  // 在内存中创建一个临时数据库
    // fileSystemRepresentation 返回C字符串形式的文件路径 const char* 类型
    return [_dbPath fileSystemRepresentation];
}

- (sqlite3 *)sqliteHandler {
    return _db;
}

#pragma mark- -------------------------------- core methods ⬇ -------------------------------------

#pragma mark-  update methods

- (BOOL)executeUpdate:(NSString*)sql, ... {
    va_list args;
    va_start(args, sql);
    BOOL result = [self executeUpdate:sql withArgumentsInArray:nil orDictionary:nil orVAList:args error:nil];
    
    va_end(args);
    return result;
}

- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments {
    return [self executeUpdate:sql withArgumentsInArray:arguments orDictionary:nil orVAList:nil error:nil];
}

- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments {
    return [self executeUpdate:sql withArgumentsInArray:nil orDictionary:arguments orVAList:nil error:nil];
}

- (BOOL)executeUpdate:(NSString*)sql withVAList:(va_list)args {
    return [self executeUpdate:sql withArgumentsInArray:nil orDictionary:nil orVAList:args error:nil];
}

- (BOOL)executeUpdate:(NSString*)sql
 withArgumentsInArray:(NSArray*)arrayArgs
         orDictionary:(NSDictionary *)dictionaryArgs
             orVAList:(va_list)args
                error:(NSError**)outErr {
    if (![self databaseExists]) return NO;
    
    if (_isExecutingStatement) {
        [self warnInUse];
        return NO;
    }
    
    _isExecutingStatement = YES;
    
    int rc                   = 0x00;
    sqlite3_stmt *pStmt      = 0x00;
    RWStatement *cachedStmt = 0x00;
    
    if (_traceExecution && sql) { DBLog(@"当前执行：%@ executeUpdate: %@", self, sql); }
    
    if (_shouldCacheStatements) {
        cachedStmt = [self cachedStatementForQuery:sql];
        pStmt = cachedStmt ? cachedStmt.sqlStatement : 0x00;
        [cachedStmt reset];
    }
    
    if (!pStmt) {
        rc = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &pStmt, 0);
        
        if (SQLITE_OK != rc) {
            if (_logsErrors) {
                DBLog(@"数据库执行出错: %d \"%@\"", self.lastErrorCode, self.lastErrorMessage);
                DBLog(@"出错语句: %@", sql);
                DBLog(@"文件路径: %@", _dbPath);
            }
            
            if (_crashOnErrors) {
                NSAssert(false, @"数据库执行出错: %d \"%@\"", self.lastErrorCode, self.lastErrorMessage);
                abort();
            }
            
            sqlite3_finalize(pStmt);
            
            if (outErr) {
                *outErr = [self errorWithMessage:[NSString stringWithUTF8String:sqlite3_errmsg(_db)]];
            }
            
            _isExecutingStatement = NO;
            return NO;
        }
    }
    
    id obj;
    int idx = 0;
    int queryCount = sqlite3_bind_parameter_count(pStmt);
    
    if (dictionaryArgs) {
        
        for (NSString *dictionaryKey in [dictionaryArgs allKeys]) {
            NSString *parameterName = [[NSString alloc] initWithFormat:@":%@", dictionaryKey];
            
            if (_traceExecution) { DBLog(@"当前获取的键值对：%@ = %@", parameterName, dictionaryArgs[dictionaryKey]); }
            
            int namedIdx = sqlite3_bind_parameter_index(pStmt, parameterName.UTF8String);
            if (namedIdx > 0) {
                [self bindObject:dictionaryArgs[dictionaryKey] toColumn:namedIdx inStatement:pStmt];
                idx++;
            }
            else { DBLog(@"未找到[%@]对应的索引", dictionaryKey); }
        }
    }
    else {
        
        while (idx < queryCount) {
            
            if (arrayArgs && idx < (int)[arrayArgs count])  obj = arrayArgs[idx];
            else if (args) obj = va_arg(args, id);
            else break;
            
            if (_traceExecution) {
                if ([obj isKindOfClass:[NSData class]]) { DBLog(@"data大小: %ld bytes", [obj length]); }
                else { DBLog(@"对象obj: %@", obj); }
            }
            
            idx++;
            [self bindObject:obj toColumn:idx inStatement:pStmt];
        }
    }
    
    if (idx != queryCount) {
        DBLog(@"错误：执行(executeUpdate)时，执行语句[%@]中变量数[%d]和对应参数的数量[%d]不对等", sql, queryCount, idx);
        sqlite3_finalize(pStmt);
        _isExecutingStatement = NO;
        return NO;
    }
    
    rc = sqlite3_step(pStmt);
    
    if (SQLITE_DONE == rc) {
        if (_traceExecution) {
            DBLog(@"[SQLITE_DONE]，调用sqlite3_step成功");
            DBLog(@"当前执行的语句：%@", sql);
        }
    }
    else if (SQLITE_ERROR == rc) {
        if (_logsErrors) {
            DBLog(@"[SQLITE_ERROR]，调用sqlite3_step (%d: %s)发生错误", rc, sqlite3_errmsg(_db));
            DBLog(@"当前执行的语句：%@", sql);
        }
    }
    else if (SQLITE_MISUSE == rc) {
        if (_logsErrors) {
            DBLog(@"[SQLITE_MISUSE]，调用sqlite3_step (%d: %s)发生错误", rc, sqlite3_errmsg(_db));
            DBLog(@"当前执行的语句：%@", sql);
        }
    }
    else {
        if (_logsErrors) {
            DBLog(@"[未知错误]，调用sqlite3_step (%d: %s)发生错误", rc, sqlite3_errmsg(_db));
            DBLog(@"当前执行的语句：%@", sql);
        }
    }
    
    if (rc == SQLITE_ROW) { NSAssert(NO, @"当前执行的语句：%@", sql); }
    
    if (_shouldCacheStatements && !cachedStmt) {
        cachedStmt = [[RWStatement alloc] init];
        [cachedStmt setSqlStatement:pStmt];
        [self setCachedStatement:cachedStmt forQuery:sql];
    }
    
    int closeErrorCode;
    if (cachedStmt) {
        cachedStmt.useCount ++;
        closeErrorCode = sqlite3_reset(pStmt);
    }
    else closeErrorCode = sqlite3_finalize(pStmt);
    
    if (closeErrorCode != SQLITE_OK) {
        if (_logsErrors) {
            DBLog(@"[未知错误]，调用finalizing 或者 resetting (%d: %s)发生错误", rc, sqlite3_errmsg(_db));
            DBLog(@"当前执行的语句：%@", sql);
        }
    }
    
    _isExecutingStatement = NO;
    return (rc == SQLITE_DONE || rc == SQLITE_OK);
}

#pragma mark-  query methods

- (RWResultSet *)executeQuery:(NSString*)sql, ... {
    va_list args;
    va_start(args, sql);
    
    id result = [self executeQuery:sql withArgumentsInArray:nil orDictionary:nil orVAList:args];
    
    va_end(args);
    return result;
}

- (RWResultSet *)executeQuery:(NSString*)sql withVAList:(va_list)args {
    return [self executeQuery:sql withArgumentsInArray:nil orDictionary:nil orVAList:args];
}

- (RWResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments {
    return [self executeQuery:sql withArgumentsInArray:arguments orDictionary:nil orVAList:nil];
}

- (RWResultSet *)executeQuery:(NSString *)sql
          withArgumentsInArray:(NSArray*)arrayArgs
                  orDictionary:(NSDictionary *)dictionaryArgs
                      orVAList:(va_list)args {
    
    // 数据库文件不存在 返回空
    if (![self databaseExists])  return 0x00;
    
    // 正在请求数据库  返回空 log error
    if (_isExecutingStatement) {
        [self warnInUse];
        return 0x00;
    }
    
    _isExecutingStatement = YES;
    
    int rc                  = 0x00;
    sqlite3_stmt *pStmt     = 0x00;
    RWStatement *myStmt    = 0x00;
    RWResultSet *rs        = 0x00;
    
    // 需要打印且sql不为空 打印当前操作的sqlite语句
    if (_traceExecution && sql) { DBLog(@"当前执行：%@ executeUpdate: %@", self, sql); }
    
    // 如果缓存过sqlite语句 以sql为key取出在缓存字典里的stmt
    if (_shouldCacheStatements) {
        myStmt = [self cachedStatementForQuery:sql];
        pStmt = myStmt ? myStmt.sqlStatement : 0x00;
        [myStmt reset];
    }
    
    if (!pStmt) {
        rc = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &pStmt, 0);
        
        if (SQLITE_OK != rc) {
            if (_logsErrors) {
                DBLog(@"数据库执行出错: %d \"%@\"", self.lastErrorCode, self.lastErrorMessage);
                DBLog(@"出错语句: %@", sql);
                DBLog(@"文件路径: %@", _dbPath);
            }
            if (_crashOnErrors) {
                NSAssert(false, @"数据库执行出错: %d \"%@\"", self.lastErrorCode, self.lastErrorMessage);
                abort();
            }
            
            sqlite3_finalize(pStmt);
            _isExecutingStatement = NO;
            return nil;
        }
    }
    
    id  obj;
    int idx = 0;
    int queryCount = sqlite3_bind_parameter_count(pStmt);
    
    // 参数为字典时
    if (dictionaryArgs) {
        
        for (NSString *dictionaryKey in [dictionaryArgs allKeys]) {
            NSString *parameterName = [[NSString alloc] initWithFormat:@":%@", dictionaryKey];
            
            if (_traceExecution) { DBLog(@"当前获取的键值对：%@ = %@", parameterName, dictionaryArgs[dictionaryKey]); }
            
            // 找到键值在数据库中对应的索引
            int namedIdx = sqlite3_bind_parameter_index(pStmt, parameterName.UTF8String);
            
            if (namedIdx > 0) {
                [self bindObject:dictionaryArgs[dictionaryKey] toColumn:namedIdx inStatement:pStmt];
                idx++;
            }
            else { DBLog(@"未找到[%@]对应的索引", dictionaryKey); }
        }
    }
    else {
        
        while (idx < queryCount) {
            
            if (arrayArgs && idx < arrayArgs.count)  obj = arrayArgs[idx];
            else if (args)  obj = va_arg(args, id);
            else break;
            
            if (_traceExecution) {
                if ([obj isKindOfClass:[NSData class]]) {
                    DBLog(@"data大小: %ld bytes", (unsigned long)[(NSData*)obj length]);
                }
                else { DBLog(@"对象obj: %@", obj); }
            }
            
            idx++;
            [self bindObject:obj toColumn:idx inStatement:pStmt];
        }
    }
    
    if (idx != queryCount) {
        DBLog(@"错误：执行(executeQuery)时，执行语句中的变量数和对应参数的数量不对等");
        sqlite3_finalize(pStmt);
        _isExecutingStatement = NO;
        return nil;
    }
    
    if (!myStmt) {
        myStmt = [RWStatement new];
        [myStmt setSqlStatement:pStmt];
        
        if (_shouldCacheStatements && sql) [self setCachedStatement:myStmt forQuery:sql];
    }
    
    rs = [RWResultSet resultSetWithStatement:myStmt usingParentDatabase:self];
    [rs setQuery:sql];
    
    NSValue *openResultSet = [NSValue valueWithNonretainedObject:rs];
    [_openResultSet addObject:openResultSet];
    
    myStmt.useCount ++;
    _isExecutingStatement = NO;
    
    return rs;
}

- (void)bindObject:(id)obj toColumn:(int)idx inStatement:(sqlite3_stmt *)pStmt {
    
    if ((!obj) || [obj isKindOfClass:[NSNull class]])  sqlite3_bind_null(pStmt, idx);
    else if ([obj isKindOfClass:[NSData class]]) {
        const void *bytes = [obj bytes];
        if (!bytes) bytes = @"";
        sqlite3_bind_blob(pStmt, idx, bytes, (int)[obj length], SQLITE_STATIC);
    }
    else if ([obj isKindOfClass:[NSDate class]]) {
        if (self.hasDateFormatter)  SQLITE_BIND_TEXT([self stringFromDate:obj]);
        else SQLITE_BIND_DOUBLE_VALUE([obj timeIntervalSince1970]);
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        if (STRCMP_ENCODE(char)) SQLITE_BIND_INT(charValue);
        else if (STRCMP_ENCODE(unsigned char)) SQLITE_BIND_INT(unsignedCharValue);
        else if (STRCMP_ENCODE(short)) SQLITE_BIND_INT(shortValue);
        else if (STRCMP_ENCODE(unsigned short)) SQLITE_BIND_INT(unsignedShortValue);
        else if (STRCMP_ENCODE(int)) SQLITE_BIND_INT(intValue);
        else if (STRCMP_ENCODE(unsigned int)) SQLITE_BIND_INT(unsignedIntValue);
        else if (STRCMP_ENCODE(long)) SQLITE_BIND_INT64(longValue);
        else if (STRCMP_ENCODE(unsigned long)) SQLITE_BIND_INT64(unsignedLongValue);
        else if (STRCMP_ENCODE(long long)) SQLITE_BIND_INT64(longLongValue);
        else if (STRCMP_ENCODE(unsigned long long)) SQLITE_BIND_INT64(unsignedLongLongValue);
        else if (STRCMP_ENCODE(float)) SQLITE_BIND_DOUBLE(floatValue);
        else if (STRCMP_ENCODE(double)) SQLITE_BIND_DOUBLE(doubleValue);
        else if (STRCMP_ENCODE(BOOL)) sqlite3_bind_int(pStmt, idx, ([obj boolValue] ? 1 : 0));
        else SQLITE_BIND_TEXT([obj description]);
    }
    else SQLITE_BIND_TEXT([obj description]);
}

#pragma mark-  excute sql method with block

- (BOOL)executeStatements:(NSString *)sql {
    return [self executeStatements:sql withResultBlock:nil];
}

- (BOOL)executeStatements:(NSString *)sql withResultBlock:(int(^)(NSDictionary *resultsDict))block {
    
    int rc;
    char *errmsg = nil;
    
    rc = sqlite3_exec(self.sqliteHandler,
                      sql.UTF8String,
                      block ? RWDatabaseExecuteBulkSQLCallback : nil,
                      (__bridge void *)(block),
                      &errmsg);
    
    if (errmsg && [self logsErrors]) {
        DBLog(@"执行%@发生错误：%s", sql, errmsg);
        sqlite3_free(errmsg);
    }
    
    return (rc == SQLITE_OK);
}

#pragma mark- 数据库操作事务

- (BOOL)rollback {
    BOOL b = [self executeUpdate:@"rollback transaction"];
    if (b) _inTransaction = NO;
    
    return b;
}

- (BOOL)commit {
    BOOL b =  [self executeUpdate:@"commit transaction"];
    if (b) _inTransaction = NO;
    
    return b;
}

- (BOOL)beginDeferredTransaction {
    BOOL b = [self executeUpdate:@"begin deferred transaction"];
    if (b)  _inTransaction = YES;
    
    return b;
}

- (BOOL)beginTransaction {
    BOOL b = [self executeUpdate:@"begin exclusive transaction"];
    if (b) _inTransaction = YES;
    
    return b;
}

- (BOOL)inTransaction {
    return _inTransaction;
}

#pragma mark- -------------------------------- core methods ⬆ -------------------------------------

#pragma mark-  关闭结果集

- (void)closeOpenResultSet {
    
    for (NSValue *rsInWrappedInATastyValueMeal in _openResultSet) {
        RWResultSet *rs = (RWResultSet *)[rsInWrappedInATastyValueMeal pointerValue];
        
        [rs setParentDB:nil];
        [rs close];
        
        [_openResultSet removeObject:rsInWrappedInATastyValueMeal];
    }
}

- (void)resultSetDidClose:(RWResultSet *)resultSet {
    NSValue *setValue = [NSValue valueWithNonretainedObject:resultSet];
    [_openResultSet removeObject:setValue];
}

#pragma mark-  sqlite语句的缓存

- (void)clearCachedStatements {
    
    for (NSMutableSet *statements in _cachedStatements.objectEnumerator) {
        [statements makeObjectsPerformSelector:@selector(close)];
    }
    
    [_cachedStatements removeAllObjects];
}

- (RWStatement *)cachedStatementForQuery:(NSString *)query {
    
    NSMutableSet *statements = _cachedStatements[query];
    
    return [[statements objectsPassingTest:^BOOL(RWStatement *statement, BOOL *stop) {
        *stop = !statement.inUse;
        return *stop;
        
    }] anyObject];
}

- (void)setCachedStatement:(RWStatement *)statement forQuery:(NSString *)query {
    [statement setQuery:query];
    NSMutableSet* statements = _cachedStatements[query];
    if (!statements) statements = [NSMutableSet set];
    
    [statements addObject:statement];
    _cachedStatements[query] = statements;
}


#pragma mark-  date formatter

- (BOOL)hasDateFormatter {
    return _dateFormat != nil;
}

- (void)setDateFormat:(NSDateFormatter *)format {
    _dateFormat = format;
}

- (NSDate *)dateFromString:(NSString *)string {
    return [_dateFormat dateFromString:string];
}

- (NSString *)stringFromDate:(NSDate *)date {
    return [_dateFormat stringFromDate:date];
}

#pragma mark-  warning and reporter

- (BOOL)databaseExists {
    
    if (!_db) {
        DBLog(@"数据库[%@] 没有打开", self);
        DBLog(@"The RWDatabase %@ is not open.", self);
        
#ifndef NS_BLOCK_ASSERTIONS
        if (_crashOnErrors) {
            NSAssert(false, @"数据库[%@] 没有打开", self);
            abort();
        }
#endif
        return NO;
    }
    return YES;
}

- (void)warnInUse {
    DBLog(@"数据库[%@]正在被使用", self);
    
#ifndef NS_BLOCK_ASSERTIONS
    if (_crashOnErrors) {
        NSAssert(false, @"数据库[%@]正在被使用", self);
        abort();
    }
#endif
}

- (int)lastErrorCode {
    return sqlite3_errcode(_db);
}

- (BOOL)hadError {
    int lastErrCode = [self lastErrorCode];
    return (lastErrCode > SQLITE_OK && lastErrCode < SQLITE_ROW);
}

- (NSError*)lastError {
    return [self errorWithMessage:[self lastErrorMessage]];
}

- (NSString*)lastErrorMessage {
    return [NSString stringWithUTF8String:sqlite3_errmsg(_db)];
}

- (NSError *)errorWithMessage:(NSString *)message {
    return [NSError errorWithDomain:@"RWDatabase"
                               code:sqlite3_errcode(_db)
                           userInfo:@{NSLocalizedDescriptionKey:message}];
}

#pragma mark-   设置最大重试间隔

- (void)setMaxBusyRetryTimeInterval:(NSTimeInterval)maxBusyRetryTimeInterval {
    _maxBusyRetryTimeInterval = maxBusyRetryTimeInterval;
    
    if (!_db) return;
    
    if (maxBusyRetryTimeInterval) {
        // 数据库繁忙时 尝试一波gank
        sqlite3_busy_handler(_db, &RWDatabaseBusyHandler, (__bridge void *)(self));
    }
    else {
        //  重试间隔为0  收家伙走人 关闭sqlite
        sqlite3_busy_handler(_db, nil, nil);
    }
}

- (NSTimeInterval)maxBusyRetryTimeInterval {
    return _maxBusyRetryTimeInterval;
}

#pragma mark-  function

FOUNDATION_STATIC_INLINE int RWDatabaseBusyHandler(void *_self, int count) {
    RWDatabase *self = (__bridge RWDatabase *)_self;
    
    if (count == 0) {
        self->_startBusyRetryTime = [NSDate timeIntervalSinceReferenceDate];
        return 1;
    }
    
    NSTimeInterval delta = [NSDate timeIntervalSinceReferenceDate] - (self->_startBusyRetryTime);
    
    if (delta < self.maxBusyRetryTimeInterval) {
        int requestedSleepInMillseconds = (int) arc4random_uniform(50) + 50;
        int actualSleepInMilliseconds = sqlite3_sleep(requestedSleepInMillseconds);
        if (actualSleepInMilliseconds != requestedSleepInMillseconds) {
            DBLog(@"警告：要求数据库挂起[%i]毫秒，但sqlite只返回[%i]。看看是不是设置了HAVE_USLEEP=1",requestedSleepInMillseconds, actualSleepInMilliseconds);
        }
        return 1;
    }
    
    return 0;
}

NS_INLINE int RWDatabaseExecuteBulkSQLCallback(void *theBlockAsVoid, int columns, char **values, char **names) {
    
    if (!theBlockAsVoid) return SQLITE_OK;
    
    int (^execCallbackBlock)(NSDictionary *resultsDict) = (__bridge int (^)(NSDictionary *__strong))(theBlockAsVoid);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:columns];
    
    for (NSInteger i = 0; i < columns; i++) {
        NSString *key = [NSString stringWithUTF8String:names[i]];
        id value = values[i] ? [NSString stringWithUTF8String:values[i]] : [NSNull null];
        dictionary[key] = value;
    }
    return execCallbackBlock(dictionary);
}

@end


#pragma mark-  RWStatement

@implementation RWStatement

- (void)close {
    if (_sqlStatement) {
        sqlite3_finalize(_sqlStatement);
        _sqlStatement = 0x00;
    }
    
    _inUse = NO;
}

- (void)reset {
    if (_sqlStatement) sqlite3_reset(_sqlStatement);
    _inUse = NO;
}

@end

#pragma mark-  RWResultSet

@interface RWResultSet () {
    @package
    RWDatabase *_parentDB;
}

@end

@implementation RWResultSet

@dynamic resultDictionary;

@synthesize columnNameToIndexMap = _columnNameToIndexMap;

+ (instancetype)resultSetWithStatement:(RWStatement *)statement usingParentDatabase:(RWDatabase *)aDB {
    
    RWResultSet *rs = [[RWResultSet alloc] init];
    
    [rs setMyStatement:statement];
    [rs setParentDB:aDB];
    
    NSParameterAssert(!statement.inUse);
    [statement setInUse:YES];
    
    return rs;
}

- (void)setParentDB:(RWDatabase *)parentDB {
    _parentDB = parentDB;
}

- (BOOL)next {
    return [self nextWithError:nil];
}

- (BOOL)nextWithError:(NSError *__autoreleasing *)outErr {
    int rc = sqlite3_step(_myStatement.sqlStatement);
    
    if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
        DBLog(@"[%s:%d] 数据库繁忙 [%@]",__FUNCTION__, __LINE__, _parentDB.dbPath);
        if (outErr)  *outErr = _parentDB.lastError;
    }
    else if (SQLITE_DONE == rc || SQLITE_ROW == rc) { DBLog(@"[SQLITE_DONE]检索结果集成功"); }
    else if (SQLITE_ERROR == rc) {
        DBLog(@"错误[SQLITE_ERROR]：调用 sqlite3_step (%d: %s) 发生错误", rc, sqlite3_errmsg(_parentDB.sqliteHandler));
        if (outErr) *outErr = _parentDB.lastError;
    }
    else if (SQLITE_MISUSE == rc) {
        DBLog(@"错误[SQLITE_MISUSE]：调用 sqlite3_step (%d: %s) 发生错误", rc, sqlite3_errmsg(_parentDB.sqliteHandler));
        if (outErr) {
            if (_parentDB)  *outErr = _parentDB.lastError;
            else {
                NSDictionary* errorMessage = [NSDictionary dictionaryWithObject:@"parentDB does not exist" forKey:NSLocalizedDescriptionKey];
                *outErr = [NSError errorWithDomain:@"RWDatabase" code:SQLITE_MISUSE userInfo:errorMessage];
            }
        }
    }
    else {
        DBLog(@"[未知错误]：调用 sqlite3_step (%d: %s) 发生错误", rc, sqlite3_errmsg(_parentDB.sqliteHandler));
        if (outErr) *outErr = _parentDB.lastError;
    }
    
    if (rc != SQLITE_ROW) [self close];
    
    return (rc == SQLITE_ROW);
}

- (void)close {
    [_myStatement reset];
    _myStatement = nil;
    
    [_parentDB resultSetDidClose:self];
    _parentDB = nil;
}

- (NSMutableDictionary *)columnNameToIndexMap {
    if (!_columnNameToIndexMap) {
        int columnCount = sqlite3_column_count(_myStatement.sqlStatement);
        _columnNameToIndexMap = [[NSMutableDictionary alloc] initWithCapacity:columnCount];
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
            [_columnNameToIndexMap setObject:@(columnIdx)
                                      forKey:[[NSString stringWithUTF8String:sqlite3_column_name(_myStatement.sqlStatement, columnIdx)] lowercaseString]];
        }
    }
    return _columnNameToIndexMap;
}

- (NSDictionary *)resultDictionary {
    
    NSUInteger num_cols = sqlite3_data_count(_myStatement.sqlStatement);
    
    if (num_cols > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];
        
        int columnCount = sqlite3_column_count(_myStatement.sqlStatement);
        
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
            NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(_myStatement.sqlStatement, columnIdx)];
            id objectValue = [self objectForColumnIndex:columnIdx];
            dict[columnName] = objectValue;
        }
        
        return dict;
    }
    else DBLog(@"[警告]：集合中未找到该列的数据");
    return nil;
}

#pragma mark-  按表中列名或者索引进行检索

- (id)objectForColumnIndex:(int)columnIdx {
    int columnType = sqlite3_column_type(_myStatement.sqlStatement, columnIdx);
    
    id returnValue = nil;
    
    if (columnType == SQLITE_INTEGER)
        returnValue = [NSNumber numberWithLongLong:[self longLongIntForColumnIndex:columnIdx]];
    else if (columnType == SQLITE_FLOAT)
        returnValue = [NSNumber numberWithDouble:[self doubleForColumnIndex:columnIdx]];
    else if (columnType == SQLITE_BLOB)  returnValue = [self dataForColumnIndex:columnIdx];
    else returnValue = [self stringForColumnIndex:columnIdx];
    
    return returnValue ? returnValue : [NSNull null];
}

- (id)objectForColumnName:(NSString *)columnName {
    return [self objectForColumnIndex:[self columnIndexForName:columnName]];
}

- (int)columnIndexForName:(NSString *)columnName {
    columnName = [columnName lowercaseString];
    
    NSNumber *n = self.columnNameToIndexMap[columnName];
    
    if (n) {
        return [n intValue];
    }
    DBLog(@"【警告]：找不到[%@]对应的列", columnName);
    return -1;
}

- (NSString*)columnNameForIndex:(int)columnIdx {
    return [NSString stringWithUTF8String:sqlite3_column_name(_myStatement.sqlStatement, columnIdx)];
}

- (int)intForColumn:(NSString *)columnName {
    return [self intForColumnIndex:[self columnIndexForName:columnName]];
}

- (int)intForColumnIndex:(int)columnIdx {
    return sqlite3_column_int(_myStatement.sqlStatement, columnIdx);
}

- (long)longForColumn:(NSString *)columnName {
    return [self longForColumnIndex:[self columnIndexForName:columnName]];
}

- (long)longForColumnIndex:(int)columnIdx {
    return (long)sqlite3_column_int64(_myStatement.sqlStatement, columnIdx);
}

- (long long int)longLongIntForColumnIndex:(int)columnIdx {
    return sqlite3_column_int64(_myStatement.sqlStatement, columnIdx);
}

- (unsigned long long int)unsignedLongLongIntForColumn:(NSString *)columnName {
    return [self unsignedLongLongIntForColumnIndex:[self columnIndexForName:columnName]];
}

- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx {
    return (unsigned long long int)[self longLongIntForColumnIndex:columnIdx];
}

- (BOOL)boolForColumn:(NSString *)columnName {
    return [self boolForColumnIndex:[self columnIndexForName:columnName]];
}

- (BOOL)boolForColumnIndex:(int)columnIdx {
    return ([self intForColumnIndex:columnIdx] != 0);
}

- (double)doubleForColumn:(NSString *)columnName {
    return [self doubleForColumnIndex:[self columnIndexForName:columnName]];
}

- (double)doubleForColumnIndex:(int)columnIdx {
    return sqlite3_column_double(_myStatement.sqlStatement, columnIdx);
}

- (NSDate *)dateForColumn:(NSString *)columnName {
    return [self dateForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate *)dateForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(_myStatement.sqlStatement, columnIdx) == SQLITE_NULL || (columnIdx < 0))
        return nil;
    
    return [_parentDB hasDateFormatter] ? [_parentDB dateFromString:[self stringForColumnIndex:columnIdx]] : [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIdx]];
}

- (NSData *)dataForColumn:(NSString *)columnName {
    return [self dataForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData *)dataForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(_myStatement.sqlStatement, columnIdx) == SQLITE_NULL || (columnIdx < 0))
        return nil;
    
    const char *dataBuffer = sqlite3_column_blob(_myStatement.sqlStatement, columnIdx);
    int dataSize = sqlite3_column_bytes(_myStatement.sqlStatement, columnIdx);
    
    return (dataBuffer == NULL) ? nil : [NSData dataWithBytes:(const void *)dataBuffer
                                                       length:(NSUInteger)dataSize];
}

- (NSData *)dataNoCopyForColumn:(NSString *)columnName {
    return [self dataNoCopyForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData *)dataNoCopyForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(_myStatement.sqlStatement, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    const char *dataBuffer = sqlite3_column_blob(_myStatement.sqlStatement, columnIdx);
    int dataSize = sqlite3_column_bytes(_myStatement.sqlStatement, columnIdx);
    
    return [NSData dataWithBytesNoCopy:(void *)dataBuffer
                                length:(NSUInteger)dataSize
                          freeWhenDone:NO];
}

- (NSString *)stringForColumn:(NSString *)columnName {
    return [self stringForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSString *)stringForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(_myStatement.sqlStatement, columnIdx) == SQLITE_NULL || (columnIdx < 0))
        return nil;
    
    const char *ch = (const char *)sqlite3_column_text(_myStatement.sqlStatement, columnIdx);
    
    return ch ? [NSString stringWithUTF8String:ch] : nil;
}

- (BOOL)columnIndexIsNull:(int)columnIdx {
    return sqlite3_column_type(_myStatement.sqlStatement, columnIdx) == SQLITE_NULL;
}

- (BOOL)columnIsNull:(NSString *)columnName {
    return [self columnIndexIsNull:[self columnIndexForName:columnName]];
}

@end

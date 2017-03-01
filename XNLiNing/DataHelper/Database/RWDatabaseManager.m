//
//  RWDatabaseManager.m
//  Test0701
//
//  Created by Ranger on 16/7/1.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWDatabaseManager.h"
#import "RWDatabase.h"
#import "CocoaCracker.h"

#ifdef DEBUG
# define DBLog(...) NSLog(__VA_ARGS__);
#else
# define DBLog(...);
#endif

@interface RWDatabaseManager () {
    dispatch_queue_t _dbQueue;
    RWDatabase *_database;
}

@end

@implementation RWDatabaseManager

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self == [super init]) {
        
    }
    return self;
}

#pragma mark-  open data base

- (void)open:(NSString *)sqliteFilePath dict:(NSDictionary<NSString *, Class> *)tableDict {
    [self open:sqliteFilePath dict:tableDict done:nil];
}

- (void)open:(NSString *)sqliteFilePath dict:(NSDictionary<NSString *, Class> *)tableDict done:(void(^)(BOOL success))done {
    if (_database) {
        [_database close];
        _database = nil;
    }
    
    _dbQueue = dispatch_queue_create("com.rangerchiong.com.rwdatabase", DISPATCH_QUEUE_SERIAL);
    
    _database = [RWDatabase databaseWithPath:sqliteFilePath];
    _database.shouldCacheStatements = YES;
    
    if (!_database.open) {
        !done ?: done(NO);
        return;
    }
    else {
        dispatch_async(_dbQueue, ^{
            __block BOOL result = YES;
            if (tableDict) {
                [tableDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, Class cls, BOOL *stop) {
                    if (![_database tableExists:key]) {
                        if (![self makeCreateSql:key tableModelClass:cls]) {
                            DBLog(@"数据库表格: [%@] 创建失败", key);
                            *stop = YES;
                            result = NO;
                        }
                    }
                }];
            }else {
                DBLog(@"传入的字典['modelName' : 'modelClass']不能为空");
                result = NO;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !done ?: done(result);
            });
        });
    }
}

#pragma mark-   插入数据

- (void)insert:(NSString *)tableName models:(NSArray<NSDictionary *> *)modelArr {
    [self insert:tableName models:modelArr done:nil];
}

- (void)insert:(NSString *)tableName models:(NSArray<NSDictionary *> *)modelArr done:(void(^)(BOOL success))done {
    
    dispatch_async(_dbQueue, ^{
        [_database beginTransaction];
        BOOL bRet = NO;
        @try {
            for (NSDictionary *keyValues in modelArr) {
                bRet = [self makeInsertSql:tableName keyValues:keyValues];
                if (!bRet) {
                    DBLog(@"向[%@] 表中插入 [%@] 的数据 失败", tableName, keyValues);
                    break;
                }
            }
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (!bRet) {
                [_database rollback];
            }
            else {
                [_database commit];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done(bRet);
        });
    });
}

#pragma mark-   删除表

- (void)dropTable:(NSString *)tableName {
    
    dispatch_async(_dbQueue, ^{
//        if (_database.open) {
//            [_database close];
//        }
//        [_database beginTransaction];
        BOOL bRet = NO;
//        @try {
            bRet = [self makeDropSql:tableName];
            if (!bRet) {
                DBLog(@"删除表失败 [%@]", tableName);
            } else {
                DBLog(@"删除 [ %@ ] 表成功", tableName);
            }
//        }
//        @catch (NSException *exception) {
//            [_database rollback];
//        }
//        @finally {
//            if (!bRet) {
//                [_database rollback];
//            }
//            else {
//                [_database commit];
//            }
//        }
//
//        [_database open];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

}

- (void)deleteData:(NSString *)tableName conditions:(NSArray<NSDictionary *> *)conditions {
    [self deleteData:tableName conditions:conditions done:nil];
}

- (void)deleteData:(NSString *)tableName conditions:(NSArray<NSDictionary *> *)conditions done:(void(^)(BOOL success))done {
    dispatch_async(_dbQueue, ^{
        [_database beginTransaction];
        BOOL bRet = NO;
        @try {
            for (NSDictionary *condition in conditions) {
                bRet = [self makeDeleteSql:tableName condition:condition];
                if (!bRet) {
                    DBLog(@"删除[%@]表的数据 失败 condition:%@", tableName, condition);
                    break;
                }
            }
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (!bRet) {
                [_database rollback];
            }
            else {
                [_database commit];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done(bRet);
        });
        
    });
}

#pragma mark-   更新数据

- (void)update:(NSString *)tableName param:(NSDictionary *)param condition:(NSDictionary *)condition {
    [self update:tableName param:param condition:condition done:nil];
}

- (void)update:(NSString *)tableName
         param:(NSDictionary *)param
     condition:(NSDictionary *)condition
          done:(void(^)(BOOL success))done {
    dispatch_async(_dbQueue, ^{
        [_database beginTransaction];
        BOOL bRet = NO;
        @try {
            bRet = [self makeUpdateSql:tableName param:param condition:condition];
            if (!bRet) {
                DBLog(@"更新[%@]表的数据 失败 condition:%@", tableName, condition);
            }
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (!bRet) {
                [_database rollback];
            }
            else {
                [_database commit];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done(bRet);
        });
        
    });
}


#pragma mark-   查找数据
// 查找表中所有数据
- (void)queryAll:(NSString *)tableName perRow:(nullable void(^)(NSDictionary *dict))block done:(dispatch_block_t)done {
    dispatch_async(_dbQueue, ^{
        RWResultSet *result = [_database executeQuery:[self queryAllStatement:tableName]];
        while ([result next]) {
            NSDictionary *dict = [result resultDictionary];
            !block ?: block(dict);
        }
        [result close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done();
        });
    });
}

// 根据条件查找表中数据
- (void)query:(NSString *)tableName condition:(NSDictionary *)condition perRow:(nullable void(^)(NSDictionary *dict))block done:(dispatch_block_t)done {
    dispatch_async(_dbQueue, ^{
        RWResultSet *result = [self makeQuerySql:tableName condition:condition];
        while ([result next]) {
            NSDictionary *dict = [result resultDictionary];
            !block ?: block(dict);
        }
        [result close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done();
        });
    });
}

// 按照传入的字段指定顺序查找表中数据
- (void)query:(NSString *)tableName condition:(NSArray<NSString *> *)condition isOrder:(BOOL)isOrder perRow:(void(^)(NSDictionary *dict))block done:(dispatch_block_t)done {
    dispatch_async(_dbQueue, ^{
        RWResultSet *result = [self makeQuerySql:tableName condition:condition isOrder:isOrder];
        while ([result next]) {
            NSDictionary *dict = [result resultDictionary];
            !block ?: block(dict);
        }
        [result close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done();
        });
    });
}

#pragma mark-   make sql statements methods

- (BOOL)makeCreateSql:(NSString *)tableName tableModelClass:(Class)cls {
    __block NSString *tmpSql = @"";
    [[CocoaCracker handle:cls] copyPropertyInfo:^(NSString *pName, NSString *pType) {
        NSString *tmpStr = [self typeNameWithPropertyAttri:pType];
        tmpSql = [tmpSql stringByAppendingString:[NSString stringWithFormat:@" ,%@ %@", pName, tmpStr]];
    } copyAttriEntirely:NO];
    
    if (!tmpSql) return NO;
    
    NSString *sql = [self createStatement:tableName params:tmpSql];
    BOOL result = [_database executeUpdate:sql];
    
    return result;
}

- (BOOL)makeInsertSql:(NSString *)tableName keyValues:(NSDictionary *)keyValues {
    /***    INSERT INTO tableName [insertKey] VALUES [insertValue]   ***/
    __block NSString *insertKey = @"" , *insertValue = @"";
    
    [keyValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * stop) {
        insertKey = [insertKey stringByAppendingString:[NSString stringWithFormat:@",%@ ", key]];
        insertValue = [insertValue stringByAppendingString:[NSString stringWithFormat:@",:%@ ", key]];
    }];
    
    // 结束遍历时  将开头多余的","删掉
    if (!insertKey.length) return NO;
    insertKey = [insertKey substringFromIndex:1];
    
    if (!insertValue.length) return NO;
    insertValue = [insertValue substringFromIndex:1];
    NSString *sql = [self insertStatement:tableName key:insertKey value:insertValue];
    BOOL bRet = [_database executeUpdate:sql withParameterDictionary:keyValues];
    
    return bRet;
}

- (BOOL)makeUpdateSql:(NSString *)tableName param:(NSDictionary *)param condition:(NSDictionary *)condition {
    
    __block NSString *paramStr = @"";
    [param enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * stop) {
        paramStr = [paramStr stringByAppendingString:[NSString stringWithFormat:@",%@ = %@",key, param[key]]];
    }];
    if (!paramStr.length) return NO;
    paramStr = [paramStr substringFromIndex:1];
    
    __block NSString *conditionStr = @"";
    [condition enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * stop) {
        conditionStr = [conditionStr stringByAppendingString:[NSString stringWithFormat:@" AND %@ = %@",key, condition[key]]];
    }];
    if (!conditionStr.length) return NO;
    conditionStr = [conditionStr substringFromIndex:5];
    
    NSString *sql = [self updateStatement:tableName params:paramStr condition:conditionStr];
    BOOL bRet = [_database executeUpdate:sql ];
    return bRet;
}

- (BOOL)makeDropSql:(NSString *)tableName {
    BOOL result = [_database tableExists:tableName];
    if (result) {
        NSString *sql = [self dropTableStatement:tableName];
        result = [_database executeUpdate:sql];
    }
    else {
        DBLog(@"表[%@]不存在", tableName);
    }
    return result;
}

- (BOOL)makeDeleteSql:(NSString *)tableName condition:(NSDictionary *)condition {
    __block NSString *keyValue = @"";
    [condition enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * stop) {
        keyValue = [keyValue stringByAppendingString:[NSString stringWithFormat:@" AND %@ = '%@'",key, value]];
    }];
    
    if (!keyValue.length) return NO;
    keyValue = [keyValue substringFromIndex:5];
    
    NSString *sql = [self deleteStatement:tableName condition:keyValue];
    BOOL result = [_database executeUpdate:sql];
    return result;
}

- (RWResultSet *)makeQuerySql:(NSString *)tableName condition:(NSDictionary *)condition {
    __block NSString *keyValue = @"";
    [condition enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * stop) {
        keyValue = [keyValue stringByAppendingString:[NSString stringWithFormat:@" AND %@ = '%@'",key, value]];
    }];
    
    if (!keyValue.length) return nil;
    keyValue = [keyValue substringFromIndex:5];
    
    NSString *sql = [self queryStatement:tableName condition:keyValue];
    DBLog(@"%@", sql);
    return [_database executeQuery:sql];
}

- (RWResultSet *)makeQuerySql:(NSString *)tableName condition:(NSArray *)condition isOrder:(BOOL)isOrder {
    NSString *conditionStr = @"";
    for (NSString *key in condition) {
        conditionStr = [conditionStr stringByAppendingString:[NSString stringWithFormat:@",%@ %@",key, isOrder ? @"DESC" : @"ASC"]];
    }
    if (!conditionStr.length) return nil;
    conditionStr = [conditionStr substringFromIndex:1];
    NSString *sql = [self queryOrderlyStatement:tableName condition:conditionStr];
    DBLog(@"%@", sql);
    return [_database executeQuery:sql];
}

#pragma mark-   sql statements

// craete sql
- (NSString *)createStatement:(NSString *)tableName params:(NSString *)params {
    return [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id Integer PRIMARY KEY %@)", tableName, params];
}

// insert sql
- (NSString *)insertStatement:(NSString *)tableName key:(NSString *)key value:(NSString *)value {
    return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, key, value];
}

// delete sql
- (NSString *)deleteStatement:(NSString *)tableName condition:(NSString *)condition {
    return [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", tableName, condition];
}

- (NSString *)dropTableStatement:(NSString *)tableName {
    return [NSString stringWithFormat:@"DROP TABLE %@", tableName];
}

// update
- (NSString *)updateStatement:(NSString *)tableName params:(NSString *)params condition:(NSString *)condition {
    return [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", tableName, params, condition];
}

// query sql
- (NSString *)queryAllStatement:(NSString *)tableName {
    return [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
}

// select * from Contacts limit 15 offset 20     表示: 从Contacts表跳过20条记录选出15条记录
- (NSString *)queryStatement:(NSString *)tableName showRecords:(NSInteger)rNum stepRecords:(NSInteger)sNum {
    return [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %ld offset %ld ", tableName, rNum, sNum];
}

- (NSString *)queryStatement:(NSString *)tableName condition:(NSString *)condition {
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", tableName, condition];
}

- (NSString *)queryOrderlyStatement:(NSString *)tableName condition:(NSString *)condition {
    return [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@", tableName, condition];
}

#pragma mark-  property map

- (NSString *)typeNameWithPropertyAttri:(NSString *)pAttri {
    NSString *pType;
    
    if ([pAttri hasPrefix:@"@"]) {
        // 去除符号 @ 和 "
        pAttri = [[pAttri stringByReplacingOccurrencesOfString:@"\"" withString:@""] substringFromIndex:1];
        pType = self.propertyTypeMap[pAttri];
    }
    else pType = self.propertyTypeMap[pAttri];
    if (!pType.length) DBLog(@"%@ 不是支持的属性类型", pAttri);
    return pType;
}

- (NSDictionary *)propertyTypeMap {
    return @{
             @"NSString" : @"text",
             @"NSDate" : @"text",
             @"NSData" : @"blob",
             @"NSNumber" : @"integer",
             @"q" : @"integer",
             @"Q" : @"integer",
             @"i" : @"integer",
             @"I" : @"integer",
             @"B" : @"integer",
             @"c" : @"integer",
             @"S" : @"integer",
             @"s" : @"integer",
             @"d" : @"real",
             @"f" : @"real",
             };
}

@end

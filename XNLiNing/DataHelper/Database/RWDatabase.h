//
//  RWDatabase.h
//  Test0701
//
//  Created by Ranger on 16/7/1.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class RWResultSet;

@interface RWDatabase : NSObject

@property (copy, readonly) NSString *dbPath;            //!< 数据库文件路径
@property (readonly) BOOL open;                         //!< 打开数据库
@property (readonly) BOOL close;                        //!< 关闭数据库
@property NSTimeInterval maxBusyRetryTimeInterval;      //!< 数据库操作繁忙状态下的重试时间间隔
@property (readonly) sqlite3 *sqliteHandler;            //!< 获得当前操作数据库的实例
@property (readonly) BOOL    rollback;                  //!< 操作失败 回滚
@property (readonly) BOOL    commit;                    //!< 操作成功 提交事务
@property (readonly) BOOL    beginDeferredTransaction;  //!< 延迟操作事务
@property (readonly) BOOL    beginTransaction;  //!< 开始操作事务
@property (readonly) BOOL    inTransaction;     //!< 是否处理数据库事务操作中
@property BOOL           shouldCacheStatements; //!< 缓存sqlite语句
@property BOOL           traceExecution;        //!< 是否追踪正在发生的sqlite操作 就是把当前语句打印出来
@property BOOL           logsErrors;            //!< 是否打印错误日志 默认YES
@property BOOL           crashOnErrors;         //!< 是否使用断言调试  默认NO
@property (readonly) int      lastErrorCode;    //!< 最近的操作错误码
@property (readonly) BOOL     hadError;         //!< 是否出现错误码
@property (readonly) NSError  *lastError;       //!< 最近生成的错误类error
@property (readonly) NSString *lastErrorMessage;//!< 最近的错误日志

// 初始化
+ (instancetype)databaseWithPath:(NSString *)aPath;
- (instancetype)init;
- (instancetype)initWithPath:(NSString *)aPath;

- (BOOL)tableExists:(NSString *)tableName;

/** udpate methods */
- (BOOL)executeUpdate:(NSString*)sql, ...;
- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;
- (BOOL)executeUpdate:(NSString*)sql withVAList:(va_list)args;
- (BOOL)executeUpdate:(NSString*)sql
 withArgumentsInArray:(NSArray*)arrayArgs
         orDictionary:(NSDictionary *)dictionaryArgs
             orVAList:(va_list)args
                error:(NSError**)outErr;

/** query methods */
- (RWResultSet *)executeQuery:(NSString*)sql, ...;
- (RWResultSet *)executeQuery:(NSString*)sql withVAList:(va_list)args;
- (RWResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;
- (RWResultSet *)executeQuery:(NSString *)sql
          withArgumentsInArray:(NSArray*)arrayArgs
                  orDictionary:(NSDictionary *)dictionaryArgs
                      orVAList:(va_list)args;

/** execute statement block */
- (BOOL)executeStatements:(NSString *)sql;
- (BOOL)executeStatements:(NSString *)sql withResultBlock:(int(^)(NSDictionary *resultsDict))block;

/** 清除sqlite语句的缓存 */
- (void)clearCachedStatements;

/** 关闭打开数据库得到的结果集 */
- (void)closeOpenResultSet;

/** 设置日期的格式 */
- (void)setDateFormat:(NSDateFormatter *)format;
/** 是否存在dataFormatter */
- (BOOL)hasDateFormatter;
- (NSDate *)dateFromString:(NSString *)string;
- (NSString *)stringFromDate:(NSDate *)date;

@end

#pragma mark-  RWStatement

@interface RWStatement : NSObject

@property sqlite3_stmt *sqlStatement;   //!< 数据库自己认识的sqlite语句变量
@property BOOL         inUse;           //!< 语句是否正在使用
@property long         useCount;        //!< 语句的使用数
@property (strong) NSString *query;     //!< 缓存sqlite的key

/** 清空sqlite语句 */
- (void)close;

/** 重置语句 */
- (void)reset;

@end

#pragma mark-  RWResultSet

@interface RWResultSet : NSObject

@property (strong) NSString *query;                             //!< 缓存sqlite的key
@property (strong) RWStatement *myStatement;                    //!< sqlite语句
@property (readonly) NSMutableDictionary *columnNameToIndexMap; //!< 记录表中数据名字对应的索引的字典
@property (readonly) NSDictionary *resultDictionary;            //!< 检索结束后 将数据以字典的形式返回

+ (instancetype)resultSetWithStatement:(RWStatement *)statement usingParentDatabase:(RWDatabase *)aDB;

- (void)setParentDB:(RWDatabase *)parentDB;

/** 检索结果集的下一行数据 */
- (BOOL)next;

/** 检索结果集的下一行数据 */
- (BOOL)nextWithError:(NSError **)outErr;

/** 关闭结果集 */
- (void)close;

- (id)objectForColumnIndex:(int)columnIdx;
- (id)objectForColumnName:(NSString*)columnName;
- (int)columnIndexForName:(NSString*)columnName;
- (NSString*)columnNameForIndex:(int)columnIdx;
- (int)intForColumn:(NSString*)columnName;
- (int)intForColumnIndex:(int)columnIdx;
- (long)longForColumn:(NSString*)columnName;
- (long)longForColumnIndex:(int)columnIdx;
- (long long int)longLongIntForColumnIndex:(int)columnIdx;
- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName;
- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx;
- (BOOL)boolForColumn:(NSString*)columnName;
- (BOOL)boolForColumnIndex:(int)columnIdx;
- (double)doubleForColumn:(NSString*)columnName;
- (double)doubleForColumnIndex:(int)columnIdx;
- (NSDate*)dateForColumn:(NSString*)columnName;
- (NSDate*)dateForColumnIndex:(int)columnIdx;
- (NSData*)dataForColumn:(NSString*)columnName;
- (NSData*)dataForColumnIndex:(int)columnIdx;
- (NSData*)dataNoCopyForColumn:(NSString*)columnName;
- (NSData*)dataNoCopyForColumnIndex:(int)columnIdx;
- (NSString*)stringForColumn:(NSString*)columnName;
- (NSString*)stringForColumnIndex:(int)columnIdx;
- (BOOL)columnIndexIsNull:(int)columnIdx;
- (BOOL)columnIsNull:(NSString*)columnName;

@end


//
//  XNCacheHelper.h
//  XNLiNing
//
//  Created by Dandre on 2018/3/5.
//  Copyright © 2018年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNCacheHelper : NSObject

/**
 缓存网络数据

 @param response 服务器返回数据
 @param key 缓存数据对应的key,推荐用请求的URL
 */
+ (void)saveResponseCache:(id)response forKey:(NSString *)key;


/**
 取出缓存的数据

 @param key 根据存入时填入key值取出对应的数据
 */
+ (id)getResponseCacheForKey:(NSString *)key;


/**
 根据某个值删除缓存

 @param key
 */
+ (void)removeCacheForKey:(NSString *)key;


/**
 清除所有数据
 */
+ (void)removeAllCache;


/**
 存储文件

 @param key 缓存数据对应的key值
 @param file 文件
 @param fileName 文件名称
 @return 存储的位置
 */
+ (NSString *)saveFileWithKey:(NSString *)key file:(id)file fileName:(NSString *)fileName;


/**
 得到存储的文件

 @param key 存储的key
 @return 返回文件
 */
+ (id)getFileWithKey:(NSString *)key;


/**
 得到文件存储的路径

 @return 返回路径
 */
+ (NSString *)getFilePath;
@end

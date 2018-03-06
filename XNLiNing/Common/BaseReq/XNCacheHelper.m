//
//  XNCacheHelper.m
//  XNLiNing
//
//  Created by Dandre on 2018/3/5.
//  Copyright © 2018年 xunan. All rights reserved.
//

#import "XNCacheHelper.h"
#import <YYKit.h>
#import <YYCache.h>

@implementation XNCacheHelper

static NSString *const XNNetworkResponseCache = @"XNNetworkResponseCache";
static YYCache *_dataCache;
static YYKVStorage *_diskCache;

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:XNNetworkResponseCache];
    NSString *downloadDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    _diskCache = [[YYKVStorage alloc] initWithPath:downloadDir type:YYKVStorageTypeFile];
}

+ (void)saveResponseCache:(id)response forKey:(NSString *)key {
    // 异步缓存, 不会阻塞主线程
    [_dataCache setObject:response forKey:key withBlock:nil];
}

+ (id)getResponseCacheForKey:(NSString *)key {
    return [_dataCache objectForKey:key];
}

+ (void)removeCacheForKey:(NSString *)key {
    [_dataCache removeObjectForKey:key];
}

+ (void)removeAllCache {
    [_dataCache removeAllObjects];
}

+ (NSString *)saveFileWithKey:(NSString *)key file:(id)file fileName:(NSString *)fileName {
    [_diskCache saveItemWithKey:key value:file filename:fileName extendedData:nil];
    return _diskCache.path;
}

+ (id)getFileWithKey:(NSString *)key {
    return [_diskCache getItemForKey:key];
}

+ (NSString *)getFilePath {
    return _diskCache.path;
}

@end


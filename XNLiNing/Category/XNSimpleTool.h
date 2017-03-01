//
//  XNSimpleTool.h
//  XNToolDemo
//
//  Created by xunan on 2016/12/27.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNSimpleTool : NSObject

/** 创建文件夹 */
+ (void)createDirectory:(NSString *)dirPath;

/** 生成随机UUID */
+ (NSString *)makeUUID;

/** 设置某文件(夹)不备份到iCloud */
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePath;

/** 获取系统剩余可用容量 返回 MB */
+ (uint64_t)freeDiskSpace;
/** 获取系统全部磁盘容量 返回 MB */
+ (uint64_t)totalDiskSpace;

/*!
 *  获取手机唯一标识
 */
+ (NSString *)deviceIdentifier;
/**
 *  获取手机设备
 */
+ (NSString *)getCurrentDeviceModel;

@end

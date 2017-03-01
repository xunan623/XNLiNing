//
//  XNSimpleTool.m
//  XNToolDemo
//
//  Created by xunan on 2016/12/27.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import "XNSimpleTool.h"
#import <sys/mount.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import "SSKeychain.h"

@implementation XNSimpleTool

#pragma mark-   创建文件夹

+ (void)createDirectory:(NSString *)dirPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirector = NO;
    BOOL isExiting = [fileManager fileExistsAtPath:dirPath isDirectory:&isDirector];
    if (!(isExiting && isDirector)){
        BOOL createDirection = [fileManager createDirectoryAtPath:dirPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        if (!createDirection)
            NSLog(@"创建文件夹失败：%@", dirPath);
    }
}

#pragma mark-   生成随机UUID

+ (NSString *)makeUUID {
    // 生成随机不重复的uuid
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *str_uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    
    // OC风格的创建 ：NSString *str_uuid = [[NSUUID UUID] UUIDString];
    // 将生成的uuid中的@"-"去掉
    NSString *str_name = [str_uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(puuid);
    CFRelease(uuidString);
    return str_name;
}

#pragma mark-   设置某个文件或文件夹不经过iCloud备份

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePath {
    assert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    NSURL* URL = [NSURL fileURLWithPath:filePath];
    NSError *error = nil;
    BOOL success = [URL setResourceValue:@(YES)
                                  forKey:NSURLIsExcludedFromBackupKey error:&error];
    if(!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark-  获取系统剩余空间

+ (uint64_t)freeDiskSpace {
    //    struct statfs buf;
    //    int64_t freespace = -1;
    //    if (statfs("/var", &buf) >= 0){
    //        freespace = (int64_t)(buf.f_bsize * buf.f_bfree);
    //    }
    //    return (uint64_t)(freespace / pow(1024, 2));
    
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes[NSFileSystemFreeSize] longLongValue] / pow(1024, 2);
}

+ (uint64_t)totalDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes[NSFileSystemSize] longLongValue] / pow(1024, 2);
}

#pragma mark-  获取手机唯一标识

+ (NSString *)deviceIdentifier {
    NSString *executableFiel = [[[NSBundle mainBundle] infoDictionary]objectForKey:(NSString *)kCFBundleIdentifierKey];
    
    NSString *strUUID = [SSKeychain passwordForService:executableFiel account:@"UUID"];
    
    if (strUUID == nil) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
        CFRelease(uuidRef);
        [SSKeychain setPassword:strUUID forService:executableFiel account:@"UUID"];
    }
    
    return strUUID;
}


/**
 *  获取手机设备
 */
+ (NSString *)getCurrentDeviceModel {
    //获得设备型号
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
    
    // 模拟器
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
    
}



@end

//
//  NSString+Ext.h
//  centanet
//
//  Created by Ranger on 16/8/8.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>


@interface NSString (Ext)

#pragma mark-  字符串高度宽度的计算
/**求取一般字符串高度**/
-(CGFloat)getStringHeight:(UIFont*)font width:(CGFloat)width;

/**求取一般字符串宽度**/
-(CGFloat)getStringWidth:(UIFont*)font Height:(CGFloat)height;

/**求取特殊字符串高度**/
-(CGFloat)mutableAttributedStringWithFont:(UIFont *)font
                                    width:(CGFloat)width
                             andLineSpace:(CGFloat)lineSpace;

/** 计算文字宽高 */
- (CGSize)stringSize:(UIFont *)font regularHeight:(CGFloat)height;


- (BOOL)hasSerialNumber:(NSUInteger)num;
/** 判断是否是纯数字 */
- (BOOL)isPureInt;
/** 判断是否是空字符串 */
- (BOOL)matchBlankSpace;

/** 判断国家码 */
- (BOOL)isValidMobliePhoneCountryCode;
/** 判断邮箱 */
- (BOOL)isValidEmailCode;
/** 判断区号 */
- (BOOL)isValidTelephoneAreaCode;
/** 判断手机号 */
- (BOOL)isValidMobilePhoneCode;
/** 判断国外手机 */
- (BOOL)isValidMobilePhoneForiCode;

/** 是否是固定电话 */
- (BOOL)isValidFixedTelephone;
/** 国外固话 */
- (BOOL)isValidFixedForiTelephone;

/** md5加密 */
+ (NSString *)getMd5Code:(NSString *)md5Code;

/** 字符串unicode编码 */
+(NSString *) utf8ToUnicode:(NSString *)string;

@end

#pragma mark 字符串改变

@interface NSString (MJExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)firstCharLower;

- (BOOL)isPureInt;

- (NSURL *)url;
@end

#pragma mark-  FolderPath

@interface NSString (FolderPath)

/*!
 *  获取沙盒下documens文件夹路径
 */
+ (NSString *)documentsPath;

/*!
 *  获取沙盒下caches文件夹路径
 */
+ (NSString *)cachesPath;

/*!
 *  获取沙盒下documens文件夹中 文件或者文件夹的完整路径
 */
+ (NSString *)documentsContentDirectory:(NSString *)name;

/*!
 *  获取沙盒下caches文件夹中 文件或者文件夹的完整路径
 */
+ (NSString *)cachesContentDirectory:(NSString *)name;

@end


#pragma mark-  Project

@interface NSString (Project)

/** 获取当前工程的发布版本 */
+ (NSString *)shortVersion;

/** 获取当前工程的内部版本 */
+ (NSInteger)buildVersion;

/** 获取当前工程的唯一标识 */
+ (NSString *)identifier;

/** 从mainBundle中根据key获取信息 */
+ (NSString *)objectFromMainBundleForKey:(NSString *)key;

/** 生成UUID */
+ (NSString *)uuid;

@end







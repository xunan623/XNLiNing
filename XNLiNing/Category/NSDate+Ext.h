//
//  NSDate+Ext.h
//  XNToolDemo
//
//  Created by xunan on 2016/12/26.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Ext)

/**
 NSTimeInterval 转成string 默认 yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;

/**
 NSTimeInterval 按照指定格式转字符串
 */
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
                          withFormat:(NSString *)format;


/**
 获取当前时间的字符串 默认 yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)stringFromNow;


/**
 获取当前时间 按照 format格式
 */
+ (NSString *)stringFromNowWithFormat:(NSString *)format;

/**
 date转string 默认格式 yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/** date转成string 依照 format格式 */
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;


/** string转成date 默认格式 yyyy-MM-dd HH:mm:ss */
+ (NSDate *)dateFromString:(NSString *)string;


/** string转成date 依照format格式 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

/**
 返回1970年到现在的秒数
 */
+ (NSTimeInterval)timeIntervalSince1970;

/**
 给定一个时间字符串 1970到dateString的秒数  yyyy-MM-dd hh:mm:ss
 */
+ (NSTimeInterval)timeIntervalWith:(NSString *)dateString;


/**
 将时间戳转为 NSDate
 */
+ (NSDate *)transformWithDate:(NSTimeInterval)interval;



/**
 是否是今天
 */
- (BOOL)isToday;


/**
 是否是昨天
 */
- (BOOL)isYesterday;


/**
 是否是前天
 */
- (BOOL)isDayBeforeYesterday;


/**
 更早
 */
- (BOOL)isEarlierDay;


/**
 获取某个月的月初 比如: 2016-10-10 -> 2016-10-01  返回 yyyy-MM-dd
 */
+ (NSString *)getStratDateWithDate:(NSDate *)date;

/**
 获取某个月的月末 比如: 2016-10-10 -> 2016-10-31  返回 yyyy-MM-dd
 */
+ (NSString *)getEndDateWithDate:(NSDate *)date;


/** 获取当前的前 几年 几月  几天 */
+ (NSString*)getDate:(NSInteger)year month:(NSInteger)month day:(NSInteger)day withFormat:(NSString *)format;

/**
 *  获取当前选中的时间和当前时间差几个月
 *
 *  @param fromDate 选中的日期
 *
 *  @return 返回月份
 */
+ (NSInteger)getCompareCurrentDateMonth:(NSDate *)fromDate;



/**
 返回是否是同一天
 */
- (BOOL)isSameDayWith:(NSDate *)date;

/**
 返回周类型字符串
 */
+ (NSString *)weekdayStringWithDate:(NSDate *)date;


/**
 当前时间的前 年月
 */
+ (NSDate *)beforeYear:(NSInteger)year month:(NSInteger)month;
/**
 当前时间的前 年月日
 */
+ (NSDate *)beforeYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;\


/**
 返回整个带周的字符串
 */
+ (NSString *)fullWeekdayStringWithDate:(NSDate *)date;


/**
 根据带周字符串返回NSDate   
 */
+ (NSDate *)dateFromFullWeekdayString:(NSString *)dateString;
















@end

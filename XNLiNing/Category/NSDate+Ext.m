//
//  NSDate+Ext.m
//  XNToolDemo
//
//  Created by xunan on 2016/12/26.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import "NSDate+Ext.h"

static NSDateFormatter *weekdayFormatter = nil;
static NSDateFormatter *fulldateFormatter = nil;
static dispatch_once_t onceToken;


@implementation NSDate (Ext)

+ (NSCalendar *)currentCalendar {
    static dispatch_once_t once = 0;
    static NSCalendar *calendar;
    
    dispatch_once(&once, ^{
        calendar            = [NSCalendar currentCalendar];
        calendar.timeZone   = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    });
    
    return calendar;
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:interval / 1000.0];
    return [self stringFromDate:currentDate];
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
                          withFormat:(NSString *)format {
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:interval / 1000.0];
    return [self stringFromDate:currentDate withFormat:format];
    
}

+ (NSString *)stringFromNow {
    return [self stringFromNowWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)stringFromNowWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [self stringFromDate:date withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string {
    return [self dateFromString:string withFormat:@"yyyy-MM-dd HH:mm:ss"];

}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}


+ (NSTimeInterval)timeIntervalSince1970 {
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSTimeInterval)timeIntervalWith:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:dateString];
    return [date timeIntervalSince1970];
}

+ (NSDate *)transformWithDate:(NSTimeInterval)interval {
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

- (BOOL)isToday {
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year
    && nowCmps.month == selfCmps.month
    && nowCmps.day == selfCmps.day;
}

/** 昨天 */
- (BOOL)isYesterday {
    // 2014-12-31 23:59:59 -> 2014-12-31
    // 2015-01-01 00:00:01 -> 2015-01-01
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

/** 前天 */
- (BOOL)isDayBeforeYesterday {
    // 2014-12-31 23:59:59 -> 2014-12-31
    // 2015-01-01 00:00:01 -> 2015-01-01
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 2;
}

/** 更早 */
- (BOOL)isEarlierDay {
    // 2014-12-31 23:59:59 -> 2014-12-31
    // 2015-01-01 00:00:01 -> 2015-01-01
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year > 0 || (cmps.year == 0 && cmps.month > 0) || (cmps.year == 0 && cmps.month == 0 && cmps.day > 0);
}

+ (NSString *)getStratDateWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *monthString = [dateString substringFromIndex:dateString.length - 2];
    NSInteger year = [[dateString substringToIndex:4] integerValue];
    return [NSString stringWithFormat:@"%zd-%@-%@",year, monthString, @"01"];
}

+ (NSString *)getEndDateWithDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *monthString = [dateString substringFromIndex:dateString.length - 2];
    NSInteger year = [[dateString substringToIndex:4] integerValue];
    
    NSString *dayString;
    switch ([monthString integerValue]) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            dayString = @"31";
            break;
        case 4: case 6: case 9: case 11:
            dayString = @"30";
            break;
        case 2:
            if ((year%4==0 && year %100 !=0) || year%400==0) {
                dayString = @"29";
            }else {
                dayString = @"28";
            }
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%zd-%@-%@",year, monthString, dayString];
}


+ (NSString*)getDate:(NSInteger)year month:(NSInteger)month day:(NSInteger)day withFormat:(NSString *)format
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *dateFromData = [formatter stringFromDate:newdate];
    return dateFromData;
}


+ (NSInteger)getCompareCurrentDateMonth:(NSDate *)fromDate {
    if (!fromDate) return 0;
    
    NSDateFormatter *datefort = [NSDateFormatter new];
    datefort.dateFormat = @"yyyy-MM";
    NSString *dateString = [datefort stringFromDate:fromDate];
    NSArray *dateStringArray = [dateString componentsSeparatedByString:@"-"];
    
    NSString *currentString = [datefort stringFromDate:[NSDate date]];
    NSArray *currentStringArray = [currentString componentsSeparatedByString:@"-"];
    
    NSInteger page = 0;
    if (dateStringArray[0] == currentStringArray[0]) { // 年相等
        page = [dateStringArray[1] integerValue] - [currentStringArray[1] integerValue];
    } else {
        if ([dateStringArray[1] integerValue] == [currentStringArray[1] integerValue]) { // 月相等
            page = ([dateStringArray[0] integerValue] - [currentStringArray[0] integerValue]) *12;
        } else {
            page = ([dateStringArray[0] integerValue] - [currentStringArray[0] integerValue]) *12 - ([currentStringArray[1] integerValue] - [dateStringArray[1] integerValue]);
        }
    }
    return page;
}

- (BOOL)isSameDayWith:(NSDate *)date {
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    return (int)(([self timeIntervalSince1970] + timezoneFix)/(24*3600)) -
    (int)(([date timeIntervalSince1970] + timezoneFix)/(24*3600))
    == 0;
}

+ (NSString *)weekdayStringWithDate:(NSDate *)date {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weekdayFormatter = [[NSDateFormatter alloc]init];
        [weekdayFormatter setDateFormat:@"MM月dd日 EEEE"];
        [weekdayFormatter setWeekdaySymbols:@[@"星期日",
                                              @"星期一",
                                              @"星期二",
                                              @"星期三",
                                              @"星期四",
                                              @"星期五",
                                              @"星期六"]];
    });
    return [weekdayFormatter stringFromDate:date];
}


+ (NSString *)fullWeekdayStringWithDate:(NSDate *)date {
    dispatch_once(&onceToken, ^{
        fulldateFormatter = [[NSDateFormatter alloc]init];
        [fulldateFormatter setDateFormat:@"yyyy-MM-dd EEEE HH:mm"];
        [fulldateFormatter setWeekdaySymbols:@[@"星期日",
                                               @"星期一",
                                               @"星期二",
                                               @"星期三",
                                               @"星期四",
                                               @"星期五",
                                               @"星期六"]];
    });
    
    return [fulldateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromFullWeekdayString:(NSString *)dateString {
    dispatch_once(&onceToken, ^{
        fulldateFormatter = [[NSDateFormatter alloc]init];
        fulldateFormatter.timeZone  = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [fulldateFormatter setDateFormat:@"yyyy-MM-dd EEEE HH:mm"];
        [fulldateFormatter setWeekdaySymbols:@[@"星期日",
                                               @"星期一",
                                               @"星期二",
                                               @"星期三",
                                               @"星期四",
                                               @"星期五",
                                               @"星期六"]];
    });
    return [fulldateFormatter dateFromString:dateString];
}


+ (NSDate *)beforeYear:(NSInteger)year month:(NSInteger)month {
    //计算生日
    NSDate *now     = [NSDate date];
    NSDateComponents *com = [[self currentCalendar] components:NSCalendarUnitMonth fromDate:now];
    
    com.month   = -(year*12+month);
    
    return [[self currentCalendar] dateByAddingComponents:com toDate:now options:NSCalendarMatchFirst];
}

+ (NSDate *)beforeYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDate *now     = [NSDate date];
    NSDateComponents *com = [[self currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    
    com.month   = -(year*12+month);
    com.day     = day;
    
    return [[self currentCalendar] dateByAddingComponents:com toDate:now options:NSCalendarMatchFirst];
}

+ (NSString *)calculateMessageTimeWithSendInterval:(NSTimeInterval)sendInterval
                               andReceiveInterval:(NSTimeInterval)receiveInterval {
    long currentMessageInterval;
    
    //通过发送时间和接收时间来比较哪个是最新的消息时间
    
    if (sendInterval > receiveInterval) {
        
        //发送的时间是最新的
        currentMessageInterval = sendInterval/1000;
    }else{
        
        //接受的时间是最新的
        currentMessageInterval = receiveInterval/1000;
    }
    //    NSDate *formatDate = [NSDate dateWithTimeIntervalSince1970:receiveInterval];
    //    NSLog(@"%@",formatDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    //最新的消息时间
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:currentMessageInterval];
    
    //解决当前系统时间和北京时间相差8小时的问题
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    //接收或发送的消息时间(转换为当前时区)
    NSInteger messageInterval = [timeZone secondsFromGMTForDate: messageDate];
    NSDate *localMessageDate = [messageDate dateByAddingTimeInterval:messageInterval];
    
    //当前时间去掉时差问题
    NSDate *nowDate = [NSDate date];
    NSInteger nowInterval = [timeZone secondsFromGMTForDate:nowDate];
    NSDate *localNowDate = [nowDate dateByAddingTimeInterval:nowInterval];
    
    //明天零点时间
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrowDate = [localNowDate dateByAddingTimeInterval:secondsPerDay];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *zeroDateStr = [dateFormatter stringFromDate:tomorrowDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *zeroDate = [dateFormatter dateFromString:zeroDateStr];
    
    
    //消息时间和明天零点时间比较,计算时间或天数
    NSTimeInterval interval = [zeroDate timeIntervalSinceDate:localMessageDate];
    double resultDay = interval / 60.0 / 60.0 / 24.0;
    
    //计算当前年份和消息的年份
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSString *msgYearStr = [dateFormatter stringFromDate:localMessageDate];
    NSString *nowYearStr = [dateFormatter stringFromDate:localNowDate];
    
    
    NSString *resultMessageDateStr;
    
    /*
     *  时间计算规则：
     *   当前日期，显示格式“09:05”
     *   当前日期-1，显示格式“昨天 09:05”
     *   当前日期-2，显示格式“前天 09:05”
     *   其他日期，显示格式“05-01 09:05”
     *   小于当前年份，显示格式“2013-05-01 09:05”
     *
     *
     */
    if (resultDay > 0 && resultDay < 1) {
        
        //当日直接显示时间
        [dateFormatter setDateFormat:@"HH:mm"];
        resultMessageDateStr = [dateFormatter stringFromDate:localMessageDate];
    }else if (resultDay >= 1 && resultDay < 2){
        
        //前一天显示：昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        resultMessageDateStr = [NSString stringWithFormat:@"昨天 %@",
                                [dateFormatter stringFromDate:localMessageDate]];
        
    }else if (resultDay >= 2 && resultDay < 3){
        
        //前两天显示：前天
        [dateFormatter setDateFormat:@"HH:mm"];
        resultMessageDateStr = [NSString stringWithFormat:@"前天 %@",
                                [dateFormatter stringFromDate:localMessageDate]];
        
        
    }else if (![nowYearStr isEqualToString:msgYearStr]){
        
        //和当前年份不相同
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        resultMessageDateStr = [dateFormatter stringFromDate:localMessageDate];
        
    }else{
        
        //其他时间
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        resultMessageDateStr = [dateFormatter stringFromDate:localMessageDate];
    }
    
    return resultMessageDateStr;
    
}
@end

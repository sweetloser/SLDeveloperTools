//
//  NSDate+Kit.h
//  MiaoPurchase
//
//  Created by bxlive on 2016/11/13.
//  Copyright © 2016年 dlb. All rights reserved.
//

#import <Foundation/Foundation.h>

struct STDateInformation {
    NSInteger day;      // 日
    NSInteger month;    // 月
    NSInteger year;     // 年
    
    NSInteger weekday;  // 星期
    
    NSInteger minute;   // 分钟
    NSInteger hour;     // 小时
    NSInteger second;   // 秒数
    
};

typedef struct STDateInformation STDateInformation;
@interface NSDate (Kit)

+ (NSDate *)yesterday;


+ (NSDate *)month;


- (NSDate *)month;


- (NSInteger)weekday;

- (BOOL)isSameDay:(NSDate *)anotherDate;


- (NSInteger)monthsBetweenDate:(NSDate *)toDate;


- (NSInteger)daysBetweenDate:(NSDate *)toDate;


- (BOOL)isToday;


- (NSDate *)dateByAddingDays:(NSUInteger)days;


+ (NSDate *)dateWithDatePart:(NSDate *)aDate
                 andTimePart:(NSDate *)aTime;
-(NSString *)dayHourMinSecString;

-(NSString *)dayString;

///获取月份 格式：十二月
- (NSString *)monthString;
///获取月份 格式：12
- (NSString *)sl_monthString;
- (NSString *)yearString;

-(NSString *)yearAndmothsWithdayStrings;

- (STDateInformation)dateInformation;


- (STDateInformation)dateInformationWithTimeZone:(NSTimeZone *)timezone;


+ (NSDate *)dateFromDateInformation:(STDateInformation)info;


+ (NSDate *)dateFromDateInformation:(STDateInformation)info
                           timeZone:(NSTimeZone *)timezone;

+ (NSString *)dateInformationDescriptionWithInformation:(STDateInformation)info;

- (BOOL)isTodays;

- (BOOL)isYesterday;

- (BOOL)isThisYear;


- (NSDate *)dateWithYMD;


- (NSDateComponents *)deltaWithNow;


+ (NSDate *)NSDateTransformWithNSDateTimeSp:(NSString *)timeSp;



@end

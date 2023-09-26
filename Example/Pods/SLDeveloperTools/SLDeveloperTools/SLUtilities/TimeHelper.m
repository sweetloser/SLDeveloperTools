//
//  TimeHelper.m
//  huixuexi
//
//  Created by huafeng on 16/8/29.
//  Copyright © 2016年 Xueduoduo. All rights reserved.
//

#import "TimeHelper.h"

@implementation TimeHelper

/// 获取当前系统的时间戳  单位是 秒
+ (NSInteger)getTimeSp {
    NSInteger time;
    NSDate *fromdate = [NSDate date];
    time = (NSInteger)[fromdate timeIntervalSince1970];
    return time;
}

+ (CGFloat)getFloatTimeSp {
    NSDate *fromdate = [NSDate date];
    CGFloat time = (CGFloat)[fromdate timeIntervalSince1970];
    return time;
}

+ (NSDate *)getDateForTimeStamp:(NSString *)timeStamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp intValue]];
    return date;
}

+ (NSString *)getDateStr:(NSDate *)date type:(NSString *)type;{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:type];
    return [formatter stringFromDate:date];
}
+ (NSDate *)getDate:(NSString *)dateStr type:(NSString *)type{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:type];
    return [formatter dateFromString:dateStr];
}

+ (NSInteger)getOverTime:(NSString *)timeStamp{
    NSInteger creatTime=[timeStamp integerValue];
    NSInteger nowTime=[TimeHelper getTimeSp];
    NSInteger timeDifference=nowTime-creatTime;
    return timeDifference;
}

+ (NSString *)updateTimeString:(NSDate *)lastUpdateTime
{
    if (!lastUpdateTime) return @"";
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day] && [cmp1 year] == [cmp2 year] &&[cmp1 month] == [cmp2 month]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:lastUpdateTime];
    // 3.显示日期
    return time;
}

+ (NSString *)changeTimeWithDuration:(CGFloat)duration{
    NSInteger changeDuration = (NSInteger)duration;
    
    NSInteger m = changeDuration/60;
    NSInteger s = changeDuration%60;
    
    NSString *mStr=[NSString stringWithFormat:@"%ld",(long)m];
    if (mStr.length==1) {
        mStr=[@"0" stringByAppendingString:mStr];
    }
    NSString *sStr=[NSString stringWithFormat:@"%ld",(long)s];
    if (sStr.length==1) {
        sStr=[@"0" stringByAppendingString:sStr];
    }
    return [NSString stringWithFormat:@"%@:%@",mStr,sStr];
}

@end

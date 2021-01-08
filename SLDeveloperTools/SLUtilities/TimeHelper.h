//
//  TimeHelper.h
//  huixuexi
//
//  Created by huafeng on 16/8/29.
//  Copyright © 2016年 Xueduoduo. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  时间相关
 */
@interface TimeHelper : NSObject

//获取当前系统的时间戳
+ (NSInteger)getTimeSp;
+ (CGFloat)getFloatTimeSp;

//时间戳 转成 时间NSDate
+ (NSDate *)getDateForTimeStamp:(NSString *)timeStamp;
//获取固定时间戳  到现在的  时间
+ (NSInteger)getOverTime:(NSString *)timeStamp;

//NSDate 转成字符串
+ (NSString *)getDateStr:(NSDate *)date type:(NSString *)type;
//字符串 转成NSDate
+ (NSDate *)getDate:(NSString *)dateStr type:(NSString*)type;

//获取显示时间
+ (NSString *)updateTimeString:(NSDate *)lastUpdateTime;
//时长转字符串
+ (NSString *)changeTimeWithDuration:(CGFloat)duration;
@end

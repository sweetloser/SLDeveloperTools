//
//  NSTimer+Kit.h
//  BXlive
//
//  Created by bxlive on 2016/9/27.
//  Copyright © 2016年 lei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^TimerCallBack)(NSTimer *timer);
@interface NSTimer (Kit)
/**
 *  @author lei, 16-09-26 15:08:15
 *
 *  倒计时
 *
 *  @param interval 倒计时时间
 *  @param count    总的时间
 *  @param callback  在这里处理按钮的事件
 */

+(NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     count:(NSInteger)count
                                  callback:(TimerCallBack)callback;
+ (NSTimer *)xx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;

@end

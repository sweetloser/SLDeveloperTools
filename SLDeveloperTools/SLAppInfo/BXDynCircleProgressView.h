//
//  BXDynCircleProgressView.h
//  BXlive
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CircularProgressDelegate

- (void)CircularProgressEnd;

@end

@interface BXDynCircleProgressView : UIView
{
    CGFloat startAngle;
    CGFloat endAngle;
    int     totalTime;
    
    UIFont *textFont;
    UIColor *textColor;
    NSMutableParagraphStyle *textStyle;
    
    NSTimer *m_timer;
    bool b_timerRunning;
}

@property(nonatomic, assign) id<CircularProgressDelegate> delegate;
@property(nonatomic)CGFloat time_left;

- (void)setTotalSecondTime:(CGFloat)time;
- (void)setTotalMinuteTime:(CGFloat)time;

- (void)startTimer;
- (void)stopTimer;
- (void)pauseTimer;
@end

NS_ASSUME_NONNULL_END

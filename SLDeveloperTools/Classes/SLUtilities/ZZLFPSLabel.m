//
//  ZZLFPSLabel.m
//  BXlive
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "ZZLFPSLabel.h"
#import <mach/mach.h>
#import <SDAutoLayout/SDAutoLayout.h>

#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ZZLFPSLabel ()
{
    NSUInteger _tickCount;
}
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval lastTime;
@property (nonatomic, assign) NSUInteger fps;

@end

@implementation ZZLFPSLabel

+ (instancetype)showInWindow:(UIWindow *)window
{
    ZZLFPSLabel *label = [[ZZLFPSLabel alloc] initWithFrame:CGRectZero];
    label.layer.cornerRadius = 4.f;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = NO;
    label.font = [UIFont fontWithName:@"Menlo" size:12];

    [window addSubview:label];

    label.translatesAutoresizingMaskIntoConstraints = NO;

    label.sd_layout.rightSpaceToView(window, 10).topSpaceToView(window, 100).heightIs(20);
    [label setSingleLineAutoResizeWithMaxWidth:200.f];

//    NSLayoutConstraint *leadingLayout =[NSLayoutConstraint constraintWithItem:label
//                                                                    attribute:NSLayoutAttributeLeading
//                                                                    relatedBy:NSLayoutRelationEqual
//                                                                       toItem:window
//                                                                    attribute:NSLayoutAttributeLeading
//                                                                   multiplier:1
//                                                                     constant:10.f];
//    NSLayoutConstraint *bottomLayout = [NSLayoutConstraint constraintWithItem:label
//                                                                    attribute:NSLayoutAttributeTop
//                                                                    relatedBy:NSLayoutRelationEqual
//                                                                       toItem:window
//                                                                    attribute:NSLayoutAttributeBottom
//                                                                   multiplier:1
//                                                                     constant:100.f];
//    NSLayoutConstraint *widthLayout = [NSLayoutConstraint constraintWithItem:label
//                                                                   attribute:NSLayoutAttributeWidth
//                                                                   relatedBy:NSLayoutRelationEqual
//                                                                      toItem:nil
//                                                                   attribute:NSLayoutAttributeNotAnAttribute
//                                                                  multiplier:0
//                                                                    constant:150.f];
//    NSLayoutConstraint *heightLayout = [NSLayoutConstraint constraintWithItem:label
//                                                                    attribute:NSLayoutAttributeHeight
//                                                                    relatedBy:NSLayoutRelationEqual
//                                                                       toItem:nil
//                                                                    attribute:NSLayoutAttributeNotAnAttribute
//                                                                   multiplier:0
//                                                                     constant:20.f];
//    if (IOS8_OR_LATER) {
//        [NSLayoutConstraint activateConstraints:@[leadingLayout, bottomLayout, widthLayout, heightLayout]];
//    }
//    else {
//        [window addConstraints:@[leadingLayout, bottomLayout, widthLayout, heightLayout]];
//    }

    return label;
}

- (void)dealloc
{
    [_displayLink invalidate];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _autoHide = NO;

        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(fps)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:NSStringFromSelector(@selector(fps))]) {
        NSUInteger oldFps = [[change valueForKey:NSKeyValueChangeOldKey] unsignedIntegerValue];
        NSUInteger newFps = [[change valueForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
        if (oldFps != newFps) {
            [self _displayFPS];
        }
    }
}

- (void)tick:(CADisplayLink *)displayLink
{
    CFTimeInterval currentTime = displayLink.timestamp;
    if (_lastTime == 0) {
        // first time.
        _lastTime = currentTime;
        return;
    }
    _tickCount++;
    CFTimeInterval delta = currentTime - _lastTime;
    if (delta < 1) return;
    // get fps
    self.fps = MIN(lrint(_tickCount / delta), 60);
    _tickCount = 0;
    _lastTime = currentTime;
}

- (void)fadeOut
{
    CATransition *fadeTransition = [CATransition animation];
    [self.layer addAnimation:fadeTransition forKey:kCATransition];
    [self setAttributedText:nil];
    self.layer.backgroundColor = nil;
}

- (void)_displayFPS
{
    if (self.attributedText == nil) {
        // fade in
        CATransition *fadeTransition = [CATransition animation];
        [self.layer addAnimation:fadeTransition forKey:kCATransition];
    }

    CGFloat hue = self.fps > 24 ? (self.fps - 24) / 120.f : 0;
    self.textColor = [UIColor colorWithHue:hue saturation:1 brightness:0.9 alpha:1];
    self.text = [NSString stringWithFormat:@"%@ FPS cpu:%2.f %.1fMB", @(self.fps),[ZZLFPSLabel cpu_usage], [ZZLFPSLabel memory_usage]];
    self.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f].CGColor;

    if (self.autoHide) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOut) object:nil];
        [self performSelector:@selector(fadeOut) withObject:nil afterDelay:2];
    }
}

+ (float) cpu_usage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;

    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }

    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;

    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;

    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads

    basic_info = (task_basic_info_t)tinfo;

    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;

    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;

    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }

        basic_info_th = (thread_basic_info_t)thinfo;

        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }

    } // for each thread

    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);

    return tot_cpu;
}

+ (float)memory_usage {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return 0.0;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

@end

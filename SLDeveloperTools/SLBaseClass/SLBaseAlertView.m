//
//  SLBaseAlertView.m
//  BXlive
//
//  Created by sweetloser on 2020/8/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLBaseAlertView.h"
#import <SLDeveloperTools/SLDeveloperTools.h>

@implementation SLBaseAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        UIView *maskView = [UIView new];
        maskView.frame = self.bounds;
        [self addSubview:maskView];
        maskView.backgroundColor = [UIColor colorWithColor:sl_blackColors alpha:0.6];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tap];
    }
    return self;
}

-(void)tapAction{
    [self hiddenView];
}

-(void)hiddenView;{
//    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
//        CGRect frame = self.contentView.frame;
//        frame.origin.y = frame.origin.y + frame.size.height;
//        self.contentView.frame = frame;
//    }
//    completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    [self removeFromSuperview];
}



-(void)show{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
}

@end

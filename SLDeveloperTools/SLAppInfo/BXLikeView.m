//
//  BXLikeView.m
//  BXlive
//
//  Created by bxlive on 2019/3/19.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXLikeView.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>

static const NSInteger klikeViewLikeBeforeTag  = 0x01;
static const NSInteger klikeViewLikeAfterTag   = 0x02;

@implementation BXLikeView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, __ScaleWidth(30), __ScaleWidth(30))];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        _likeBefore = [[UIImageView alloc]initWithFrame:frame];
        _likeBefore.contentMode = UIViewContentModeCenter;
        _likeBefore.image = [UIImage imageNamed:@"xiaoshipin_icon_zan_default"];
        _likeBefore.userInteractionEnabled = YES;
        _likeBefore.tag = klikeViewLikeBeforeTag;
        [_likeBefore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeBefore];
        _likeAfter = [[UIImageView alloc]initWithFrame:frame];
        _likeAfter.contentMode = UIViewContentModeCenter;
        _likeAfter.image = [UIImage imageNamed:@"xiaoshipin_icon_zan_selected"];
        _likeAfter.userInteractionEnabled = YES;
        _likeAfter.tag = klikeViewLikeAfterTag;
        [_likeAfter setHidden:YES];
        [_likeAfter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeAfter];
        
        _likeBefore.sd_layout.centerXEqualToView(self).topEqualToView(self).widthIs(30).heightIs(30);
        _likeAfter.sd_layout.centerXEqualToView(self).topEqualToView(self).widthIs(30).heightIs(30);

    }
    return self;
}

- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case klikeViewLikeBeforeTag: {
            [self startLikeAnim:YES];
            if (self.likeView) {
                self.likeView();
            }
            break;
        }
        case klikeViewLikeAfterTag: {
//            [self startLikeAnim:NO];
            [self.likeBefore setHidden:NO];
            [self.likeAfter setHidden:YES];
            self.likeBefore.userInteractionEnabled = YES;
            self.likeAfter.userInteractionEnabled = YES;
            if (self.likeView) {
                self.likeView();
            }
            break;
        }
    }
}

-(void)startLikeAnim:(BOOL)isLike{
    
    _likeBefore.userInteractionEnabled = NO;
    _likeAfter.userInteractionEnabled = NO;
    if(isLike) {
        CGFloat length = 30;
        CGFloat duration = 0.5;
        for(int i=0;i<6;i++) {
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];
            layer.position = _likeBefore.center;
            layer.fillColor = RGB(255, 0, 97).CGColor;
            
            UIBezierPath *startPath = [UIBezierPath bezierPath];
            [startPath moveToPoint:CGPointMake(-2, -length)];
            [startPath addLineToPoint:CGPointMake(2, -length)];
            [startPath addLineToPoint:CGPointMake(0, 0)];
            
            UIBezierPath *endPath = [UIBezierPath bezierPath];
            [endPath moveToPoint:CGPointMake(-2, -length)];
            [endPath addLineToPoint:CGPointMake(2, -length)];
            [endPath addLineToPoint:CGPointMake(0, -length)];
            
            layer.path = startPath.CGPath;
            layer.transform = CATransform3DMakeRotation(M_PI / 3.0f * i, 0.0, 0.0, 1.0);
            [self.layer addSublayer:layer];
            
            CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
            group.removedOnCompletion = NO;
            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            group.fillMode = kCAFillModeForwards;
            group.duration = duration;
            
            CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnim.fromValue = @(0.0);
            scaleAnim.toValue = @(1.0);
            scaleAnim.duration = duration * 0.2f;
            
            CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnim.fromValue = (__bridge id)layer.path;
            pathAnim.toValue = (__bridge id)endPath.CGPath;
            pathAnim.beginTime = duration * 0.2f;
            pathAnim.duration = duration * 0.8f;
            
            [group setAnimations:@[scaleAnim, pathAnim]];
            [layer addAnimation:group forKey:nil];
        }
        [_likeAfter setHidden:NO];
        _likeAfter.alpha = 0.0f;
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI/3*2), 0.5f, 0.5f);
        [UIView animateWithDuration:0.4f
                              delay:0.2f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.8f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.likeBefore.alpha = 0.0f;
                             self.likeAfter.alpha = 1.0f;
                             self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
                         }
                         completion:^(BOOL finished) {
                             self.likeBefore.alpha = 1.0f;
                             self.likeBefore.userInteractionEnabled = YES;
                             self.likeAfter.userInteractionEnabled = YES;
                         }];
    }else {
        _likeAfter.alpha = 1.0f;
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
        [UIView animateWithDuration:0.35f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI_4), 0.1f, 0.1f);
                         }
                         completion:^(BOOL finished) {
                             [self.likeAfter setHidden:YES];
                             self.likeBefore.userInteractionEnabled = YES;
                             self.likeAfter.userInteractionEnabled = YES;
                         }];
    }
}

- (void)resetView {
    [_likeBefore setHidden:NO];
    [_likeAfter setHidden:YES];
    [self.layer removeAllAnimations];
}

@end


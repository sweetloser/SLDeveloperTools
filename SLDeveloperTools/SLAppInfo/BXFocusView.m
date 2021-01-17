//
//  BXFocusView.m
//  BXlive
//
//  Created by bxlive on 2019/2/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXFocusView.h"
#import "../SLMacro/SLMacro.h"

@interface BXFocusView ()<CAAnimationDelegate>

@end

@implementation BXFocusView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 24, 24)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.backgroundColor = SLClearColor.CGColor;
        self.image = [UIImage imageNamed:@"icon_add_little"];
        self.contentMode = UIViewContentModeCenter;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beginAnimation)]];
    }
    return self;
}

-(void)beginAnimation {
    self.sl_animationing = YES;
    [self animationDidStart];
    
    if (_tapAction) {
        _tapAction();
    }
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.25f;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnim setValues:@[
                           [NSNumber numberWithFloat:1.0f],
                           [NSNumber numberWithFloat:1.2f],
                           [NSNumber numberWithFloat:1.2f],
                           [NSNumber numberWithFloat:1.2f],
                           [NSNumber numberWithFloat:1.2f],
                           [NSNumber numberWithFloat:1.2f],
                           [NSNumber numberWithFloat:1.2f],
                           [NSNumber numberWithFloat:0.0f]]];
    
    CAKeyframeAnimation *rotationAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    [rotationAnim setValues:@[
                              [NSNumber numberWithFloat:-1.5f*M_PI],
                              [NSNumber numberWithFloat:0.0f],
                              [NSNumber numberWithFloat:0.0f],
                              [NSNumber numberWithFloat:0.0f]]];
    
    CAKeyframeAnimation * opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [opacityAnim setValues:@[
                             [NSNumber numberWithFloat:0.8f],
                             [NSNumber numberWithFloat:1.0f],
                             [NSNumber numberWithFloat:1.0f]]];
    
    [animationGroup setAnimations:@[scaleAnim,
                                    rotationAnim,
                                    opacityAnim]];
    [self.layer addAnimation:animationGroup forKey:nil];
    
    [self performSelector:@selector(animationDidStop) withObject:nil afterDelay:1.25f];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:2.0f];
}

-(void)hiddenView{
    self.sl_animationing = NO;
    self.hidden = YES;
}

- (void)animationDidStart {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationDidStop) object:nil];
    
    self.userInteractionEnabled = NO;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.image = [UIImage imageNamed:@"icon_add_signDone"];
}

- (void)animationDidStop {
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeCenter;
    self.image = [UIImage imageNamed:@"icon_add_little"];
    self.hidden = YES;
}

- (void)resetView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationDidStop) object:nil];
    [self.layer removeAllAnimations];
    self.image = [UIImage imageNamed:@"icon_add_little"];
    self.contentMode = UIViewContentModeCenter;
    self.userInteractionEnabled = YES;
    self.hidden = NO;
}

- (void)animationdidFocusDidStop {
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeCenter;
    self.image = [UIImage imageNamed:@"icon_add_signDone"];
    self.hidden = NO;
}
- (void)didfocusView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationdidFocusDidStop) object:nil];
    [self.layer removeAllAnimations];
    self.image = [UIImage imageNamed:@"icon_add_signDone"];
    self.contentMode = UIViewContentModeCenter;
    self.userInteractionEnabled = YES;
    self.hidden = NO;
}
-(void)VisiableViewFocusStatus:(BOOL)status{
    if (status) {
        self.image = [UIImage imageNamed:@"icon_add_signDone"];
    }else{
         self.image = [UIImage imageNamed:@"icon_add_little"];
    }
}
@end

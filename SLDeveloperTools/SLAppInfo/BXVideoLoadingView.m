//
//  BXliveLoadingView.m
//  BXlive
//
//  Created by bxlive on 2019/2/24.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXVideoLoadingView.h"
#import "../SLMacro/SLMacro.h"


@implementation BXVideoLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setHidden:(BOOL)hidden {
    if (hidden) {
        [self.layer removeAllAnimations];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenView) object: nil];
        [super setHidden:hidden];
    } else {
        CAAnimation *animation = [self.layer animationForKey:@"Group"];
        if (!animation) {
            [self performSelector:@selector(hiddenView) withObject:nil afterDelay:0.8];
            
            CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
            animationGroup.duration = 0.5;
            animationGroup.beginTime = 0.8;
            animationGroup.repeatCount = MAXFLOAT;
            animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animationGroup.fillMode = kCAFillModeForwards;
            animationGroup.removedOnCompletion = NO;
            
            CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
            scaleAnimation.keyPath = @"transform.scale.x";
            scaleAnimation.fromValue = @(.5f);
            scaleAnimation.toValue = @(__kWidth);
            
            CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
            alphaAnimation.keyPath = @"opacity";
            alphaAnimation.fromValue = @(1.0f);
            alphaAnimation.toValue = @(0.5f);
            
            [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
            [self.layer addAnimation:animationGroup forKey:@"Group"];
        }
    }
}

- (void)hiddenView {
    [super setHidden:NO];
}

@end

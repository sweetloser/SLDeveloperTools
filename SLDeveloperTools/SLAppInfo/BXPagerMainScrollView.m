//
//  BXPagerMainScrollView.m
//  BXlive
//
//  Created by bxlive on 2019/9/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXPagerMainScrollView.h"

@interface BXPagerMainScrollView () <UIGestureRecognizerDelegate>

@end

@implementation BXPagerMainScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return NO;
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    } else {
        return YES;
    }
}

@end

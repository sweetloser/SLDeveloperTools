//
//  UIGestureRecognizer+Time.m
//  BXlive
//
//  Created by bxlive on 2019/5/10.
//  Copyright © 2019 cat. All rights reserved.
//

#import "UIGestureRecognizer+Time.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (Time)

- (void)setBeginTime:(double)beginTime {
    objc_setAssociatedObject(self, @selector(beginTime), @(beginTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (double)beginTime {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end

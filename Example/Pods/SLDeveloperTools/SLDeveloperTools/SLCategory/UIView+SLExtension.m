//
//  UIView+SLExtension.m
//  BXlive
//
//  Created by sweetloser on 2020/8/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "UIView+SLExtension.h"

@implementation UIView (SLExtension)

- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}

@end

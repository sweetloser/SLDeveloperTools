//
//  UIView+Extension.m
//  XTMall
//
//  Created by LayChan on 2020/5/16.
//  Copyright © 2020 LayChan. All rights reserved.
//

#import "UIView+Extension.h"
#import "UIView+HJViewStyle.h"

@implementation UIView (Extension)

- (void)xt_setShadow:(BOOL)isDown {
    self.shadowColor   = [UIColor blackColor];
    self.shadowOffset  = CGSizeMake(0.0, isDown ? 2.0:-2.0);
    self.shadowOpacity = 0.02;
}

- (void)xt_setAllroundShadow {
    self.shadowRadius  = self.cornerRadius;
    self.shadowColor   = [UIColor blackColor];
    self.shadowOffset  = CGSizeMake(0.0, 0.0);
    self.shadowOpacity = 0.02;
}

- (void)xt_showLoading {
    
}

- (void)xt_hideLoading {
    
}

- (UIViewController *)xt_currentViewController {
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (UINavigationController *)xt_currentNavigaitonController {
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (UITabBarController *)xt_currentTabBarController {
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end

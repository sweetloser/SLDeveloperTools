//
//  UINavigationController+NavPushViewController.m
//  BXlive
//
//  Created by mac on 2020/10/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "UINavigationController+NavPushViewController.h"

@implementation UINavigationController (NavPushViewController)
- (void)pushVC:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        // 当前导航栏, 只有第一个viewController push的时候设置隐藏
        if (self.viewControllers.count == 1) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [self pushViewController:viewController animated:animated];
}
-(NSArray<__kindof UIViewController *> *)popToVC:(UIViewController *)viewController Animated:(BOOL)animated
{
    
    if (animated) {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    return [self popToViewController:viewController animated:YES];
}
@end

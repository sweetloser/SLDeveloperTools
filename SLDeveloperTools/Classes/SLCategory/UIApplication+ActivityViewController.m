//
//  UIApplication+ActivityViewController.m
//  BXlive
//
//  Created by bxlive on 2018/5/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "UIApplication+ActivityViewController.h"

@implementation UIApplication (ActivityViewController)



- (UIViewController *)activityViewController {
    __block UIWindow *normalWindow = [self.delegate window];
    if (normalWindow.windowLevel != UIWindowLevelNormal) {
        [self.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.windowLevel == UIWindowLevelNormal) {
                normalWindow = obj;
                *stop        = YES;
            }
        }];
    }
    
    return [self p_nextTopForViewController:normalWindow.rootViewController];
}

- (UIViewController *)p_nextTopForViewController:(UIViewController *)inViewController {
    while (inViewController.presentedViewController) {
        inViewController = inViewController.presentedViewController;
    }
    
    if ([inViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedVC = [self p_nextTopForViewController:((UITabBarController *)inViewController).selectedViewController];
        return selectedVC;
    } else if ([inViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *selectedVC = [self p_nextTopForViewController:((UINavigationController *)inViewController).visibleViewController];
        return selectedVC;
    } else {
        return inViewController;
    }
}


-(UIViewController *) topMostController {
    UIViewController*topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while(topController.presentedViewController){
        topController=topController.presentedViewController;
    }
    return topController;
}



+(UINavigationController *)currentTabbarSelectedNavigationController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootVC = window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    }else if([rootVC isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabarController = [self currentTtabarController];
        UINavigationController *selectedNV = (UINavigationController *)tabarController.selectedViewController;
        if ([selectedNV isKindOfClass:[UINavigationController class]]) {
            return selectedNV;
        }
    }
    
    return nil;
}

+(UITabBarController *)currentTtabarController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabbarController;
    }
    return nil;
}


@end

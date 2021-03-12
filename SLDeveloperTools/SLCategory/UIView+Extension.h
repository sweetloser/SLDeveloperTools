//
//  UIView+Extension.h
//  XTMall
//
//  Created by LayChan on 2020/5/16.
//  Copyright © 2020 LayChan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)

- (void)xt_setShadow:(BOOL)isDown;

- (void)xt_setAllroundShadow;

- (void)xt_showLoading;

- (void)xt_hideLoading;

- (UIViewController *)xt_currentViewController;

- (UINavigationController *)xt_currentNavigaitonController;

- (UITabBarController *)xt_currentTabBarController;

@end

NS_ASSUME_NONNULL_END

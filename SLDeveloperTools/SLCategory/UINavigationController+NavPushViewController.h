//
//  UINavigationController+NavPushViewController.h
//  BXlive
//
//  Created by mac on 2020/10/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (NavPushViewController)
- (void)pushVC:(UIViewController *)viewController animated:(BOOL)animated;
-(NSArray<__kindof UIViewController *> *)popToVC:(UIViewController *)viewController Animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END

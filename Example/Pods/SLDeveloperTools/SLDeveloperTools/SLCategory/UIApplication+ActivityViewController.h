//
//  UIApplication+ActivityViewController.h
//  BXlive
//
//  Created by bxlive on 2018/5/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (ActivityViewController)


- (UIViewController *)activityViewController;


- (UIViewController *)topMostController;


+(UINavigationController *)currentTabbarSelectedNavigationController;

@end

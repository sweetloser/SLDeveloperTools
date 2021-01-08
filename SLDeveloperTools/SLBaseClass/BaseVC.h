//
//  BaseVC.h
//  BXlive
//
//  Created by bxlive on 2017/5/2.
//  Copyright © 2017年 lei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BaseViewControllerHandle)();

@interface BaseVC : UIViewController

@property (nonatomic, assign) BOOL isNetworkReachable;

/// 主题颜色  0 代表高亮模式   1 代表暗黑模式
@property(nonatomic,assign)NSInteger themeMode;

- (void)pop;

- (void)popToRootVc;

- (void)popToVc:(UIViewController *)vc;

- (void)dismiss;

- (void)dismissWithCompletion:(void(^)())completion;

- (void)presentVc:(UIViewController *)vc;

- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion;

- (void)pushVc:(UIViewController *)vc;

/** 请求数据，交给子类去实现*/
- (void)loadData;

@end

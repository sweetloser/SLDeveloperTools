//
//  BaseVC.m
//  BXlive
//
//  Created by bxlive on 2017/5/2.
//  Copyright © 2017年 lei. All rights reserved.
//

#import "BaseVC.h"
#import <SDWebImage/SDImageCache.h>
#import "../SLMacro/SLMacro.h"
#import <YYWebImage/YYWebImage.h>
#import <AFNetworking/AFNetworking.h>

@interface BaseVC ()

@end

@implementation BaseVC


//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController) {
     self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = sl_BGColors;
    //ios 15系统
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = sl_BGColors;
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = sl_divideLineColor;
        //设置字体颜色大小
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:sl_textColors,NSFontAttributeName:SLBFont(18)}];
        self.navigationController.navigationBar.standardAppearance = appperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
    }
    self.view.backgroundColor = sl_BGColors;
    
}



- (void)pop {
    if (self.navigationController == nil) return ;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootVc {
    if (self.navigationController == nil) return ;
    if (self.navigationController.viewControllers.count > 1) {
     self.navigationController.topViewController.hidesBottomBarWhenPushed = NO;
   }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)popToVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    if (self.navigationController == nil) return ;
//    if (self.navigationController.viewControllers.count > 0) {
//        UIViewController *popController = self.navigationController.viewControllers.lastObject;
//          if ([popController isKindOfClass:[vc class]]) {
//              popController.hidesBottomBarWhenPushed = NO;
//          }
//    }
    
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissWithCompletion:(void(^)())completion {
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)presentVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [self presentVc:vc completion:nil];
}

- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [self presentViewController:vc animated:YES completion:completion];
}

- (void)pushVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    if (self.navigationController == nil) return ;
    if (vc.hidesBottomBarWhenPushed == NO) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



- (void)loadData {
    
}

- (BOOL)isNetworkReachable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"=========:控制器销毁了%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

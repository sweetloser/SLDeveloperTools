//
//  BaseNavVC.m
//  BXlive
//
//  Created by bxlive on 2017/5/2.
//  Copyright © 2017年 lei. All rights reserved.
//

#import "BaseNavVC.h"
#import "../SLMacro/SLMacro.h"
@interface BaseNavVC ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavVC

// 取消导航栏的模糊效果
+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PageBackgroundColor;
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:MainTitleColor, NSFontAttributeName:CBFont(20)};
    [self.navigationBar setTitleTextAttributes:attributes];

}

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 32, 32);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if ([viewController respondsToSelector:@selector(backAction:)]) {
            [button addTarget:viewController action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        // 隐藏tabbar
        self.tabBarController.tabBar.hidden = YES;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (void)backAction:(UIButton *)sender {
    [self popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //如果手势是触摸的UISlider滑块触发的，侧滑返回手势就不响应
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}
@end

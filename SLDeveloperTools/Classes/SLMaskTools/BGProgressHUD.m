//
//  BGProgressHUD.m
//  BXlive
//
//  Created by huangzhiwen on 2017/3/30.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BGProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "BXLoadingView.h"
#import "../SLMacro/SLCommonMacro.h"
#import "../SLCategory/UIApplication+ActivityViewController.h"
#import "../SLCategory/UIColor+Kit.h"

static MBProgressHUD  *_progressHUD = nil;
static UIAlertController  *_alertController = nil;
static BXLoadingView *_dsLoadingView = nil;

@implementation BGProgressHUD

+ (MBProgressHUD *)showProgressHUDWithMessage:(NSString *)msg mode:(MBProgressHUDMode)mode autoHidden:(BOOL)autoHidden {
    [self hidden];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc]initWithView:window];
    [window addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    progressHUD.contentColor = [UIColor whiteColor];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
    progressHUD.bezelView.layer.cornerRadius = 14;
    progressHUD.mode = mode;
    progressHUD.label.text = msg;
    [progressHUD showAnimated:NO];
    for (UIView *view in progressHUD.bezelView.subviews) {
        if ([view isKindOfClass:[UIVisualEffectView class]]) {
            UIVisualEffectView *effectView = (UIVisualEffectView *)view;
            effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        }
    }
    _progressHUD = progressHUD;
  
    if (autoHidden) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hidden];
        });
    }
    return progressHUD;
}

+ (MBProgressHUD *)showInfoWithMessage:(NSString *)msg {
    return [self showProgressHUDWithMessage:msg mode:MBProgressHUDModeText autoHidden:YES];
}

+ (void)showLoadingAnimation {
    [BGProgressHUD showLoadingAnimation:[UIColor clearColor]];
}

+ (void)showLoadingAnimation:(UIColor *)color {
    [self showLoadingAnimation:color inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showLoadingAnimation:(UIColor *)color inView:(UIView *)inView {
    _dsLoadingView = [BXLoadingView showInView:inView width:__kWidth height:__kHeight];
    _dsLoadingView.backgroundColor = color;
}

+ (void)showConfirmWithMessage:(NSString *)msg {
    [self hidden];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _alertController = nil;
    }];
    [alertController addAction:ensureAction];
    [[[UIApplication sharedApplication] activityViewController] presentViewController:alertController animated:YES completion:nil];
    
    _alertController = alertController;
}

+ (void)showLoadingWithMessage:(NSString *)msg {
    [self setHubColor];
    [SVProgressHUD showWithStatus:msg];
}

+ (void)showProgress:(float)progress status:(NSString *)status {
    [self setHubColor];
    [SVProgressHUD showProgress:progress status:status];
}

+ (void)hidden {
    [SVProgressHUD dismiss];
    if (_progressHUD) {
        [_progressHUD hideAnimated:YES];
        _progressHUD = nil;
    }
    if (_alertController) {
        [_alertController dismissViewControllerAnimated:NO completion:nil];
        _alertController = nil;
    }
    if (_dsLoadingView) {
        [BXLoadingView hide:_dsLoadingView];
        _dsLoadingView = nil;
    }
}

//设置指示器颜色
+ (void)setHubColor {
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[[UIColor sl_colorWithHex:0x262626] colorWithAlphaComponent:1]];
    [SVProgressHUD setForegroundColor:[UIColor sl_colorWithHex:0xD1D1D1]];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
//    SVProgressHUD *sharedView = [SVProgressHUD performSelector:@selector(sharedView) withObject:nil];
#pragma clang diagnostic pop
    
//    UIVisualEffectView *hudView = [sharedView valueForKey:@"_hudView"];
//    hudView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    hudView.backgroundColor = [UIColor clearColor];
}

@end

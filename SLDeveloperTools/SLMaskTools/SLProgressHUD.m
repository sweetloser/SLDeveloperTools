//
//  SLProgressHUD.m
//  BXlive
//
//  Created by sweetloser on 2020/5/11.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLProgressHUD.h"
#import "BXLoadingView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"

static MBProgressHUD  *_slProgressHUD = nil;
static UIAlertController  *_slAlertController = nil;
static BXLoadingView *_slLoadingView = nil;
@implementation SLProgressHUD


+ (MBProgressHUD *)slShowLoadingWithoutBZViewInView:(UIView *)view;{
    [self hidden];
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.contentColor = sl_blackBGColors;
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.bezelView.layer.cornerRadius = 5;
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    [progressHUD showAnimated:NO];
    for (UIView *view in progressHUD.bezelView.subviews) {
        if ([view isKindOfClass:[UIVisualEffectView class]]) {
            UIVisualEffectView *effectView = (UIVisualEffectView *)view;
            effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            [effectView removeFromSuperview];
        }
    }
    _slProgressHUD = progressHUD;
  
    return progressHUD;
}

+ (MBProgressHUD *)slShowInfoWithMessage:(NSString *)msg {
    return [self slShowProgressHUDWithMessage:msg mode:MBProgressHUDModeText autoHidden:YES];
}

+ (MBProgressHUD *)slShowProgressHUDWithMessage:(NSString *)msg mode:(MBProgressHUDMode)mode autoHidden:(BOOL)autoHidden {
    [self hidden];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc]initWithView:window];
    [window addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.label.font = SLPFFont(13);
    progressHUD.contentColor = [UIColor whiteColor];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.bezelView.backgroundColor = sl_blackColors;
    progressHUD.bezelView.layer.cornerRadius = 5;
    progressHUD.mode = mode;
    progressHUD.label.text = msg;
    progressHUD.label.numberOfLines = 0;
    [progressHUD.label setTextColor:[UIColor sl_colorWithHex:0xD1D1D1]];
    [progressHUD showAnimated:NO];
    for (UIView *view in progressHUD.bezelView.subviews) {
        if ([view isKindOfClass:[UIVisualEffectView class]]) {
            UIVisualEffectView *effectView = (UIVisualEffectView *)view;
            effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        }
    }
    _slProgressHUD = progressHUD;
  
    if (autoHidden) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hidden];
        });
    }
    return progressHUD;
}

+ (void)hidden {
    [SVProgressHUD dismiss];
    if (_slProgressHUD) {
        [_slProgressHUD hideAnimated:YES];
        _slProgressHUD = nil;
    }
    if (_slAlertController) {
        [_slAlertController dismissViewControllerAnimated:NO completion:nil];
        _slAlertController = nil;
    }
    if (_slLoadingView) {
        [BXLoadingView hide:_slLoadingView];
        _slLoadingView = nil;
    }
}

@end

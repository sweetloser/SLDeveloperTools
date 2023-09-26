//
//  BGProgressHUD.h
//  BXlive
//
//  Created by huangzhiwen on 2017/3/30.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;
@interface BGProgressHUD : NSObject


/**
 *  普通提示
 *
 *  @param msg 消息
 */
+ (MBProgressHUD *)showInfoWithMessage:(NSString *)msg;

/**
 *  普通提示 (无文字，自定义动画)
 *
 *  @param msg 消息
 */
+ (void)showLoadingAnimation;

+ (void)showLoadingAnimation:(UIColor *)color;

+ (void)showLoadingAnimation:(UIColor *)color inView:(UIView *)inView;
/**
 *  确认提示 （UIAlertController）
 *
 *  @param msg 消息
 */
+ (void)showConfirmWithMessage:(NSString *)msg;

/**
 *  加载提示 (有转圈 不消失)
 *
 *  @param msg 消息
 */
+ (void)showLoadingWithMessage:(NSString *)msg;

/**
 *  进度提示 (不自动消失)
 *
 *  @param msg 消息
 */
+ (void)showProgress:(float)progress status:(NSString *)status;

/**
 *  隐藏提示信息
 *
 *
 */
+ (void)hidden;

@end

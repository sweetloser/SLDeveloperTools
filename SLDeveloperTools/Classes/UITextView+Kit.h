//
//  UITextView+Kit.h
//  BXlive
//
//  Created by huangzhiwen on 2017/3/28.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UITextView (Kit)<UITextViewDelegate>
@property (nonatomic, strong) UITextView *placeHolderTextView;
/**
 占位符
 */
- (void)addPlaceHolder:(NSString *)placeHolder;

/**
 位置大小CGRect
 */
-(UITextView *(^)(CGRect))textViewRect;
/**
 背景颜色
 */
-(UITextView *(^)(UIColor *))textViewBackGroundColor;
/**
 文字颜色
 */
-(UITextView *(^)(UIColor *))textViewTitleColor;
/**
 字体大小
 */
-(UITextView *(^)(float))textViewFontSize;
/**
 边框颜色
 */
-(UITextView *(^)(UIColor *))textViewBorderColor;
/**
 边框大小
 */
-(UITextView *(^)(float))textViewBorderWidth;
/**
 textView圆角
 */
-(UITextView *(^)(float))textViewCornerRadius;
/**
 委托
 */
-(UITextView *(^)(id<UITextViewDelegate>))textViewDelegate;
/**
 位置 ,居左,居中,居右
 */
-(UITextView *(^)(NSTextAlignment))textViewTextAlignment;
/**
 添加到某个view上
 */
-(UITextView *(^)(UIView *))textViewSuperView;
@end

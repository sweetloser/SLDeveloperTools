//
//  UILabel+Kit.h
//  BXlive
//
//  Created by huangzhiwen on 2017/3/28.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Kit)

+ (UILabel *)initWithFrame:(CGRect)frame                // 结构
                      size:(CGFloat)size                // 尺寸
                     color:(UIColor *)color             // 颜色
                 alignment:(NSTextAlignment)alignment   // 对齐方式
                     lines:(NSInteger)lines;            // 行数

/**
 *  初始化UILael
 */
+ (UILabel *)initWithFrame:(CGRect)frame                // 结构
                      text:(NSString *)text             // 标题
                      size:(CGFloat)size                // 尺寸
                     color:(UIColor *)color             // 颜色
                 alignment:(NSTextAlignment)alignment   // 对齐方式
                     lines:(NSInteger)lines             // 行数
               shadowColor:(UIColor *)colorShadow;      // 阴影颜色

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

//label自适应大小
+(CGFloat)zzlAutoSizeOfHeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

+(CGFloat)zzlAutoSizeOfWidthWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height;
/**
 返回一条线
 
 @param rect rect
 @param bgColor 背景颜色
 @return label
 */
+(UILabel *)creatLabelLine:(CGRect)rect backgroundColor:(UIColor *)bgColor;



/**
 位置 ,居左,居中,居右
 */
-(UILabel *(^)(NSTextAlignment))LabelTextAlignment;

/**
 背景颜色
 */
-(UILabel *(^)(UIColor *))LabelBackGroundColor;

/**
 文字颜色
 */
-(UILabel *(^)(UIColor *))LabelTextColor;

/**
 文字
 */
-(UILabel *(^)(NSString *))LabelText;

/**
 字体大小
 */
-(UILabel *(^)(float))LabelFontSize;

/**
 位置大小CGRect
 */
-(UILabel *(^)(CGRect))LabelRect;

/**
 边框颜色
 */
-(UILabel *(^)(UIColor *))LabelBorderColor;

/**
 边框大小
 */
-(UILabel *(^)(float))LabelBorderWidth;

/**
 阴影颜色
 */
-(UILabel *(^)(UIColor *))LabelShadowColor;

/**
 阴影偏移量
 */
-(UILabel *(^)(CGSize))LabelShadowOffset;

/**
 label圆角
 */
-(UILabel *(^)(float))LabelCornerRadius;

/**
 行数
 */
-(UILabel *(^)(int))LabelLines;
/**
 添加到某个view上
 */
-(UILabel *(^)(UIView *))LabelSuperView;


@end

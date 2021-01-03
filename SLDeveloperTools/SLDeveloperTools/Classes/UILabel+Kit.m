//
//  UILabel+Kit.m
//  BXlive
//
//  Created by huangzhiwen on 2017/3/28.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "UILabel+Kit.h"

@implementation UILabel (Kit)

/* 初始化UILael */
+ (UILabel *)initWithFrame:(CGRect)frame                // 结构
                      size:(CGFloat)size                // 尺寸
                     color:(UIColor *)color             // 颜色
                 alignment:(NSTextAlignment)alignment   // 对齐方式
                     lines:(NSInteger)lines             // 行数
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:size]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:color];
    [label setTextAlignment:alignment];
    [label setNumberOfLines:lines];
    
    return label;
}

/* 初始化UILael */
+ (UILabel *)initWithFrame:(CGRect)frame                // 结构
                      text:(NSString *)text             // 标题
                      size:(CGFloat)size                // 尺寸
                     color:(UIColor *)color             // 颜色
                 alignment:(NSTextAlignment)alignment   // 对齐方式
                     lines:(NSInteger)lines             // 行数
               shadowColor:(UIColor *)colorShadow       // 阴影颜色
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setFont:[UIFont systemFontOfSize:size]];
    [label setText:text];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:color];
    [label setShadowColor:colorShadow];
    [label setTextAlignment:alignment];
    [label setNumberOfLines:lines];
    
    return label;
}
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

/**
 *  @author lei
 *
 *  lable宽高自适应
 */
+(CGFloat)zzlAutoSizeOfHeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attributesDic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil];
    return frame.size.height;
}
+(CGFloat)zzlAutoSizeOfWidthWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height{
    CGSize size = CGSizeMake(MAXFLOAT, height);
    NSDictionary *attributesDic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil];
    return frame.size.height;
}

/**
 返回一条线
 
 @param rect rect
 @param bgColor 背景颜色
 @return label
 */
+(UILabel *)creatLabelLine:(CGRect)rect
           backgroundColor:(UIColor *)bgColor
{
    UILabel * label = [[UILabel alloc]initWithFrame:rect];
    label.backgroundColor = bgColor;
    return label;
}

/**
 位置 ,居左,居中,居右
 */
-(UILabel *(^)(NSTextAlignment))LabelTextAlignment{
    return ^(NSTextAlignment textAlignment){
        self.textAlignment = textAlignment;
        return self;
    };
}
/**
 背景颜色
 */
-(UILabel *(^)(UIColor *))LabelBackGroundColor{
    return ^(UIColor *backGroundColor){
        self.backgroundColor = backGroundColor;
        return self;
    };
}
/**
 文字颜色
 */
-(UILabel *(^)(UIColor *))LabelTextColor{
    return ^(UIColor *textColor){
        self.textColor = textColor;
        return self;
    };
}
/**
 文字
 */
-(UILabel *(^)(NSString *))LabelText{
    return ^(NSString *text){
        self.text = text;
        return self;
    };
}
/**
 字体大小
 */
-(UILabel *(^)(float))LabelFontSize{
    return ^(float fontSize){
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}
/**
 位置大小CGRect
 */
-(UILabel *(^)(CGRect))LabelRect{
    return ^(CGRect frame){
        self.frame = frame;
        return self;
    };
}
/**
 边框颜色
 */
-(UILabel *(^)(UIColor *))LabelBorderColor{
    return ^(UIColor *borderColor){
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
    
}
/**
 边框大小
 */
-(UILabel *(^)(float))LabelBorderWidth{
    return ^(float borderWidth){
        self.layer.borderWidth = borderWidth;
        return self;
    };
}
/**
 阴影颜色
 */
-(UILabel *(^)(UIColor *))LabelShadowColor{
    return ^(UIColor *shadowColor){
        self.shadowColor = shadowColor;
        return self;
    };
    
}
/**
 阴影偏移量
 */
-(UILabel *(^)(CGSize))LabelShadowOffset{
    return ^(CGSize size){
        self.shadowOffset = size;
        return self;
    };
}

/**
 label圆角
 */
-(UILabel *(^)(float))LabelCornerRadius{
    return ^(float cornerRadius){
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
        return self;
    };
}
/**
 行数
 */
-(UILabel *(^)(int))LabelLines{
    return ^(int lines){
        self.numberOfLines = lines;
        return self;
    };
}
/**
 添加到某个view上
 */
-(UILabel *(^)(UIView *))LabelSuperView{
    return ^(UIView *view){
        [view addSubview:self];
        return self;
    };
}



@end

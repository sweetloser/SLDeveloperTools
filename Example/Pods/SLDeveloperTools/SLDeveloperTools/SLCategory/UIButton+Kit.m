//
//  UIButton+Kit.m
//  BXlive
//
//  Created by huangzhiwen on 2017/3/28.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "UIButton+Kit.h"
#import "UIColor+Kit.h"
#import "UIImage+Kit.h"


@implementation UIButton (Kit)

/* 给定框架创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
{
    return [UIButton initWithFrame:frame
                             title:nil];
}

/* 给定框架和字符串(字符串字体颜色默认是白色)创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title
{
    return [UIButton initWithFrame:frame
                             title:title
                   backgroundImage:nil];
}

/* 给定框架、字符串和背景图片创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title
            backgroundImage:(UIImage *__nullable)backgroundImage
{
    return [UIButton initWithFrame:frame
                             title:title
                   backgroundImage:backgroundImage
        highlightedBackgroundImage:nil];
}

/* 给定框架、字符串、背景图片和高亮背景图片创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title
            backgroundImage:(UIImage *__nullable)backgroundImage
 highlightedBackgroundImage:(UIImage *__nullable)highlightedBackgroundImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title
            forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage
                      forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBackgroundImage
                      forState:UIControlStateHighlighted];
    return button;
}

/* 给定框架、字符串、颜色创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title
                      color:(UIColor *__nullable)color
{
    // 返回与'色'关联的颜色组件（包括透明度)
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [UIButton initWithFrame:frame
                             title:title
                   backgroundImage:[UIImage imageWithColor:color]
        highlightedBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:components[0]-0.1
                                                                           green:components[1]-0.1
                                                                            blue:components[2]-0.1
                                                                           alpha:1]]];
}

/* 给定框架、字符串、背景颜色和高亮背景颜色创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title
                      color:(UIColor *__nullable)color
           highlightedColor:(UIColor *__nullable)highlightedColor
{
    return [UIButton initWithFrame:frame
                             title:title
                   backgroundImage:[UIImage imageWithColor:color]
        highlightedBackgroundImage:[UIImage imageWithColor:highlightedColor]];
}

/* 给定框架、颜色创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      color:(UIColor *__nullable)color
{
    // 返回与'色'关联的颜色组件（包括透明度)
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [UIButton initWithFrame:frame
                             title:nil
                   backgroundImage:[UIImage imageWithColor:color]
        highlightedBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:components[0]-0.1
                                                                           green:components[1]-0.1
                                                                            blue:components[2]-0.1
                                                                           alpha:1]]];
}

/* 给定框架、背景颜色和高亮背景颜色创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      color:(UIColor *__nullable)color
           highlightedColor:(UIColor *__nullable)highlightedColor
{
    return [UIButton initWithFrame:frame
                             title:nil
                   backgroundImage:[UIImage imageWithColor:color]
        highlightedBackgroundImage:[UIImage imageWithColor:highlightedColor]];
}

/* 给定框架和图片创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      image:(UIImage *__nullable)image
{
    return [UIButton initWithFrame:frame
                             image:image
                  highlightedImage:nil];
}

/* 给定框架、背景图片和高亮背景图片创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      image:(UIImage *__nullable)image
           highlightedImage:(UIImage *__nullable)highlightedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:image
            forState:UIControlStateNormal];
    [button setImage:highlightedImage
            forState:UIControlStateHighlighted];
    return button;
}

/**
 *  创建图片按钮和选中按钮图片
 *
 *  @param frame         位置
 *  @param image         普通状态下图片
 *  @param selectedImage 选中状态下图片
 *
 *  @return 按钮
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      Image:(UIImage *__nullable)image
              SelectedImage:(UIImage *__nullable)selectedImage
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:image
            forState:UIControlStateNormal];
    [button setImage:selectedImage
            forState:UIControlStateSelected];
    return button;
    
}

/* 设置字符颜色 */
- (void)setTitleColor:(UIColor *__nullable)color
{
    [self setTitleColor:color
       highlightedColor:[UIColor colorWithColor:color
                                          alpha:0.4]];
}

/* 设置字符颜色和高亮颜色 */
- (void)setTitleColor:(UIColor *__nullable)color
     highlightedColor:(UIColor *__nullable)highlightedColor
{
    [self setTitleColor:color
               forState:UIControlStateNormal];
    [self setTitleColor:highlightedColor
               forState:UIControlStateHighlighted];
}

/**
 *  初始化按钮颜色和选中颜色
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      Title:(NSString *__nullable)title
                       Font:(UIFont *__nullable)font
                      color:(UIColor *__nullable)color
                SelectColor:(UIColor *__nullable)selectColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:selectColor forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

/**
 *  初始化按钮颜色和选中颜色标框和选中颜色
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      Title:(NSString *__nullable)title
                       Font:(UIFont *__nullable)font
                      Color:(UIColor *__nullable)color
               CornerRadius:(CGFloat)cornerRadius
                BorderWidth:(CGFloat)borderWidth
                BorderColor:(UIColor *__nullable)borderColor
                SelectColor:(UIColor *__nullable)selectColor
            BackgroundColor:(UIColor *__nullable)backgroundColor
           HighlightedColor:(UIColor *__nullable)highlightedColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:selectColor forState:UIControlStateSelected];
    [btn setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = backgroundColor;
    btn.layer.cornerRadius = cornerRadius;
    btn.layer.borderWidth = borderWidth;
    btn.layer.borderColor = borderColor.CGColor;
    
    return btn;
}


/**
 创建按钮
 
 @param frame 位置
 @param title 标题
 @param font  字体
 @param color 颜色
 @param image 图片
 
 @return 按钮
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame Title:(NSString *__nullable)title Font:(UIFont *)font Color:(UIColor *__nullable)color Image:(UIImage *__nullable)image Target:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    //    btn.titleLabel.backgroundColor = [UIColor redColor];
    //    btn.backgroundColor = [UIColor yellowColor];
    //    btn.imageView.backgroundColor = [UIColor blueColor];
    return btn;
    
}

+ (UIButton *)buttonWithFrame:(CGRect)frame Title:(NSString *__nullable)title Font:(UIFont *)font Color:(UIColor *__nullable)color Image:(UIImage *__nullable)image Target:(nullable id)target action:(SEL __nullable)action forControlEvents:(UIControlEvents)controlEvents ImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing
{
    UIButton *btn = [self buttonWithFrame:frame Title:title Font:font Color:color Image:image Target:target action:action forControlEvents:controlEvents];
    [btn setImagePosition:postion margin:spacing];
    return btn;
}

- (UIButton *)initWithFrame:(CGRect)frame Title:(NSString *__nullable)title Font:(UIFont *)font Color:(UIColor *__nullable)color Image:(UIImage *__nullable)image Target:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents ImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleLabel.font = font;
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:target action:action forControlEvents:controlEvents];
        [self setImagePosition:postion margin:spacing];
    }
    return self;
}


- (void)setImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (postion) {
        case ImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case ImagePositionRight:
            
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case ImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case ImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
    
}

- (void)setImagePosition:(ImagePosition)postion margin:(CGFloat)spacing
{
    
    //    CGFloat imageWith = self.imageView.image.size.width;
    //    CGFloat imageHeight = self.imageView.image.size.height;
    //    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    //    CGFloat lagelHeight = self.titleLabel.bounds.size.height;
    
    
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    CGFloat labelHeight = self.titleLabel.bounds.size.height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    CGFloat selectW = labelWidth>imageWith?labelWidth:imageWith;
    
    self.imageView.contentMode = UIViewContentModeCenter;
    
    CGFloat imageCenterX = (self.bounds.size.width - selectW)/2.0;
    
    switch (postion) {
        case ImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case ImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case ImagePositionTop:
            //            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            //            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(imageHeight,-imageWith, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(-(labelHeight+spacing),imageCenterX,0,  0);
            break;
            
        case ImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
    
    
    //    CGFloat imageWith = self.imageView.image.size.width;
    //    CGFloat imageHeight = self.imageView.image.size.height;
    //    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    //    CGFloat lagelHeight = self.titleLabel.bounds.size.height;
    //    CGFloat selectW = labelWidth>imageWith?labelWidth:imageWith;
    //
    //    self.imageView.contentMode = UIViewContentModeCenter;
    //
    //    CGFloat imageCenterX = (self.bounds.size.width - selectW)/2.0;
    //
    //    self.titleEdgeInsets = UIEdgeInsetsMake(imageHeight,-imageWith, 0, 0);
    //
    //    self.imageEdgeInsets = UIEdgeInsetsMake(-(lagelHeight+margin),imageCenterX,0,  0);
    
    
}
/**
 背景颜色
 */
-(UIButton *(^)(UIColor *))buttonBackGroundColor{
    return ^(UIColor *backGroundColor){
        self.backgroundColor = backGroundColor;
        return self;
    };
}
/**
 文字颜色
 */
-(UIButton *(^)(UIColor *))buttonTitleColor{
    return ^(UIColor *textColor){
        [self setTitleColor:textColor forState:UIControlStateNormal];
        return self;
    };
}
/**
 文字选中颜色
 */
-(UIButton *(^)(UIColor *))buttonSelectColor{
    return ^(UIColor *textSelectColor){
        [self setTitleColor:textSelectColor forState:UIControlStateSelected];
        return self;
    };
}
/**
 文字高亮颜色
 */
-(UIButton *(^)(UIColor *))buttonHighlightedColor{
    return ^(UIColor *textHighlightedColor){
        [self setTitleColor:textHighlightedColor forState:UIControlStateHighlighted];
        return self;
    };
}
/**
 文字
 */
-(UIButton *(^)(NSString *))buttonTitle{
    return ^(NSString *text){
        [self setTitle:text forState:UIControlStateNormal];
        return self;
    };
}
/**
 文字(选中状态)
 */
-(UIButton *(^)(NSString *))buttonSelectTitle{
    return ^(NSString *selectText){
        [self setTitle:selectText forState:UIControlStateSelected];
        return self;
    };
}
/**
 字体大小
 */
-(UIButton *(^)(float))buttonFontSize{
    return ^(float fontSize){
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}
/**
 位置大小CGRect
 */
-(UIButton *(^)(CGRect))buttonRect{
    return ^(CGRect frame){
        self.frame = frame;
        return self;
    };
}
/**
 边框颜色
 */
-(UIButton *(^)(UIColor *))buttonBorderColor{
    return ^(UIColor *borderColor){
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
    
}
/**
 边框大小
 */
-(UIButton *(^)(float))buttonBorderWidth{
    return ^(float borderWidth){
        self.layer.borderWidth = borderWidth;
        return self;
    };
}
/**
 button圆角
 */
-(UIButton *(^)(float))buttonCornerRadius{
    return ^(float cornerRadius){
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
        return self;
    };
}/**
  图片
  */
-(UIButton *(^)(UIImage *))buttonImage{
    return ^(UIImage *image){
        [self setImage:image forState:UIControlStateNormal];
        return self;
    };
}
/**
 选中图片
 */
-(UIButton *(^)(UIImage *))buttonSelectImage{
    return ^(UIImage *seleImage){
        [self setImage:seleImage forState:UIControlStateSelected];
        return self;
    };
}
/**
 图片
 */
-(UIButton *(^)(UIImage *))buttonBackImage{
    return ^(UIImage *backImage){
        [self setBackgroundImage:backImage forState:UIControlStateSelected];
        return self;
    };
}
/**
 选中图片
 */
-(UIButton *(^)(UIImage *))buttonBackSelectImage{
    return ^(UIImage *backSeleImage){
        [self setBackgroundImage:backSeleImage forState:UIControlStateSelected];
        return self;
    };
}
/**
 添加到某个view上
 */
-(UIButton *(^)(UIView *))buttonSuperView{
    return ^(UIView *view){
        [view addSubview:self];
        return self;
    };
}


@end

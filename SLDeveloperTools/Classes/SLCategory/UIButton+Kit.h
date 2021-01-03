//
//  UIButton+Kit.h
//  BXlive
//
//  Created by huangzhiwen on 2017/3/28.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, ImagePosition) {
    ImagePositionLeft = 0,              //图片在左，文字在右，默认
    ImagePositionRight = 1,             //图片在右，文字在左
    ImagePositionTop = 2,               //图片在上，文字在下
    ImagePositionBottom = 3,            //图片在下，文字在上
};
@interface UIButton (Kit)


/**
 给定框架创建一个UIButton对象
 
 @param frame frame
 @return UIButton
 */
+ (UIButton *)initWithFrame:(CGRect)frame;

/**
 *  给定框架和字符串(字符串字体颜色默认是白色)创建一个UIButton对象
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title;

/**
 *  给定框架、字符串和背景图片创建一个UIButton对象
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title
            backgroundImage:(UIImage *__nullable)backgroundImage;

/**
 *  给定框架、字符串、背景图片和高亮背景图片创建一个UIButton对象
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title
            backgroundImage:(UIImage *__nullable)backgroundImage
 highlightedBackgroundImage:(UIImage *__nullable)highlightedBackgroundImage;

/**
 *  给定框架、字符串、颜色创建一个UIButton对象
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title
                      color:(UIColor *__nullable)color;

/**
 *  给定框架、字符串、背景颜色和高亮背景颜色创建一个UIButton对象
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      title:(NSString *__nullable)title
                      color:(UIColor *__nullable)color
           highlightedColor:(UIColor *__nullable)highlightedColor;

/**
 *  给定框架、颜色创建一个UIButton对象
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      color:(UIColor *__nullable)color;

/**
 *  给定框架、背景颜色和高亮背景颜色创建一个UIButton对象
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      color:(UIColor *__nullable)color
           highlightedColor:(UIColor *__nullable)highlightedColor;

/**
 *  给定框架和图片创建一个UIButton对象
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      image:(UIImage *__nullable)image;

/**
 *  给定框架、背景图片和高亮背景图片创建一个UIButton对象 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      image:(UIImage *__nullable)image
           highlightedImage:(UIImage *__nullable)highlightedImage;

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
              SelectedImage:(UIImage *__nullable)selectedImage;


/**
 *  设置字符颜色
 */
- (void)setTitleColor:(UIColor *__nullable)color;

/**
 *  设置字符颜色和高亮颜色
 */
- (void)setTitleColor:(UIColor *__nullable)color
     highlightedColor:(UIColor *__nullable)highlightedColor;


/**
 *  初始化按钮颜色和选中颜色
 */
+ (UIButton *)initWithFrame:(CGRect)frame
                      Title:(NSString *__nullable)title
                       Font:(UIFont *__nullable)font
                      color:(UIColor *__nullable)color
                SelectColor:(UIColor *__nullable)selectColor;

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
           HighlightedColor:(UIColor *__nullable)highlightedColor;


/**
 创建按钮
 
 @param frame 位置
 @param title 标题
 @param font 字体
 @param color 颜色
 @param image 图片
 @param target self
 @param action 选择器
 @param controlEvents controlEvents
 @return 按钮
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame Title:(NSString *__nullable)title Font:(UIFont *)font Color:(UIColor *__nullable)color Image:(UIImage *__nullable)image Target:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;


/**
 创建按钮
 
 @param frame 位置
 @param title 标题
 @param font 字体
 @param color 颜色
 @param image 图片
 @param target self
 @param action 选择器
 @param controlEvents controlEvents
 @param postion 位置
 @param spacing 距离
 @return 按钮
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame Title:(NSString *__nullable)title Font:(UIFont *)font Color:(UIColor *__nullable)color Image:(UIImage *__nullable)image Target:(nullable id)target action:(SEL __nullable)action forControlEvents:(UIControlEvents)controlEvents ImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing;
- (UIButton *)initWithFrame:(CGRect)frame Title:(NSString *__nullable)title Font:(UIFont *)font Color:(UIColor *__nullable)color Image:(UIImage *__nullable)image Target:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents ImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing;


- (void)setImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing;

/**
 背景颜色
 */
-(UIButton *(^)(UIColor *))buttonBackGroundColor;
/**
 文字颜色
 */
-(UIButton *(^)(UIColor *))buttonTitleColor;
/**
 文字选中颜色
 */
-(UIButton *(^)(UIColor *))buttonSelectColor;
/**
 文字高亮颜色
 */
-(UIButton *(^)(UIColor *))buttonHighlightedColor;
/**
 文字(正常状态)
 */
-(UIButton *(^)(NSString *))buttonTitle;
/**
 文字(选中状态)
 */
-(UIButton *(^)(NSString *))buttonSelectTitle;
/**
 字体大小
 */
-(UIButton *(^)(float))buttonFontSize;

/**
 位置大小CGRect
 */
-(UIButton *(^)(CGRect))buttonRect;

/**
 边框颜色
 */
-(UIButton *(^)(UIColor *))buttonBorderColor;

/**
 边框大小
 */
-(UIButton *(^)(float))buttonBorderWidth;

/**
 button圆角
 */
-(UIButton *(^)(float))buttonCornerRadius;
/**
 图片
 */
-(UIButton *(^)(UIImage *))buttonImage;
/**
 选中图片
 */
-(UIButton *(^)(UIImage *))buttonSelectImage;
/**
 图片
 */
-(UIButton *(^)(UIImage *))buttonBackImage;
/**
 选中图片
 */
-(UIButton *(^)(UIImage *))buttonBackSelectImage;
/**
 添加到某个view上
 */
-(UIButton *(^)(UIView *))buttonSuperView;

@end


NS_ASSUME_NONNULL_END

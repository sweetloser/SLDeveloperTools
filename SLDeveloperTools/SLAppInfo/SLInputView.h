//
//  SLInputView.h
//  BXlive
//
//  Created by sweetloser on 2020/7/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,InputViewStyle) {
    InputViewStyleDefault,
    InputViewStyleLarge,
};

@class SLInputView;
@protocol SLInputViewDelagete <NSObject>

@optional

/**
//如果你工程中有配置IQKeyboardManager,并对DSInputView造成影响,
 请在DSInputView将要显示代理方法里 将IQKeyboardManager的enableAutoToolbar及enable属性 关闭
 请在DSInputView将要消失代理方法里 将IQKeyboardManager的enableAutoToolbar及enable属性 打开
 如下:
 
//BXInputView 将要显示
-(void)DSInputViewWillShow:(BXInputView *)inputView{
 [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
 [IQKeyboardManager sharedManager].enable = NO;
}

//BXInputView 将要影藏
-(void)DSInputViewWillHide:(BXInputView *)inputView{
     [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
     [IQKeyboardManager sharedManager].enable = YES;
}
*/

/**
 BXInputView 将要显示
 
 @param inputView inputView
 */
-(void)SLInputViewWillShow:(SLInputView *)inputView;

/**
 BXInputView 将要影藏

 @param inputView inputView
 */
-(void)SLInputViewWillHide:(SLInputView *)inputView;



@end

@interface SLInputView : UIView

@property (nonatomic, assign) id<SLInputViewDelagete> delegate;

/** 最大输入字数 */
@property (nonatomic, assign) NSInteger maxCount;
/** 字体 */
@property (nonatomic, strong) UIFont * font;
/** 占位符 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位符颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 输入框背景颜色 */
@property (nonatomic, strong) UIColor* textViewBackgroundColor;
/** 发送按钮背景色 */
@property (nonatomic, strong) UIColor *sendButtonBackgroundColor;
/** 发送按钮Title */
@property (nonatomic, copy) NSString *sendButtonTitle;
/** 发送按钮圆角大小 */
@property (nonatomic, assign) CGFloat sendButtonCornerRadius;
/** 发送按钮字体 */
@property (nonatomic, strong) UIFont * sendButtonFont;
/** 图片 */
@property (nonatomic, copy) NSString *placeImage;
/** 名称 */
@property (nonatomic, copy) NSString * nameString;
/** 价格 */
@property (nonatomic, copy) NSString *priceString;

/**
 显示输入框

 @param style 类型
 @param configurationBlock 请在此block中设置BXInputView属性
 @param sendBlock 发送按钮点击回调
 */
+(void)showWithStyle:(InputViewStyle)style configurationBlock:(void(^)(SLInputView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text))sendBlock;

@end

NS_ASSUME_NONNULL_END

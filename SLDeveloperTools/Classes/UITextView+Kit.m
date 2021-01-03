//
//  UITextView+Kit.m
//  BXlive
//
//  Created by huangzhiwen on 2017/3/28.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "UITextView+Kit.h"

@implementation UITextView (Kit)
static const char *phTextView = "placeHolderTextView";
- (UITextView *)placeHolderTextView {
    return objc_getAssociatedObject(self, phTextView);
}
- (void)setPlaceHolderTextView:(UITextView *)placeHolderTextView {
    objc_setAssociatedObject(self, phTextView, placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)addPlaceHolder:(NSString *)placeHolder {
    if (![self placeHolderTextView]) {
        self.delegate = self;
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.font = self.font;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor grayColor];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        [self setPlaceHolderTextView:textView];
    }
}
# pragma mark -
# pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeHolderTextView.hidden = YES;
    // if (self.textViewDelegate) {
    //
    // }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text && [textView.text isEqualToString:@""]) {
        self.placeHolderTextView.hidden = NO;
    }
}

- (void)_firstBaselineOffsetFromTop{
    
}
- (void)_baselineOffsetFromBottom{
    
}
/**
 位置大小CGRect
 */
-(UITextView *(^)(CGRect))textViewRect{
    return ^(CGRect frame){
        self.frame = frame;
        return self;
    };
}
/**
 背景颜色
 */
-(UITextView *(^)(UIColor *))textViewBackGroundColor{
    return ^(UIColor *backGroundColor){
        self.backgroundColor = backGroundColor;
        return self;
    };
}
/**
 文字颜色
 */
-(UITextView *(^)(UIColor *))textViewTitleColor{
    return ^(UIColor *textColor){
        self.textColor = textColor;
        return self;
    };
}
/**
 字体大小
 */
-(UITextView *(^)(float))textViewFontSize{
    return ^(float fontSize){
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}
/**
 委托
 */
-(UITextView *(^)(id<UITextViewDelegate>))textViewDelegate{
    return ^(id delegate){
        self.delegate = delegate;
        return self;
    };
}
/**
 位置 ,居左,居中,居右
 */
-(UITextView *(^)(NSTextAlignment))textViewTextAlignment{
    return ^(NSTextAlignment textAlignment){
        self.textAlignment = textAlignment;
        return self;
    };
}
/**
 添加到某个view上
 */
-(UITextView *(^)(UIView *))textViewSuperView{
    return ^(UIView *view){
        [view addSubview:self];
        return self;
    };
}

/**
 边框颜色
 */
-(UITextView *(^)(UIColor *))textViewBorderColor{
    return ^(UIColor *borderColor){
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
}

/**
 边框大小
 */
-(UITextView *(^)(float))textViewBorderWidth{
    return ^(float borderWidth){
        self.layer.borderWidth = borderWidth;
        return self;
    };
}

/**
 textView圆角
 */
-(UITextView *(^)(float))textViewCornerRadius{
    return ^(float cornerRadius){
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
        return self;
    };
}


@end

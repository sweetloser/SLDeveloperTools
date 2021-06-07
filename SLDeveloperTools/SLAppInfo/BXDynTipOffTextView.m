//
//  BXDynTipOffTextView.m
//  BXlive
//
//  Created by mac on 2020/7/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTipOffTextView.h"
#import <HPGrowingTextView/HPGrowingTextView.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "BXDynTipOffPeopleFooterView.h"

@interface BXDynTipOffTextView()<HPGrowingTextViewDelegate,UITextViewDelegate>
@property (nonatomic,strong) HPGrowingTextView *growingTextView;;//文字
@property(nonatomic, strong)UILabel *textlabel;
@end
@implementation BXDynTipOffTextView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTextView];
    }
    return self;
}
-(void)initTextView{
//    self.growingTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(16,0, SCREEN_WIDTH-30, 38)];
//    self.growingTextView.contentInset = UIEdgeInsetsMake(5,5,5,5);
//    self.growingTextView.minHeight = 145;
//    self.growingTextView.delegate = self;
//    self.growingTextView.textColor = WhiteBgTitleColor;
//    self.growingTextView.font = CFont(14);
//    self.growingTextView.minNumberOfLines = 1;
//    self.growingTextView.maxNumberOfLines = 10;
//    self.growingTextView.animateHeightChange = YES;
//    self.growingTextView.placeholder = @"陈述理由(字数最多140个字)";
//    self.growingTextView.placeholderColor = UIColorHex(B0B0B0);
//    self.growingTextView.returnKeyType = UIReturnKeySend;
//    self.growingTextView.enablesReturnKeyAutomatically = YES;
//    self.growingTextView.backgroundColor =  sl_subBGColors;
//    [self addSubview:self.growingTextView];
    
     _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 335, 200)];
        _textView.layer.cornerRadius = 5;
//        [_textView becomeFirstResponder];
        _textView.layer.masksToBounds = YES;
    self.textView.backgroundColor =  sl_subBGColors;
//        _textView.layer.borderColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1.00].CGColor;
//        _textView.layer.borderWidth = 1;
    //    _textView.backgroundColor = [UIColor grayColor];
        
        //文本
        _textView.text = @" 陈述理由(字数最多140个字)";
        //字体
//    _textView.placeholder = @" 陈述理由(字数最多140个字)";
        _textView.font = [UIFont systemFontOfSize:14];
        //对齐
        _textView.textAlignment = 0;
        //字体颜色
        _textView.textColor = [UIColor grayColor];
        //允许编辑
        _textView.editable = YES;
        //用户交互     ///////若想有滚动条 不能交互 上为No，下为Yes
        _textView.userInteractionEnabled = YES; ///
        //自定义键盘
        //textView.inputView = view;//自定义输入区域
        //textView.inputAccessoryView = view;//键盘上加view
        _textView.delegate = self;
        [self addSubview:_textView];
        
        _textView.scrollEnabled = YES;//滑动
        _textView.returnKeyType = UIReturnKeyDone;//返回键类型
        _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    //    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;//数据类型连接模式
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;//自动纠错方式
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;//自动大写方式
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.height.mas_equalTo(150);
    }];
    
    _textlabel = [[UILabel alloc]init];
    _textlabel.textAlignment = 2;
    _textlabel.textColor = [UIColor sl_colorWithHex:0xFF2D52];
    _textlabel.text = @"0/140";
    _textlabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_textlabel];
    [_textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-22);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(-25);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
}

////////////事件
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    //判断类型，如果不是UITextView类型，收起键盘
//    for (UIView* view in self.subviews) {
//        if ([view isKindOfClass:[UITextView class]]) {
//            UITextView* tv = (UITextView*)view;
//            [tv resignFirstResponder];
//        }
//    }
//}
//
//- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
//{
//    [self.growingTextView resignFirstResponder];
//    return YES;
//}
//- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//
//
//    if ([text isEqualToString:@"\n"]){
//        //禁止输入换行
//        return NO;
//    }
//
//    return YES;
//}
//
//- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
//{
//
//
//    if (growingTextView.text.length >= 140) {
//        growingTextView.text = [growingTextView.text substringToIndex:140];
//    }
//
//    _textlabel.text = [NSString stringWithFormat:@"%lu/140", (unsigned long)growingTextView.text.length];
//
//    if (growingTextView.text.length<=0) {
//        growingTextView.textColor = WhiteBgTitleColor;
//    }
//
//}
//
//
//- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{
//
//}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  
    //控制文本输入内容
//    if (range.location>=100){
//        //控制输入文本的长度
//        return  NO;
//    }
    if ([text isEqualToString:@"\n"]){
        //禁止输入换行
        return NO;
    }
    
    return YES;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @" 陈述理由(字数最多140个字)";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@" 陈述理由(字数最多140个字)"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
//    if (textView.text.length > 0) {
//        _textView.placeholder = @"";
//    }else{
//        _textView.placeholder = @" 陈述理由(字数最多140个字)";
//    }
    if (textView.text.length >= 140) {
        textView.text = [textView.text substringToIndex:140];
    }
    if ([self.delegate respondsToSelector:@selector(GetTipOffText:)]) {
        [self.delegate GetTipOffText:textView.text];
    }
    _textlabel.text = [NSString stringWithFormat:@"%lu/140", (unsigned long)textView.text.length];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

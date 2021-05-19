//
//  BXSendCommentView.m
//  BXlive
//
//  Created by bxlive on 2019/5/10.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSendCommentView.h"
#import "BXHHEmojiView.h"
#import <HPGrowingTextView/HPGrowingTextView.h>
#import "HPGrowingTextView.h"
#import "BXAiteFriendVC.h"
#import "BXGradientButton.h"
#import "BXDynAiTeCategoryVC.h"
#import <Masonry/Masonry.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"

@interface BXSendCommentView ()<HPGrowingTextViewDelegate>
@property (strong, nonatomic) NSMutableArray *AtArray;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic,strong) HPGrowingTextView *growingTextView;;//文字
@property (strong, nonatomic) UIButton *emojiBtn;
@property (strong, nonatomic) UIButton *atBtn;
@property (strong, nonatomic) UIButton *sendBtn;
@property (strong, nonatomic) BXHHEmojiView *emojiView;
@property (assign, nonatomic) CGFloat maxHeight;
@property (assign, nonatomic) BOOL isEmoji;
@end

@implementation BXSendCommentView


-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.AtArray = [NSMutableArray array];
        UIView *maskView = [[UIView alloc]init];
        [self addSubview:maskView];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        _contentView = [[UIView alloc]init];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        _topView = [[UIView alloc]init];
        [_contentView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
        
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.height.mas_equalTo(100);
        }];
        
        UIView *theInputView = [[UIView alloc]init];
        theInputView.backgroundColor = [UIColor sl_colorWithHex:0xf4f4f4];
        theInputView.layer.cornerRadius = 17.5;
        theInputView.layer.masksToBounds = YES;
        [_topView addSubview:theInputView];
        [theInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
        }];
        
        self.growingTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(16,0, __kWidth-30, 38)];
        self.growingTextView.contentInset = UIEdgeInsetsMake(5,5,5,5);
        self.growingTextView.minHeight = 38;
        self.growingTextView.delegate = self;
        self.growingTextView.textColor = WhiteBgTitleColor;
        self.growingTextView.font = CFont(14);
        self.growingTextView.minNumberOfLines = 1;
        self.growingTextView.maxNumberOfLines = 10;
        self.growingTextView.animateHeightChange = YES;
        self.growingTextView.placeholder = @"说点什么...";
        self.growingTextView.placeholderColor = [UIColor sl_colorWithHex:0xB0B0B0];
        self.growingTextView.returnKeyType = UIReturnKeySend;
        self.growingTextView.enablesReturnKeyAutomatically = YES;
        self.growingTextView.backgroundColor =  [UIColor sl_colorWithHex:0xF4F8F8];
        [theInputView addSubview:self.growingTextView];
        [self.growingTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
            make.height.mas_equalTo(35);
        }];
        
        _sendBtn = [[UIButton alloc]init];
        [_sendBtn setTitle:@"发送" forState:BtnNormal];
        _sendBtn.titleLabel.font = CFont(15);
        _sendBtn.backgroundColor = sl_subBGColors;
        [_sendBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
        _sendBtn.layer.cornerRadius = 13;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.selected = YES;
        _sendBtn.tag = 0;
        [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:BtnTouchUpInside];
        [_topView addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(theInputView);
            make.height.mas_equalTo(26);
            make.top.mas_equalTo(theInputView.mas_bottom).offset(9);
            make.width.mas_equalTo(52);
            make.bottom.mas_equalTo(-9);
        }];
        
        _emojiBtn = [[UIButton alloc]init];
        [_emojiBtn setBackgroundImage:CImage(@"icon_comment_emioj") forState:BtnNormal];
        [_emojiBtn setBackgroundImage:CImage(@"icon_comment_emioj_sel") forState:BtnSelected];
        [_emojiBtn addTarget:self action:@selector(sendAction:) forControlEvents:BtnTouchUpInside];
        _emojiBtn.tag = 1;
        [_topView addSubview:_emojiBtn];
        [_emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(34);
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.sendBtn);
        }];
        
        _atBtn = [[UIButton alloc]init];
        [_atBtn setBackgroundImage:CImage(@"icon_comment_at") forState:BtnNormal];
        [_atBtn setBackgroundImage:CImage(@"icon_comment_at") forState:BtnSelected];
        [_atBtn addTarget:self action:@selector(sendAction:) forControlEvents:BtnTouchUpInside];
        _atBtn.tag = 2;
        [_topView addSubview:_atBtn];
        [_atBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(34);
            make.left.mas_equalTo(self.emojiBtn.mas_right).offset(15);
            make.centerY.mas_equalTo(self.sendBtn);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [_growingTextView becomeFirstResponder];
        

        if (array && array.count) {
            
            [self.growingTextView.internalTextView unmarkText];
            NSInteger index = self.growingTextView.text.length;
            if (self.growingTextView.isFirstResponder)
            {
                index = self.growingTextView.selectedRange.location + self.growingTextView.selectedRange.length;
                [self.growingTextView resignFirstResponder];
            }
            for (int i =0; i<array.count; i++) {
                NSDictionary *dict = array[i];
                NSString *text = dict[@"user_name"];
                [self.AtArray  addObject:dict];
                UITextView *textView = self.growingTextView.internalTextView;
                NSString *insertString = text;
                NSMutableString *string = [NSMutableString stringWithString:textView.text];
                [string insertString:insertString atIndex:index];
                self.growingTextView.text = string;
                [self.growingTextView becomeFirstResponder];
                textView.selectedRange = NSMakeRange(index + insertString.length, 0);
            }
            
        }
        [self layoutIfNeeded];
        [self layoutSubviews];
        
        self.isEmoji = NO;
    }
    return self;
}

- (void)tapAction {
    [self removeAction];
}

- (void)removeAction {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
}

- (void)addEmojiView {
    WS(ws);
    _emojiView = [[BXHHEmojiView alloc]initWithFrame:_bottomView.bounds];
    _emojiView.didGetEmoji = ^(BXHHEmoji *emoji) {
        NSString *tempText = ws.growingTextView.text;
        tempText = [tempText stringByAppendingString:emoji.desc];
        ws.growingTextView.text = tempText;
        [ws growingTextViewDidChange:ws.growingTextView];
        [ws.growingTextView scrollRangeToVisible:NSMakeRange(ws.growingTextView.text.length, 1)];
        ws.isEmoji = NO;
    };
    _emojiView.delEmoji = ^{
        [ws deleteText];
        
    };
    [_bottomView addSubview:_emojiView];
    [_emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
}
- (void)deleteText {
    NSString *text = _growingTextView.text;
    if (text && text.length) {
        NSString *lastStr = [text substringFromIndex:text.length - 1];
        if (IsEquallString(lastStr, @"]") && text.length > 2) {
            NSInteger index = - 1;
            for (NSInteger i = text.length - 1; i >= 0; i--) {
                NSString *str = [text substringWithRange:NSMakeRange(i, 1)];
                if (IsEquallString(str, @"[")) {
                    index = i;
                    break;
                }
            }
            if (index >= 0) {
                _growingTextView.text = [text substringToIndex:index];
            } else {
                _growingTextView.text = [text substringToIndex:text.length - 1];
            }
        } else {
            if ([[text substringFromIndex:text.length-1] isEqualToString:@" "]) {
                // 判断删除的是一个@中间的字符就整体删除
                NSMutableString *string = [NSMutableString stringWithString:text];
                NSArray *matches = [self atAll];
                if (matches.count) {
                    NSTextCheckingResult *result = [matches lastObject];
                    if (result.range.location + result.range.length == text.length) {
                        NSString *subText = [string substringWithRange:result.range];
                        BOOL isHave = NO;
                        for (int i=0; i<self.AtArray.count; i++) {
                            NSDictionary *dict = self.AtArray[i];
                            if (IsEquallString(dict[@"user_name"], subText)) {
                                [self.AtArray removeObjectAtIndex:i];
                                isHave = YES;
                                break;
                            }
                        }
                        if (isHave) {
                            [string replaceCharactersInRange:result.range withString:@""];
                            _growingTextView.text = string;
                        } else {
                            _growingTextView.text = [text substringToIndex:text.length - 1];
                        }
                    } else {
                        _growingTextView.text = [text substringToIndex:text.length - 1];
                    }
                    
                } else {
                    _growingTextView.text = [text substringToIndex:text.length - 1];
                }
            } else {
                _growingTextView.text = [text substringToIndex:text.length - 1];
            }
        }
        
    }
}
- (void)setReplyName:(NSString *)replyName {
    _replyName = replyName;
    NSString *placeholder = @"说点什么...";
    if (!IsNilString(replyName)) {
        placeholder = [NSString stringWithFormat:@"回复：%@",replyName];
        _growingTextView.placeholder = placeholder;
    }
    
}


- (void)sendAction:(UIButton *)sender {
    if (!sender.tag) {
        if (_growingTextView.text && _growingTextView.text.length) {
            if (_sendComment) {
                _sendComment(_growingTextView.text,[self jsonString:self.AtArray]);
            }
            [self removeAction];
        } else {
            [BGProgressHUD showInfoWithMessage:@"请输入内容"];
        }
    } else {
        [self endEditing:YES];
        sender.selected = YES;
        if (sender.tag == 1) {
            
            if (!_emojiView) {
                [self addEmojiView];
            } else {
                [_emojiView reloadView];
            }
        } else {
            //@界面
            WS(weakSelf);
            BXDynAiTeCategoryVC *vc = [[BXDynAiTeCategoryVC alloc]init];
            vc.friendArray = self.AtArray;
            vc.selectFriendArray = ^(NSMutableArray * _Nonnull array) {
                if (array.count) {
                    [weakSelf.growingTextView.internalTextView unmarkText];
                    NSInteger index = weakSelf.growingTextView.text.length;
                    if (weakSelf.growingTextView.isFirstResponder)
                    {
                        index = weakSelf.growingTextView.selectedRange.location + weakSelf.growingTextView.selectedRange.length;
                        [weakSelf.growingTextView resignFirstResponder];
                    }
                    for (int i =0; i<array.count; i++) {
                        NSDictionary *dict = array[i];
                        NSString *text = dict[@"user_name"];
                        [weakSelf.AtArray addObject:dict];
                        UITextView *textView = self.growingTextView.internalTextView;
                        NSString *insertString = text;
                        NSMutableString *string = [NSMutableString stringWithString:textView.text];
                        [string insertString:insertString atIndex:index];
                        weakSelf.growingTextView.text = string;
                        [weakSelf.growingTextView becomeFirstResponder];
                        textView.selectedRange = NSMakeRange(index + insertString.length, 0);
                    }
                    
                }
            };
            
//            BXAiteFriendVC *afvc = [[BXAiteFriendVC alloc] init];
//            afvc.friendArray = self.AtArray;
//            afvc.selectTextArray = ^(NSMutableArray * _Nonnull array) {
//                if (array.count) {
//                    [weakSelf.growingTextView.internalTextView unmarkText];
//                    NSInteger index = weakSelf.growingTextView.text.length;
//                    if (weakSelf.growingTextView.isFirstResponder)
//                    {
//                        index = weakSelf.growingTextView.selectedRange.location + weakSelf.growingTextView.selectedRange.length;
//                        [weakSelf.growingTextView resignFirstResponder];
//                    }
//                    for (int i =0; i<array.count; i++) {
//                        NSDictionary *dict = array[i];
//                        NSString *text = dict[@"name"];
//                        [weakSelf.AtArray addObject:dict];
//                        UITextView *textView = self.growingTextView.internalTextView;
//                        NSString *insertString = text;
//                        NSMutableString *string = [NSMutableString stringWithString:textView.text];
//                        [string insertString:insertString atIndex:index];
//                        weakSelf.growingTextView.text = string;
//                        [weakSelf.growingTextView becomeFirstResponder];
//                        textView.selectedRange = NSMakeRange(index + insertString.length, 0);
//                    }
//
//                }
//            };
            [[[UIApplication sharedApplication] activityViewController] presentViewController:vc animated:YES completion:nil];
            return;
        }
        _emojiView.hidden = !_emojiBtn.selected;
        
    }
}
- (void)show:(NSInteger)type{
    [_growingTextView becomeFirstResponder];
    if (type) {
        [self sendAction:_emojiBtn];
    }
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];

}
-(void)layoutSubviews{
    [super layoutSubviews];
}
#pragma - mark NSNotification
- (void)keyboardWillHide:(NSNotification *)noti {
    [self sendAction:_emojiBtn];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}
- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo=noti.userInfo;
    NSValue *keyBoardEndBounds=userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    CGFloat keyboardhight=endRect.size.height;
    CGFloat duration=[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve =[userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    [UIView setAnimationCurve:animationCurve];
    if (!_bottomView.height) {
        if (!keyboardhight) {
            return;
        }
        if (keyboardhight > _maxHeight) {
            _maxHeight = keyboardhight;
        }
        [UIView animateWithDuration:duration animations:^{
            self.contentView.transform = CGAffineTransformMakeTranslation(0, -keyboardhight);
        } completion:^(BOOL finished) {
            if (keyboardhight == self.maxHeight) {
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(keyboardhight);
                }];
                self.contentView.transform = CGAffineTransformIdentity;
                
            }
        }];
    } else {
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(keyboardhight);
        }];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:duration animations:^{
            [self layoutIfNeeded];
            [self layoutSubviews];
        }];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma - mark UITextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    if (height < 35) {
        height = 35;
    } else if (height > 120) {
        height = 120;
    }

    [_growingTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self layoutIfNeeded];
        [self layoutSubviews];
    });

}
-(void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self.growingTextView resignFirstResponder];
    return YES;
}
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        _sendBtn.backgroundColor = DynSendButtonBackColor;
        [_sendBtn setTitleColor:DynSendButtonTitle forState:UIControlStateNormal];
    }
    else{
        _sendBtn.backgroundColor = sl_subBGColors;
        [_sendBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
    }
    
    if ([text isEqualToString:@""])
    {
        //删除表情
        if(_growingTextView.text&&_growingTextView.text.length) {
            NSString *lastStr = [_growingTextView.text substringFromIndex:_growingTextView.text.length-1];
            if (IsEquallString(lastStr, @"]") && _growingTextView.text.length > 2) {
                NSInteger index = - 1;
                for (NSInteger i = _growingTextView.text.length - 1; i >= 0; i--) {
                    NSString *str = [_growingTextView.text substringWithRange:NSMakeRange(i, 1)];
                    if (IsEquallString(str, @"[")) {
                        index = i;
                        break;
                    }
                }
                if (index >= 0) {
                    _growingTextView.text = [_growingTextView.text substringToIndex:index];
                } else {
                    _growingTextView.text = [_growingTextView.text substringToIndex:_growingTextView.text.length-1];
                }
                return NO;
            }
            
        }

        //删除@
        NSRange selectRange = growingTextView.selectedRange;
        if (selectRange.length > 0)
        {
            //用户长按选择文本时不处理
            return YES;
        }
        
        // 判断删除的是一个@中间的字符就整体删除
        NSMutableString *string = [NSMutableString stringWithString:growingTextView.text];
        NSArray *matches = [self atAll];
        
        BOOL inAt = NO;
        NSInteger index = range.location;
        for (NSTextCheckingResult *match in matches)
        {
            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
            if (NSLocationInRange(range.location, newRange))
            {
                
                for (int i=0; i<self.AtArray.count; i++) {
                    NSDictionary *dict = self.AtArray[i];
                    if (IsEquallString(dict[@"user_name"], [string substringWithRange:match.range])) {
                        [self.AtArray removeObjectAtIndex:i];
                        break;
                    }
                }
                inAt = YES;
                index = match.range.location;
                [string replaceCharactersInRange:match.range withString:@""];
                break;
            }
        }
        
        if (inAt)
        {
            growingTextView.text = string;
            growingTextView.selectedRange = NSMakeRange(index, 0);
            return NO;
        }
    }
    
    //判断是回车键就发送出去
    if ([text isEqualToString:@"\n"])
    {
        [self endEditing:YES];
        if (growingTextView.text && growingTextView.text.length) {
            if (_sendComment) {
                _sendComment(growingTextView.text,[self jsonString:self.AtArray]);
            }
            [self removeAction];
        }
        return NO;
    }
    
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (![growingTextView.text isEqualToString:@""]) {

        _sendBtn.backgroundColor = DynSendButtonBackColor;
        [_sendBtn setTitleColor:DynSendButtonTitle forState:UIControlStateNormal];
    }
    else{
        _sendBtn.backgroundColor = sl_subBGColors;
        [_sendBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
    }
    UITextRange *selectedRange = growingTextView.internalTextView.markedTextRange;
    NSString *newText = [growingTextView.internalTextView textInRange:selectedRange];
    if (newText.length < 1)
    {
        // 高亮输入框中的@
        UITextView *textView = self.growingTextView.internalTextView;
        NSRange range = textView.selectedRange;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
        [string addAttribute:NSForegroundColorAttributeName value:WhiteBgTitleColor range:NSMakeRange(0, string.string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, string.string.length)];
        NSArray *matches = [self atAll];
        
        for (NSTextCheckingResult *match in matches)
        {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor sl_colorWithHex:0x00D3C7] range:NSMakeRange(match.range.location, match.range.length-1)];
        }
        
        textView.attributedText = string;
        textView.selectedRange = range;
    }
    if (growingTextView.text.length<=0) {
        growingTextView.textColor = WhiteBgTitleColor;
    }
    
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView
{
    // 光标不能点落在@词中间
    NSRange range = growingTextView.selectedRange;
    if (range.length > 0)
    {
        // 选择文本时可以
        return;
    }
    NSArray *matches = [self atAll];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
        if (NSLocationInRange(range.location, newRange))
        {
            growingTextView.internalTextView.selectedRange = NSMakeRange(match.range.location + match.range.length, 0);
            break;
        }
    }
    
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{

}

- (NSArray<NSTextCheckingResult *> *)atAll
{
    // 找到文本中所有的@
    NSString *string = self.growingTextView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(.*?)+ "  options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}
-(NSString *)jsonString:(NSArray *)dataArr{
    NSString *attring= [NSString string];
    if (dataArr.count>0) {
        NSMutableArray *atarr = [NSMutableArray array];
        for ( int i =0; i<dataArr.count; i++)
        {
            NSDictionary *dict = [dataArr objectAtIndex:i];
            [atarr addObject:dict[@"user_id"]];
            attring = [atarr componentsJoinedByString:@","];
        }
    }else{
        attring = @"";
    }
    return attring;
}

@end



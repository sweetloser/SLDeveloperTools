//
//  BXIssueDynCommentView.m
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXIssueDynCommentView.h"
#import "BXHHEmojiView.h"
#import "HPGrowingTextView.h"
#import "BXAiteFriendVC.h"
#import "BXGradientButton.h"
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"

@interface BXIssueDynCommentView ()<HPGrowingTextViewDelegate>
@property (strong, nonatomic) NSMutableArray *AtArray;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic,strong) HPGrowingTextView *growingTextView;//文字
@property (strong, nonatomic) UIButton *emojiBtn;
@property (strong, nonatomic) UIButton *atBtn;
@property (strong, nonatomic) UIButton *sendBtn;
@property (strong, nonatomic) BXHHEmojiView *emojiView;
@property (assign, nonatomic) CGFloat maxHeight;
@property (assign, nonatomic) BOOL isEmoji;

@property (assign, nonatomic) CGRect initFrame;
@property (strong, nonatomic) UIImageView *MicrImageView;
@property (strong, nonatomic) UIImageView *PicImageView;
@property (strong, nonatomic) UIImageView *EmojiImageView;
@property (strong, nonatomic) UIImageView *AiTeImageView;
@property (strong, nonatomic) UIImageView *KeyWordImageView;

@property(nonatomic, strong)UIView *micrBackView;
@property(nonatomic, strong)UIImageView *micrAniImageView;
@property(nonatomic, strong)UILabel *micrAnilabel;

@property (strong, nonatomic) UIView *LuYinView;

@end

@implementation BXIssueDynCommentView


-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array IssueType:(NSInteger)issuetype{
    self = [super initWithFrame:frame];
    if (self) {
        self.AtArray = [NSMutableArray array];
        self.initFrame = frame;
        _MicrImageView = [[UIImageView alloc]init];
        _MicrImageView.tag = 0;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickBtn:)];
        [_MicrImageView addGestureRecognizer:tap1];
        _MicrImageView.userInteractionEnabled = YES;
        _MicrImageView.image = [UIImage imageNamed:@"dyn_issue_micr"];
        [self addSubview:_MicrImageView];
        [_MicrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(self.mas_top).offset(14);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(22);
        }];
        
        _PicImageView = [[UIImageView alloc]init];
        _PicImageView.tag = 1;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickBtn:)];
        [_PicImageView addGestureRecognizer:tap2];
        _PicImageView.image = [UIImage imageNamed:@"dyn_issue_pickPic"];
        _PicImageView.userInteractionEnabled = YES;
        [self addSubview:_PicImageView];
        [_PicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_MicrImageView.mas_right).offset(28);
            make.top.mas_equalTo(_MicrImageView);
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(22);
        }];
        
        _EmojiImageView = [[UIImageView alloc]init];
        _EmojiImageView.tag = 2;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickBtn:)];
        [_EmojiImageView addGestureRecognizer:tap3];
        _EmojiImageView.image = [UIImage imageNamed:@"dyn_issue_Emoji"];
        _EmojiImageView.userInteractionEnabled = YES;
        [self addSubview:_EmojiImageView];
        [_EmojiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_PicImageView.mas_right).offset(28);
            make.top.mas_equalTo(_MicrImageView);
            make.width.mas_equalTo(23);
            make.height.mas_equalTo(23);
        }];
        
        _AiTeImageView = [[UIImageView alloc]init];
        _AiTeImageView.image = [UIImage imageNamed:@"dyn_issue_AiTe"];
        _AiTeImageView.tag = 3;
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickBtn:)];
        [_AiTeImageView addGestureRecognizer:tap4];
        _AiTeImageView.userInteractionEnabled = YES;
        [self addSubview:_AiTeImageView];
        [_AiTeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_EmojiImageView.mas_right).offset(28);
            make.top.mas_equalTo(_MicrImageView);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(24);
        }];
        
        _KeyWordImageView = [[UIImageView alloc]init];
        _KeyWordImageView.image = [UIImage imageNamed:@"dyn_issue_KeyWord"];
        _KeyWordImageView.tag = 4;
        UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickBtn:)];
        [_KeyWordImageView addGestureRecognizer:tap5];
        _KeyWordImageView.userInteractionEnabled = YES;
        [self addSubview:_KeyWordImageView];
        [_KeyWordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_AiTeImageView.mas_right).offset(28);
            make.top.mas_equalTo(_MicrImageView);
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(21);
        }];
        
        _micrBackView = [[UIView alloc]init];
        [self addSubview:_micrBackView];
        [_micrBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(12);
            make.right.mas_equalTo(self.mas_right).offset(-12);
            make.top.mas_equalTo(_MicrImageView.mas_bottom).offset(10);
            make.bottom.mas_offset(-__kBottomAddHeight);
        }];
        _micrAniImageView = [[UIImageView alloc]init];
        _micrAniImageView.image = [UIImage imageNamed:@"dyn_issue_LuYin_will"];
        [_micrBackView addSubview:_micrAniImageView];
        [_micrAniImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY).offset(30);
            make.centerX.mas_equalTo(_micrBackView.mas_centerX);
            make.width.height.mas_equalTo(84);
        }];
        _micrAnilabel = [[UILabel alloc]init];
        _micrAnilabel.text = @"开始录音";
        _micrAnilabel.textAlignment = 1;
        _micrAnilabel.textColor = sl_textSubColors;
        _micrAnilabel.font = [UIFont systemFontOfSize:12];
        [_micrBackView addSubview:_micrAnilabel];
        [_micrAnilabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_micrAniImageView.mas_top).offset(-10);
            make.width.mas_equalTo(84);
            make.height.mas_equalTo(20);
        }];
        
        WS(ws);
        _emojiView = [[BXHHEmojiView alloc]initWithFrame:CGRectZero];
        _emojiView.didGetEmoji = ^(BXHHEmoji *emoji) {
//            NSString *tempText = ws.growingTextView.text;
//            tempText = [tempText stringByAppendingString:emoji.desc];
//            ws.growingTextView.text = tempText;
//            [ws growingTextViewDidChange:ws.growingTextView];
//            [ws.growingTextView scrollRangeToVisible:NSMakeRange(ws.growingTextView.text.length, 1)];
//            ws.isEmoji = NO;
            [ws.delegate sendEmojiMsg:emoji];
           

            
        };
        _emojiView.delEmoji = ^{
            [ws.delegate deleteEmojiMsg];
            
        };
//        _emojiView.backgroundColor = [UIColor grayColor];
        [self addSubview:_emojiView];
        [_emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(12);
            make.right.mas_equalTo(self.mas_right).offset(-12);
            make.top.mas_equalTo(_MicrImageView.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-__kBottomAddHeight);
        }];

        _emojiView.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        

        
        self.isEmoji = NO;
    }
    return self;
}
-(void)setTypeWithRecoder:(BOOL)recoder Picture:(BOOL)picture Emoji:(BOOL)emoji AiTe:(BOOL)Aite KeyWord:(BOOL)KeyWord{
    if (recoder) {
        _micrBackView.hidden = NO;
        _MicrImageView.userInteractionEnabled = YES;
        _MicrImageView.image = [UIImage imageNamed:@"dyn_issue_micr"];
    }else{
        _micrBackView.hidden = YES;
        _MicrImageView.userInteractionEnabled = NO;
        _MicrImageView.image = [UIImage imageNamed:@"dyn_issue_micr_un"];
    }
    
    if (picture) {
        _PicImageView.image = [UIImage imageNamed:@"dyn_issue_pickPic"];
        _PicImageView.userInteractionEnabled = YES;
    }else{
        _PicImageView.image = [UIImage imageNamed:@"dyn_issue_pickPic_un"];
        _PicImageView.userInteractionEnabled = NO;
    }
    
    if (emoji) {
        _EmojiImageView.image = [UIImage imageNamed:@"dyn_issue_Emoji"];
        _EmojiImageView.userInteractionEnabled = YES;
    }else{
        _EmojiImageView.image = [UIImage imageNamed:@"dyn_issue_Emoji_un"];
        _EmojiImageView.userInteractionEnabled = NO;
    }
    
    if (Aite) {
        
    }else{
        
    }
    
    if (KeyWord) {
        
    }else{
        
    }
}
-(void)ClickBtn:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger flag = [tap.view tag];
    if (flag == 0) {
        _micrBackView.hidden = NO;
        _emojiView.hidden = YES;
    }
    if (flag == 1) {
        
    }
    if (flag == 2) {
        _micrBackView.hidden = YES;
        _emojiView.hidden = NO;
        
    }
    if (flag == 3) {
        //@界面
        [self.delegate sendAiTeFriend];
//        ZZL(weakSelf);
//        BXAiteFriendVC *afvc = [[BXAiteFriendVC alloc] init];
//        afvc.friendArray = self.AtArray;
//        afvc.selectTextArray = ^(NSMutableArray * _Nonnull array) {
//            if (array.count) {
//                [weakSelf.growingTextView.internalTextView unmarkText];
//                NSInteger index = weakSelf.growingTextView.text.length;
//                if (weakSelf.growingTextView.isFirstResponder)
//                {
//                    index = weakSelf.growingTextView.selectedRange.location + weakSelf.growingTextView.selectedRange.length;
//                    [weakSelf.growingTextView resignFirstResponder];
//                }
//                for (int i =0; i<array.count; i++) {
//                    NSDictionary *dict = array[i];
//                    NSString *text = dict[@"name"];
//                    [weakSelf.AtArray addObject:dict];
//                    UITextView *textView = self.growingTextView.internalTextView;
//                    NSString *insertString = text;
//                    NSMutableString *string = [NSMutableString stringWithString:textView.text];
//                    [string insertString:insertString atIndex:index];
//                    weakSelf.growingTextView.text = string;
//                    [weakSelf.growingTextView becomeFirstResponder];
//                    textView.selectedRange = NSMakeRange(index + insertString.length, 0);
//                }
//
//            }
//        };
//        [[[UIApplication sharedApplication] activityViewController] presentViewController:afvc animated:YES completion:nil];
    }
    if (flag == 4) {
        
    }
    if (_sendtag) {
        self.sendtag(flag);
    }
  
}
//- (void)tapAction {
//    [self removeAction];
//}

- (void)removeAction {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
}

- (void)addEmojiView {
    WS(ws);
    _emojiView = [[BXHHEmojiView alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height - 50)];
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
    _emojiView.backgroundColor = [UIColor grayColor];
    [self addSubview:_emojiView];
//    [_emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.mas_bottom);
//        make.left.mas_equalTo(self.mas_left);
//        make.right.mas_equalTo(self.mas_right);
//        make.top.mas_equalTo(self.mas_top).offset(50);
//    }];
    
}
- (void)deleteText {
//    NSString *text = _growingTextView.text;
//    if (text && text.length) {
//        NSString *lastStr = [text substringFromIndex:text.length - 1];
//        if (IsEquallString(lastStr, @"]") && text.length > 2) {
//            NSInteger index = - 1;
//            for (NSInteger i = text.length - 1; i >= 0; i--) {
//                NSString *str = [text substringWithRange:NSMakeRange(i, 1)];
//                if (IsEquallString(str, @"[")) {
//                    index = i;
//                    break;
//                }
//            }
//            if (index >= 0) {
//                _growingTextView.text = [text substringToIndex:index];
//            } else {
//                _growingTextView.text = [text substringToIndex:text.length - 1];
//            }
//        } else {
//            if ([[text substringFromIndex:text.length-1] isEqualToString:@" "]) {
//                // 判断删除的是一个@中间的字符就整体删除
//                NSMutableString *string = [NSMutableString stringWithString:text];
//                NSArray *matches = [self atAll];
//                if (matches.count) {
//                    NSTextCheckingResult *result = [matches lastObject];
//                    if (result.range.location + result.range.length == text.length) {
//                        NSString *subText = [string substringWithRange:result.range];
//                        BOOL isHave = NO;
//                        for (int i=0; i<self.AtArray.count; i++) {
//                            NSDictionary *dict = self.AtArray[i];
//                            if (IsEquallString(dict[@"name"], subText)) {
//                                [self.AtArray removeObjectAtIndex:i];
//                                isHave = YES;
//                                break;
//                            }
//                        }
//                        if (isHave) {
//                            [string replaceCharactersInRange:result.range withString:@""];
//                            _growingTextView.text = string;
//                        } else {
//                            _growingTextView.text = [text substringToIndex:text.length - 1];
//                        }
//                    } else {
//                        _growingTextView.text = [text substringToIndex:text.length - 1];
//                    }
//                    
//                } else {
//                    _growingTextView.text = [text substringToIndex:text.length - 1];
//                }
//            } else {
//                _growingTextView.text = [text substringToIndex:text.length - 1];
//            }
//        }
//        
//    }
}
- (void)setReplyName:(NSString *)replyName {
    _replyName = replyName;
    NSString *placeholder = @"说点什么...";
    if (!IsNilString(replyName)) {
        placeholder = [NSString stringWithFormat:@"回复：%@",replyName];
        _growingTextView.placeholder = placeholder;
    }
    
}


//- (void)sendAction:(UIButton *)sender {
//    if (!sender.tag) {
//        if (_growingTextView.text && _growingTextView.text.length) {
//            if (_sendComment) {
//                _sendComment(_growingTextView.text,[self jsonString:self.AtArray]);
//            }
//            [self removeAction];
//        } else {
//            [BGProgressHUD showInfoWithMessage:@"请输入内容"];
//        }
//    } else {
//        [self endEditing:YES];
//        sender.selected = YES;
//        if (sender.tag == 1) {
//
//            if (!_emojiView) {
//                [self addEmojiView];
//            } else {
//                [_emojiView reloadView];
//            }
//        } else {
//            //@界面
//            ZZL(weakSelf);
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
//            [[[UIApplication sharedApplication] activityViewController] presentViewController:afvc animated:YES completion:nil];
//            return;
//        }
//        _emojiView.hidden = !_emojiBtn.selected;
//
//    }
//}
//- (void)show:(NSInteger)type{
//    [_growingTextView becomeFirstResponder];
//    if (type) {
//        [self sendAction:_emojiBtn];
//    }
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(0);
//    }];
//
//}
-(void)layoutSubviews{
    [super layoutSubviews];
}
#pragma - mark NSNotification
- (void)keyboardWillHide:(NSNotification *)noti {
//    [self sendAction:_emojiBtn];
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(0);
//    }];
    self.frame = CGRectMake(0, __kHeight - 270, __kWidth, 270);
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
                CGRect frame = self.frame;
                frame.origin.y = __kHeight -  keyboardhight - 50;
                self.frame = frame;
                
            }
        }];
    } else {
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(keyboardhight);
        }];
        CGRect frame = self.frame;
        frame.origin.y = __kHeight -  keyboardhight - 50;
        self.frame = frame;
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
//-(BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
//    return YES;
//}
//- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
//    if (height < 35) {
//        height = 35;
//    } else if (height > 120) {
//        height = 120;
//    }
//
//    [_growingTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self layoutIfNeeded];
//        [self layoutSubviews];
//    });
//
//}
//-(void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
//}
//
//- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
//{
//    [self.growingTextView resignFirstResponder];
//    return YES;
//}
//- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@""])
//    {
//        //删除表情
//        if(_growingTextView.text&&_growingTextView.text.length) {
//            NSString *lastStr = [_growingTextView.text substringFromIndex:_growingTextView.text.length-1];
//            if (IsEquallString(lastStr, @"]") && _growingTextView.text.length > 2) {
//                NSInteger index = - 1;
//                for (NSInteger i = _growingTextView.text.length - 1; i >= 0; i--) {
//                    NSString *str = [_growingTextView.text substringWithRange:NSMakeRange(i, 1)];
//                    if (IsEquallString(str, @"[")) {
//                        index = i;
//                        break;
//                    }
//                }
//                if (index >= 0) {
//                    _growingTextView.text = [_growingTextView.text substringToIndex:index];
//                } else {
//                    _growingTextView.text = [_growingTextView.text substringToIndex:_growingTextView.text.length-1];
//                }
//                return NO;
//            }
//            
//        }
//
//        //删除@
//        NSRange selectRange = growingTextView.selectedRange;
//        if (selectRange.length > 0)
//        {
//            //用户长按选择文本时不处理
//            return YES;
//        }
//        
//        // 判断删除的是一个@中间的字符就整体删除
//        NSMutableString *string = [NSMutableString stringWithString:growingTextView.text];
//        NSArray *matches = [self atAll];
//        
//        BOOL inAt = NO;
//        NSInteger index = range.location;
//        for (NSTextCheckingResult *match in matches)
//        {
//            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
//            if (NSLocationInRange(range.location, newRange))
//            {
//                
//                for (int i=0; i<self.AtArray.count; i++) {
//                    NSDictionary *dict = self.AtArray[i];
//                    if (IsEquallString(dict[@"name"], [string substringWithRange:match.range])) {
//                        [self.AtArray removeObjectAtIndex:i];
//                        break;
//                    }
//                }
//                inAt = YES;
//                index = match.range.location;
//                [string replaceCharactersInRange:match.range withString:@""];
//                break;
//            }
//        }
//        
//        if (inAt)
//        {
//            growingTextView.text = string;
//            growingTextView.selectedRange = NSMakeRange(index, 0);
//            return NO;
//        }
//    }
//    
//    //判断是回车键就发送出去
//    if ([text isEqualToString:@"\n"])
//    {
//        [self endEditing:YES];
//        if (growingTextView.text && growingTextView.text.length) {
//            if (_sendComment) {
//                _sendComment(growingTextView.text,[self jsonString:self.AtArray]);
//            }
//            [self removeAction];
//        }
//        return NO;
//    }
//    
//    return YES;
//}
//
//- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
//{
//    _sendBtn.selected = !growingTextView.text.length;
//    UITextRange *selectedRange = growingTextView.internalTextView.markedTextRange;
//    NSString *newText = [growingTextView.internalTextView textInRange:selectedRange];
//    if (newText.length < 1)
//    {
//        // 高亮输入框中的@
//        UITextView *textView = self.growingTextView.internalTextView;
//        NSRange range = textView.selectedRange;
//        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
//        [string addAttribute:NSForegroundColorAttributeName value:WhiteBgTitleColor range:NSMakeRange(0, string.string.length)];
//        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, string.string.length)];
//        NSArray *matches = [self atAll];
//        
//        for (NSTextCheckingResult *match in matches)
//        {
//            [string addAttribute:NSForegroundColorAttributeName value:UIColorHex(00D3C7) range:NSMakeRange(match.range.location, match.range.length-1)];
//        }
//        
//        textView.attributedText = string;
//        textView.selectedRange = range;
//    }
//    if (growingTextView.text.length<=0) {
//        growingTextView.textColor = WhiteBgTitleColor;
//    }
//    
//}
//
//- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView
//{
//    // 光标不能点落在@词中间
//    NSRange range = growingTextView.selectedRange;
//    if (range.length > 0)
//    {
//        // 选择文本时可以
//        return;
//    }
//    NSArray *matches = [self atAll];
//    for (NSTextCheckingResult *match in matches)
//    {
//        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
//        if (NSLocationInRange(range.location, newRange))
//        {
//            growingTextView.internalTextView.selectedRange = NSMakeRange(match.range.location + match.range.length, 0);
//            break;
//        }
//    }
//    
//}
//
//- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{
//
//}

//- (NSArray<NSTextCheckingResult *> *)atAll
//{
//    // 找到文本中所有的@
//    NSString *string = self.growingTextView.text;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(.*?)+ "  options:NSRegularExpressionCaseInsensitive error:nil];
//    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
//    return matches;
//}
//-(NSString *)jsonString:(NSArray *)dataArr{
//    NSString *attring= [NSString string];
//    if (dataArr.count>0) {
//        NSMutableArray *atarr = [NSMutableArray array];
//        for ( int i =0; i<dataArr.count; i++)
//        {
//            NSDictionary *dict = [dataArr objectAtIndex:i];
//            [atarr addObject:dict[@"id"]];
//            attring = [atarr componentsJoinedByString:@","];
//        }
//    }else{
//        attring = @"";
//    }
//    return attring;
//}

@end


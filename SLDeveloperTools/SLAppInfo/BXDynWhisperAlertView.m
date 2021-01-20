//
//  BXDynWhisperAlertView.m
//  BXlive
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynWhisperAlertView.h"
#import "HPGrowingTextView.h"
#import "HttpMakeFriendRequest.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoMacro.h"
#import <Masonry/Masonry.h>
#import <NIMKit/NIMKit.h>
#import <SDWebImage/SDWebImage.h>
#import <YYCategories/YYCategories.h>
@interface BXDynWhisperAlertView()<HPGrowingTextViewDelegate>

@property(nonatomic,strong)UIView *contentView;
@property (nonatomic,strong) HPGrowingTextView *growingTextView;;//文字
@property (strong, nonatomic) NSMutableArray *AtArray;
@property(nonatomic ,strong)NSString *user_id;
@property(nonatomic, strong)UIButton *sendBtn;
@end
@implementation BXDynWhisperAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame model:(nonnull BXDynamicModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor sl_colorWithHex:0x000000 alpha:0.3];
        self.model = model;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        self.contentView = [UIView new];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_centerY).offset(-100);
            make.height.mas_equalTo(257);
            make.left.offset(__ScaleWidth(27));
        }];
        self.contentView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
        
        _contentView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _contentView.alpha = 0;
        [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self->_contentView.alpha = 1.0;
        } completion:nil];
        
        
        UIImageView *headerimageView = [[UIImageView alloc]init];

        [headerimageView sd_setImageWithURL:[NSURL URLWithString:model.msgdetailmodel.avatar] placeholderImage:CImage(@"placeplaceholder")];
        headerimageView.layer.cornerRadius = __ScaleWidth(19);
        headerimageView.layer.masksToBounds = YES;
        [self.contentView addSubview:headerimageView];
        [headerimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.width.height.mas_equalTo(__ScaleWidth(38));
        }];
        
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.text = model.msgdetailmodel.nickname;
        titleLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        titleLable.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLable];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headerimageView.mas_right).offset(10);
            make.top.mas_equalTo(headerimageView.mas_top);
            make.width.mas_equalTo([UILabel getWidthWithTitle:titleLable.text font:titleLable.font]);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.text = [NSString stringWithFormat:@"%@",model.msgdetailmodel.difftime] ;
        timeLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        timeLable.textColor = UIColorHex(#B2B2B2);
        [self.contentView addSubview:timeLable];
        [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLable.mas_left);
            make.top.mas_equalTo(titleLable.mas_bottom);
            make.width.mas_equalTo([UILabel getWidthWithTitle:timeLable.text font:timeLable.font]);
            make.height.mas_equalTo(18);
        }];
        
        UIView *backview = [[UIView alloc]init];
        backview.backgroundColor = UIColorHex(#F5F9FC);
        backview.layer.cornerRadius = 5;
        backview.layer.masksToBounds = YES;
        [self.contentView addSubview:backview];
        [backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(__ScaleWidth(20));
            make.top.mas_equalTo(headerimageView.mas_bottom).offset(20);
            make.right.mas_equalTo(self.contentView.mas_right).offset(__ScaleWidth(-20));
            make.height.mas_equalTo(70);
        }];
        
        UIImageView *concentImageView = [UIImageView new];
        concentImageView.layer.cornerRadius = 5;
        concentImageView.layer.masksToBounds = YES;
        [backview addSubview:concentImageView];
        [concentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backview.mas_left).offset(__ScaleWidth(12));
            make.top.mas_equalTo(backview.mas_top).offset(12);
            make.width.height.mas_equalTo(__ScaleWidth(46));
        }];

        
        UILabel *concentLable = [[UILabel alloc]init];
        concentLable.text = model.msgdetailmodel.content;
        concentLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        concentLable.textColor = [UIColor blackColor];
        [backview addSubview:concentLable];
        [concentLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(concentImageView.mas_right).offset(10);
            make.top.mas_equalTo(backview.mas_top).offset(15);
            make.right.mas_equalTo(backview.mas_right).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *concentTimeLable = [[UILabel alloc]init];
        concentTimeLable.text = [NSString stringWithFormat:@"%@",  model.msgdetailmodel.create_time];
        concentTimeLable.textColor = UIColorHex(#B2B2B2);
        concentTimeLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [backview addSubview:concentTimeLable];
        [concentTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(concentImageView.mas_right).offset(10);
            make.top.mas_equalTo(concentLable.mas_bottom);
            make.right.mas_equalTo(backview.mas_right).offset(-10);
            make.height.mas_equalTo(19);
        }];
        
        if (self.model.msgdetailmodel.smallpicture && [self.model.msgdetailmodel.smallpicture isArray] && self.model.msgdetailmodel.smallpicture.count) {
            NSString *picstr = [NSString stringWithFormat:@"%@",self.model.msgdetailmodel.smallpicture[0]];
            [concentImageView sd_setImageWithURL:[NSURL URLWithString:picstr] placeholderImage:CImage(@"video-placeholder")];
        }else{
            concentImageView.hidden = YES;
            [concentLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(backview.mas_left).offset(__ScaleWidth(12));
                make.top.mas_equalTo(backview.mas_top).offset(15);
                make.right.mas_equalTo(backview.mas_right).offset(-10);
                make.height.mas_equalTo(20);
            }];
            [concentTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(backview.mas_left).offset(__ScaleWidth(12));
                make.top.mas_equalTo(concentLable.mas_bottom);
                make.right.mas_equalTo(backview.mas_right).offset(-10);
                make.height.mas_equalTo(19);
            }];
        }
     
        self.growingTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(16,0, SCREEN_WIDTH-30, 38)];
        self.growingTextView.contentInset = UIEdgeInsetsMake(5,5,5,5);
        self.growingTextView.minHeight = 38;
        self.growingTextView.delegate = self;
        self.growingTextView.textColor = WhiteBgTitleColor;
        self.growingTextView.font = CFont(14);
        self.growingTextView.minNumberOfLines = 1;
        self.growingTextView.maxNumberOfLines = 10;
        self.growingTextView.animateHeightChange = YES;
        self.growingTextView.placeholder = @"发送不礼貌的消息会被禁言哦";
        self.growingTextView.placeholderColor = UIColorHex(B0B0B0);
        self.growingTextView.returnKeyType = UIReturnKeySend;
        self.growingTextView.enablesReturnKeyAutomatically = YES;
//        self.growingTextView.backgroundColor =  UIColorHex(F4F8F8);
        [self.contentView addSubview:self.growingTextView];
        [self.growingTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-60);
            make.height.mas_equalTo(35);
        }];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:UIColorHex(#8C8C8C) forState:UIControlStateNormal];
        _sendBtn.backgroundColor = DynDownLineColor;
        _sendBtn.layer.cornerRadius = 17;
        _sendBtn.layer.masksToBounds = YES;
        [_sendBtn addTarget:self action:@selector(sendAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(34);
        }];
        
        [_growingTextView becomeFirstResponder];
    }
    return self;
}
-(void)sendAct:(UIButton *)btn{
    if ([_growingTextView.text isEqualToString:@""]) {
        [BGProgressHUD showInfoWithMessage:@"内容不能为空"];
        return;
    }else{
        if (_sendComment) {
            _sendComment(_growingTextView.text,[self jsonString:self.AtArray]);
        }
        [self hiddenView];
    }
    // 构造出具体会话：P2P单聊，对方账号为user
    NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.user_id]  type:NIMSessionTypeP2P];
    // 构造出具体消息
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text        = self.growingTextView.text;
    // 错误反馈对象
    NSError *error = nil;
    // 发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
    
    [HttpMakeFriendRequest SendMsgWithto_uid:self.model.msgdetailmodel.user_id messages:self.growingTextView.text imgs:@"" video:@"" messages_type:@"1" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];

    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"发送失败"];
    }];
   
}
-(void)tap:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, point)) {
        NSLog(@"范围内");
        return;
    }
    [self hiddenView];
}
#pragma - mark UITextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
//    if (height < 35) {
//        height = 35;
//    } else if (height > 100) {
//        height = 100;
//    }
//
//    [_growingTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self layoutIfNeeded];
//        [self layoutSubviews];
//    });

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
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = UIColorHex(#FF2D52);
    }
    else{
        [_sendBtn setTitleColor:UIColorHex(#8C8C8C) forState:UIControlStateNormal];
        _sendBtn.backgroundColor = DynDownLineColor;
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
                    if (IsEquallString(dict[@"name"], [string substringWithRange:match.range])) {
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
            [self sendAct:_sendBtn];
            [self hiddenView];
        }
        return NO;
    }
    
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (![growingTextView.text isEqualToString:@""]) {
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = UIColorHex(#FF2D52);
    }
    else{
        [_sendBtn setTitleColor:UIColorHex(#8C8C8C) forState:UIControlStateNormal];
        _sendBtn.backgroundColor = DynDownLineColor;
    }
//    _sendBtn.selected = !growingTextView.text.length;
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
            [string addAttribute:NSForegroundColorAttributeName value:UIColorHex(00D3C7) range:NSMakeRange(match.range.location, match.range.length-1)];
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
            [atarr addObject:dict[@"id"]];
            attring = [atarr componentsJoinedByString:@","];
        }
    }else{
        attring = @"";
    }
    return attring;
}

-(void)btnOnClick:(UIButton *)btn{

    [self hiddenView];
}

-(void)showWithView:(UIView *)superView{
    self.hidden = NO;
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
}

-(void)hiddenView{
    self.hidden = YES;
    [self.contentView removeAllSubViews];
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    [self removeFromSuperview];
}
@end

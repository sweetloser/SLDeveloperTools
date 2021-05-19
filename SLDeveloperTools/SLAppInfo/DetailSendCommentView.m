//
//  DetailCommentView.m
//  BXlive
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailSendCommentView.h"
#import "BXHHEmojiView.h"
#import "HPGrowingTextView.h"
#import "BXAiteFriendVC.h"
#import "BXGradientButton.h"
#import <HXPhotoPicker/HXPhotoPicker.h>
#import "FilePathHelper.h"
#import "DetailSendcomCollectionViewCell.h"
#import "HttpMakeFriendRequest.h"
//#import <UIView+HXExtension.h>
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoMacro.h"
#import "../SLCategory/SLCategory.h"
#import "SLUpLoadAndDownloadTools.h"

@interface DetailSendCommentView ()<HPGrowingTextViewDelegate,HXCustomNavigationControllerDelegate,HXCustomCameraViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray *AtArray;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic,strong) HPGrowingTextView *growingTextView;;//文字
@property (strong, nonatomic) UIButton *emojiBtn;
@property (strong, nonatomic) UIButton *picBtn;
@property (strong, nonatomic) UIButton *sendBtn;
@property (strong, nonatomic) BXHHEmojiView *emojiView;
@property (assign, nonatomic) CGFloat maxHeight;
@property (assign, nonatomic) BOOL isEmoji;

//@property(nonatomic, strong)UIViewController *viewController;

@property (strong, nonatomic) HXPhotoManager *manager;
//@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *AddPicArray;
@property(nonatomic, strong)NSMutableArray *PicUrlArray;

@property(nonatomic, strong)NSString *contentid;
@property (copy, nonatomic) NSString *touid;
@property (assign, nonatomic) NSInteger picSelEnableNum;
@end

@implementation DetailSendCommentView


-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array model:(BXDynamicModel *)model contentid:(nonnull NSString *)contentid touid:(nonnull NSString *)touid{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.model = model;
        self.contentid = contentid;
        self.touid = touid;
        if ([NSString stringWithFormat:@"%@",model.msgdetailmodel.comment_img_limit]) {
            
            self.picSelEnableNum = [model.msgdetailmodel.comment_img_limit integerValue];
        }else{
            self.picSelEnableNum = 1;
        }
        self.AddPicArray = [NSMutableArray array];
        self.PicUrlArray = [NSMutableArray array];
        self.AtArray = [NSMutableArray array];
        UIView *maskView = [[UIView alloc]init];
        [self addSubview:maskView];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        _contentView = [[UIView alloc]init];
        _contentView.layer.cornerRadius = 5;
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
        theInputView.backgroundColor = CHHCOLOR_D(0xf4f4f4);
        theInputView.layer.cornerRadius = 5;
        theInputView.layer.masksToBounds = YES;
        theInputView.backgroundColor =  UIColorHex(F4F8F8);
        [_topView addSubview:theInputView];
        [theInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
        }];
        
        self.growingTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(16,0, SCREEN_WIDTH-30, 38)];
        self.growingTextView.contentInset = UIEdgeInsetsMake(5,5,5,5);
        self.growingTextView.minHeight = 38;
        self.growingTextView.delegate = self;
        self.growingTextView.textColor = WhiteBgTitleColor;
        self.growingTextView.font = CFont(14);
//        self.growingTextView.layer.cornerRadius = 5;
//        self.growingTextView.layer.masksToBounds = YES;
        self.growingTextView.minNumberOfLines = 1;
        self.growingTextView.maxNumberOfLines = 10;
        self.growingTextView.animateHeightChange = YES;
        self.growingTextView.placeholder = @"说点什么...";
        self.growingTextView.placeholderColor = UIColorHex(B0B0B0);
        self.growingTextView.returnKeyType = UIReturnKeySend;
        self.growingTextView.enablesReturnKeyAutomatically = YES;
        self.growingTextView.backgroundColor =  UIColorHex(F4F8F8);
        [theInputView addSubview:self.growingTextView];
        [self.growingTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(35);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[DetailSendcomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [theInputView addSubview:self.collectionView];
        self.collectionView.hidden = YES;
        [self updataView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.growingTextView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(45);
            make.bottom.mas_equalTo(0);
        }];
        
        _sendBtn = [[UIButton alloc]init];
        [_sendBtn setTitle:@"发送" forState:BtnNormal];
        _sendBtn.titleLabel.font = CFont(14);
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
        
        _picBtn = [[UIButton alloc]init];
        [_picBtn setBackgroundImage:CImage(@"dyn_issue_pickPic") forState:BtnNormal];
        [_picBtn addTarget:self action:@selector(sendAction:) forControlEvents:BtnTouchUpInside];
        _picBtn.tag = 2;
        [_topView addSubview:_picBtn];
        [_picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(22);
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.sendBtn);
        }];
        
        _emojiBtn = [[UIButton alloc]init];
        [_emojiBtn setBackgroundImage:CImage(@"dyn_issue_Emoji") forState:BtnNormal];
        [_emojiBtn addTarget:self action:@selector(sendAction:) forControlEvents:BtnTouchUpInside];
        _emojiBtn.tag = 1;
        [_topView addSubview:_emojiBtn];
        [_emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(23);
            make.left.mas_equalTo(self.picBtn.mas_right).offset(15);
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
                NSString *text = dict[@"name"];
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
-(void)updataView{
[self layoutIfNeeded];
//    WS(weakSelf);
    if (self.AddPicArray.count) {
        self.collectionView.hidden = NO;
//        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(45);
//        }];

    }else{
        self.collectionView.hidden = YES;
//        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(45);
//        }];


    }

    self.manager.configuration.photoMaxNum = self.picSelEnableNum - self.AddPicArray.count;
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
                            if (IsEquallString(dict[@"name"], subText)) {
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
-(void)setIsReply:(BOOL)isReply{
    _isReply =  isReply;
    if (isReply) {
        self.picBtn.hidden = YES;
        [_emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(22);
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.sendBtn);
        }];
    }
}
-(void)ReplyAct{
    WS(weakSelf);
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest EvaluateMsgWithcommentid:self.contentid content:_growingTextView.text touid:self.touid Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        if (flag) {
            
            BXDynCommentModel *model = [BXDynCommentModel new];
            model.uid = [BXLiveUser currentBXLiveUser].user_id;
            model.user_id = [BXLiveUser currentBXLiveUser].user_id;
            model.nickname = [BXLiveUser currentBXLiveUser].nickname;
            model.content = weakSelf.growingTextView.text;
            model.avatar = [BXLiveUser currentBXLiveUser].avatar;
            model.commentid = self.contentid;
            model.create_time = @"刚刚";
            if (weakSelf.replyName) {
                model.reply_nickname = weakSelf.replyName;
            }
            if (weakSelf.touid) {
                model.reply_user_id = weakSelf.touid;
                model.touid = weakSelf.touid;
            }
            if (weakSelf.replyComment) {
                weakSelf.replyComment(model);
            }
        }else{
            
        }
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        [self removeAction];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
    }];
}
-(void)startCommentAct{
    NSString *picstr = @"";
    if (self.PicUrlArray.count) {
        
        picstr = [self.PicUrlArray componentsJoinedByString:@","];
    }
    [BGProgressHUD showLoadingAnimation];
    WS(weakSelf);
    [HttpMakeFriendRequest CommentDynamicWithfcmid:self.model.fcmid content:_growingTextView.text imgs:picstr Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        if (flag) {
            
            if (weakSelf.sendComment) {
                BXDynCommentModel *model = [BXDynCommentModel new];
                model.user_id = [BXLiveUser currentBXLiveUser].user_id;
                model.nickname = [BXLiveUser currentBXLiveUser].username;
                model.content = weakSelf.growingTextView.text;
                model.avatar = [BXLiveUser currentBXLiveUser].avatar;
                model.create_time = @"刚刚";
                weakSelf.sendComment(model);
   
            }
        }

        [self removeAction];
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"评论失败"];
    }];
    
    
    if (_sendComment) {
//        _sendComment(_growingTextView.text,[self jsonString:self.AtArray]);
    }
    [self removeAction];
}
- (void)sendAction:(UIButton *)sender {
    if (!sender.tag) {

            if (_growingTextView.text && _growingTextView.text.length) {
                if (self.AddPicArray.count) {
                    [self uploadImgCurrentIndex:0 totalCount:self.AddPicArray.count];
                }else{
                    if (!self.isReply) {
                        [self startCommentAct];
                    }else{
                        [self ReplyAct];
                    }
                }
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
            if (self.AddPicArray.count >= self.picSelEnableNum) {

                [BGProgressHUD showInfoWithMessage:[NSString stringWithFormat:@"最多只能选择%ld张图片", (long)self.picSelEnableNum]];
                return;
            }
            [self.manager clearSelectedList];
            self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(1000, 1000);
              [self.viewController hx_presentSelectPhotoControllerWithManager:self.manager delegate:self];
            
//            [self hx_presentSelectPhotoControllerWithManager:self.manager delegate:self];
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
        _sendBtn.titleLabel.font = CFont(14);
        _sendBtn.backgroundColor = DynSendButtonBackColor;
        [_sendBtn setTitleColor:DynSendButtonTitle forState:UIControlStateNormal];
    }
    else{
        _sendBtn.titleLabel.font = CFont(14);
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
//                _sendComment(growingTextView.text,[self jsonString:self.AtArray]);
            }
            [self sendAction:_sendBtn];
            [self removeAction];
        }
        return NO;
    }
    
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (![growingTextView.text isEqualToString:@""]) {
        _sendBtn.titleLabel.font = CFont(14);
        _sendBtn.backgroundColor = DynSendButtonBackColor;
        [_sendBtn setTitleColor:DynSendButtonTitle forState:UIControlStateNormal];
    }
    else{
        _sendBtn.titleLabel.font = CFont(14);
        _sendBtn.backgroundColor = sl_subBGColors;
        [_sendBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
    }
    _sendBtn.selected = !growingTextView.text.length;
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
#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.AddPicArray.count) {
        return 0;
    }
    return self.AddPicArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailSendcomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    WS(weakSelf);
    cell.picImage.image = _AddPicArray[indexPath.row];
    cell.backgroundColor = [UIColor redColor];
    cell.DelPicture = ^{
        [weakSelf.AddPicArray removeObjectAtIndex:indexPath.row];
        [weakSelf.collectionView reloadData];
        [weakSelf updataView];
    };
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.AddPicArray.count - 1) {
//        [self AddPicture];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    return CGSizeMake(36, 36);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
        return 0;
 
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

        return 12;

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 12, 0, 0);
}
#pragma mark - 懒加载HXPhoto
//- (HXDatePhotoToolManager *)toolManager {
//    if (!_toolManager) {
//        _toolManager = [[HXDatePhotoToolManager alloc] init];
//    }
//    return _toolManager;
//}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = NO;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.lookGifPhoto = NO;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.singleSelected = NO;
        _manager.configuration.photoMaxNum = self.picSelEnableNum;
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = NO;
        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(500, 500);
        _manager.configuration.photoCanEdit = NO;
        _manager.configuration.videoCanEdit = NO;
        _manager.configuration.rowCount = 4;
        _manager.configuration.themeColor = sl_normalColors;
//        _manager.configuration.restoreNavigationBar = YES;
    }
    return _manager;
}
#pragma mark - 图片选择 代理方法
/**
 点击完成

 @param albumListViewController self
 @param allList 已选的所有列表(包含照片、视频)
 @param photoList 已选的照片列表
 @param videoList 已选的视频列表
 @param original 是否原图
 */
-(void)photoNavigationViewController:(HXCustomNavigationController *)photoNavigationViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    NSLog(@"%@",allList);
    NSLog(@"%@",photoList);
    NSLog(@"%@",videoList);
    
    WS(ws);
    [photoList hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
        for (int i = 0; i < imageArray.count; i++) {
            UIImage *image = imageArray[i];
            [ws.AddPicArray addObject:image];
            [self updataView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
            });

        }
    }];
//    [self.toolManager getSelectedImageList:photoList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
//       for (int i = 0; i < imageList.count; i++) {
//           UIImage *image = imageList[i];
//           [ws.AddPicArray addObject:image];
//           [self updataView];
//           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//               [self.collectionView reloadData];
//           });
//
//       }
//    } failed:^{
//
//    }];
}
#pragma mark - 照相
- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
    
    WS(ws);
    model.selectIndexStr = @"1";
    [@[model] hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
        for (int i = 0; i < imageArray.count; i++) {
            UIImage *image = imageArray[i];
            [ws.AddPicArray addObject:image];
            [self updataView];
            [self.collectionView reloadData];
        }
    }];
//    [self.toolManager getSelectedImageList:@[model] requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
//        for (int i = 0; i < imageList.count; i++) {
//            UIImage *image = imageList[i];
//            [ws.AddPicArray addObject:image];
//            [self updataView];
//            [self.collectionView reloadData];
//
//        }
//
//    } failed:^{
//
//    }];
    
}

#pragma mark - 上传图片
-(void)uploadImgCurrentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount{
    UIImage *img = self.AddPicArray[currentIndex];
    NSData *data = UIImageJPEGRepresentation(img, .8);
    NSString *path = [self getImageFilePath:data fileName:[NSString stringWithFormat:@"%ld.jpg",(long)currentIndex]];
    WS(weakSelf);
    [BGProgressHUD showLoadingAnimation];
    [SLUpLoadAndDownloadTools uploadFileWithType:@"friend_images" filePath:path success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [BGProgressHUD hidden];
        if (flag) {
            [weakSelf.PicUrlArray addObject:jsonDic[@"filePath"]];
            NSLog(@"七牛：%@",jsonDic);
            NSLog(@"~%ld",(long)currentIndex);
            if (currentIndex < totalCount-1) {
                [weakSelf uploadImgCurrentIndex:currentIndex+1 totalCount:totalCount];
            }else{
//                    最后一个任务完成~
//                [BGProgressHUD showProgress:1.0 status:@"上传中"];
//                [self startIssue:nil type:@"picture"];
                [self startCommentAct];
//                [weakSelf.PicUrlArray removeAllObjects];
            }
        }
        
    } failure:^(NSError *error) {
        [BGProgressHUD hidden];
        [BGProgressHUD showInfoWithMessage:@"上传失败"];
    }];
}
//获取暂时文件路径
-(NSString *)getImageFilePath:(NSData *)imageData {
    NSString *path = [[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:@"addPicture_cover.jpg"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [imageData writeToFile:path atomically:YES];
    return path;
}
#pragma mark - 获取临时文件路径
-(NSString *)getImageFilePath:(NSData *)imageData fileName:(NSString *)fileName {
    NSString *dirPath =[[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:@"manual"];
    BOOL isdir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dirPath isDirectory:&isdir]) {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [dirPath stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [imageData writeToFile:path atomically:YES];
    return path;
}

@end

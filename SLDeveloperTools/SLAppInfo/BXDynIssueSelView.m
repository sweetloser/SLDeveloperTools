//
//  BXDynIssueSelView.m
//  BXlive
//
//  Created by mac on 2020/7/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynIssueSelView.h"
#import <Masonry/Masonry.h>
#import "DynRecoderVoice.h"
#import "DynPlayMp3Voice.h"
#import "BXDynAlertRemoveSoundView.h"
#import "BXDynCircleProgressView.h"
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
@interface BXDynIssueSelView()<playDelegate>
@property(nonatomic, strong)DynRecoderVoice *recoderSound;
@property(nonatomic, strong)DynPlayMp3Voice *playSound;
@property (nonatomic,strong)NSTimer *recordTimer;

@property(nonatomic, strong)UIImageView *MicrImageView;
@property(nonatomic, strong)UIImageView *PickPicImageView;
@property(nonatomic, strong)UIImageView *EmojiImageView;
@property(nonatomic, strong)UIImageView *AiteImageView;
@property(nonatomic, strong)UIImageView *RecExpImageView;
@property(nonatomic, strong)UIImageView *KwdImageView;

@property (strong, nonatomic) UIView *bottomView;
@property (assign, nonatomic) CGFloat maxHeight;




@property(nonatomic, strong)UIButton *micrAniImageView;
@property(nonatomic, strong)UIButton *micrAniPlaybtn;
//@property(nonatomic, strong)UIButton *micrAniBtn;
@property(nonatomic, strong)UILabel *micrAnilabel;
@property(nonatomic, strong)UIButton *micrdeleteBtn;
@property(nonatomic, strong)UIButton *micrSaveimageBtn;

@property (strong, nonatomic) UIView *LuYinView;
@property(nonatomic, strong)BXDynCircleProgressView *circleView;
@property(nonatomic, strong)UILabel *Duralabel;
@property (strong, nonatomic) NSString *mp3Path;
@property (assign, nonatomic) NSInteger timeRecoder;
@property (assign, nonatomic) NSInteger initRecoder;
@end
@implementation BXDynIssueSelView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self intiView];
        [self setVoiceAndEmoji];

        self.userInteractionEnabled = YES;
        _recoderSound = [[DynRecoderVoice alloc]init];
        _playSound = [[DynPlayMp3Voice alloc]init];
        _playSound.delegate = self;
    }
    return self;
}
-(void)intiView{
//    UILabel *downlabel = [[UILabel alloc]init];
//    downlabel.backgroundColor = UIColorHex(#2B2E37);
//    [self addSubview:downlabel];
//    [downlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-51 - __kBottomAddHeight);
//    }];
    
    _MicrImageView = [[UIImageView alloc]init];
    _MicrImageView.image = [UIImage imageNamed:@"dyn_issue_micr"];
    _MicrImageView.tag = 0;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickBtn:)];
    [_MicrImageView addGestureRecognizer:tap1];
    _MicrImageView.userInteractionEnabled = YES;
    [self addSubview:_MicrImageView];
    [_MicrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(14);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(22);
    }];
    
    _PickPicImageView = [[UIImageView alloc]init];
    _PickPicImageView.tag = 1;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickBtn:)];
    [_PickPicImageView addGestureRecognizer:tap2];
    _PickPicImageView.image = [UIImage imageNamed:@"dyn_issue_pickPic"];
    _PickPicImageView.userInteractionEnabled = YES;
    [self addSubview:_PickPicImageView];
    [_PickPicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_MicrImageView.mas_right).offset(25);
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
        make.left.mas_equalTo(_PickPicImageView.mas_right).offset(25);
        make.top.mas_equalTo(_MicrImageView);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(23);
    }];
    
    _AiteImageView = [[UIImageView alloc]init];
    _AiteImageView.image = [UIImage imageNamed:@"dyn_issue_AiTe"];
    _AiteImageView.tag = 3;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickBtn:)];
    [_AiteImageView addGestureRecognizer:tap4];
    _AiteImageView.userInteractionEnabled = YES;
    [self addSubview:_AiteImageView];
    [_AiteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_EmojiImageView.mas_right).offset(25);
        make.top.mas_equalTo(_MicrImageView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(24);
    }];

    
    _KwdImageView = [[UIImageView alloc]init];
    _KwdImageView.image = [UIImage imageNamed:@"dyn_issue_KeyWord"];
    _KwdImageView.tag = 4;
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickBtn:)];
    [_KwdImageView addGestureRecognizer:tap6];
    _KwdImageView.userInteractionEnabled = YES;
    [self addSubview:_KwdImageView];
    [_KwdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_AiteImageView.mas_right).offset(28);
        make.top.mas_equalTo(_MicrImageView);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(21);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)setVoiceAndEmoji{
    _micrBackView = [[UIView alloc]init];
    [self addSubview:_micrBackView];
    [_micrBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(_MicrImageView.mas_bottom).offset(10);
        make.bottom.mas_offset(-__kBottomAddHeight);
    }];
    _micrBackView.hidden = YES;
    
    _circleView = [[BXDynCircleProgressView alloc]initWithFrame:CGRectMake(_micrAniPlaybtn.center.x, _micrAniPlaybtn.center.y, 92, 92)];
    [_micrBackView addSubview:_circleView];
    
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(30);
        make.centerX.mas_equalTo(_micrBackView.mas_centerX);
        make.width.height.mas_equalTo(92);
    }];
    
    _micrAniImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_micrAniImageView setImage:CImage(@"dyn_issue_LuYin_will") forState:UIControlStateNormal];
    [_micrBackView addSubview:_micrAniImageView];
    [_micrAniImageView addTarget:self action:@selector(recoderAct:) forControlEvents:UIControlEventTouchUpInside];
    [_micrAniImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(30);
        make.centerX.mas_equalTo(_micrBackView.mas_centerX);
        make.width.height.mas_equalTo(84);
    }];
    
    _micrAniPlaybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_micrAniPlaybtn setImage:CImage(@"dyn_issue_LuYin_play") forState:UIControlStateNormal];
    [_micrBackView addSubview:_micrAniPlaybtn];
    [_micrAniPlaybtn addTarget:self action:@selector(PlayAct:) forControlEvents:UIControlEventTouchUpInside];
    [_micrAniPlaybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(30);
        make.centerX.mas_equalTo(_micrBackView.mas_centerX);
        make.width.height.mas_equalTo(84);
    }];
    _micrAniPlaybtn.hidden = YES;
    

    
    
    _micrAnilabel = [[UILabel alloc]init];
    _micrAnilabel.text = @"点击录音";
    _micrAnilabel.textAlignment = 1;
    _micrAnilabel.textColor = UIColorHex(#8C8C8C);
    _micrAnilabel.font = [UIFont systemFontOfSize:12];
    [_micrBackView addSubview:_micrAnilabel];
    [_micrAnilabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(_micrAniImageView.mas_top).offset(-10);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(20);
    }];
    
    _Duralabel = [[UILabel alloc]init];
    _Duralabel.text = @"00:00";
    _Duralabel.textAlignment = 1;
    _Duralabel.textColor = UIColorHex(#8C8C8C);
    _Duralabel.font = [UIFont systemFontOfSize:12];
    [_micrBackView addSubview:_Duralabel];
    [_Duralabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(_micrAnilabel.mas_top).offset(-10);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(20);
    }];
    _Duralabel.hidden = YES;

    _micrdeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_micrdeleteBtn setImage:CImage(@"dyn_issue_LuYin_del") forState:UIControlStateNormal];
     [_micrdeleteBtn addTarget:self action:@selector(DelAct:) forControlEvents:UIControlEventTouchUpInside];
    [_micrBackView addSubview:_micrdeleteBtn];
    [_micrdeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_micrAniPlaybtn.mas_centerY);
        make.right.mas_equalTo(_micrAniPlaybtn.mas_left).offset(-30);
        make.width.height.mas_equalTo(26);
    }];
    
    _micrdeleteBtn.hidden = YES;
    
    _micrSaveimageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [_micrSaveimageBtn addTarget:self action:@selector(SaveAct:) forControlEvents:UIControlEventTouchUpInside];
    [_micrSaveimageBtn setImage:CImage(@"dyn_issue_LuYin_save") forState:UIControlStateNormal];
    [_micrBackView addSubview:_micrSaveimageBtn];
    [_micrSaveimageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_micrAniPlaybtn.mas_centerY);
        make.left.mas_equalTo(_micrAniPlaybtn.mas_right).offset(30);
        make.width.height.mas_equalTo(26);
    }];
    _micrSaveimageBtn.hidden = YES;
    
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
    [self addSubview:_emojiView];
    [_emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(_MicrImageView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    _emojiView.hidden = YES;
}
-(void)setShowType:(NSInteger)ShowType{
    if (ShowType == 0) {
        _micrBackView.hidden = NO;
        _emojiView.hidden = YES;
    }
    if (ShowType == 2) {
        _micrBackView.hidden = YES;
        _emojiView.hidden = NO;
    }
}
-(void)ClickBtn:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger flag = [tap.view tag];
    
//    if (flag == 0) {
//        _emojiView.hidden = YES;
//        _micrBackView.hidden = NO;
//    }
//    if (flag == 2) {
//        _emojiView.hidden = NO;
//        _micrBackView.hidden = YES;
//    }
//    if (flag == 3) {
//        if ([self.delegate respondsToSelector:@selector(SkipAiTeFriend)]) {
//            [self.delegate SkipAiTeFriend];
//        }
//    }
    if ([self.delegate respondsToSelector:@selector(ClickBtn:)]) {
        [self.delegate ClickBtn:flag];
    }
}
-(void)recoderAct:(UIButton *)btn{
    btn.selected = !btn.selected;

    if (btn.selected) {
        
        [_recoderSound recordStart];
        [_micrAniImageView setImage:CImage(@"dyn_issue_LuYin_stop") forState:UIControlStateNormal];
        _Duralabel.hidden = NO;
    
        [self startRecordTimer];
        WS(weakSelf);
        _recoderSound.GetRecoder = ^(BOOL isRecoder) {
            if (!isRecoder) {
                [weakSelf stopRecordTimer];
                weakSelf.micrAnilabel.text = @"点击录音";
                [weakSelf.micrAniImageView setImage:CImage(@"dyn_issue_LuYin_will") forState:UIControlStateNormal];
                weakSelf.Duralabel.hidden = YES;
            }
        };
        _recoderSound.GetMp3Path = ^(NSString * _Nonnull Mp3Path) {
            weakSelf.mp3Path = Mp3Path;
            weakSelf.micrAniImageView.hidden = YES;
            weakSelf.micrAniPlaybtn.hidden = NO;
            weakSelf.micrAnilabel.text = @"点击播放";
            [weakSelf.micrAniPlaybtn setImage:CImage(@"dyn_issue_LuYin_play") forState:UIControlStateNormal];
            weakSelf.micrdeleteBtn.hidden = NO;
            weakSelf.micrSaveimageBtn.hidden = NO;
        };
    }else{
        [_micrAniImageView setImage:CImage(@"dyn_issue_LuYin_will") forState:UIControlStateNormal];
        _micrAnilabel.text = @"点击录音";
        [_recoderSound recordEnd];
        [self stopRecordTimer];
        
    }
}
-(void)PlayAct:(UIButton *)btn{
    btn.selected = !btn.selected;

    if (btn.selected) {
        [self startPlayTimer];
        [_playSound StartPlayWithplaypath:_mp3Path];
        [_playSound startPlay];
        [_micrAniPlaybtn setImage:CImage(@"dyn_issue_LuYin_stop") forState:UIControlStateNormal];
    }else{
        [self stopPlayTimer];
        [_playSound StopPlay];
        [_micrAniPlaybtn setImage:CImage(@"dyn_issue_LuYin_play") forState:UIControlStateNormal];
    }
}
-(void)DelAct:(UIButton *)btn{
    BXDynAlertRemoveSoundView *view =[[BXDynAlertRemoveSoundView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight) Title:@"是否放弃当前录音" Sure:@"放弃" Cancle:@"取消"];
    WS(weakSelf);
    view.RemoveBlock = ^{
        
        weakSelf.initRecoder = 0;
        weakSelf.timeRecoder = 0;
        weakSelf.micrAniImageView.hidden = NO;
        weakSelf.Duralabel.hidden = YES;
        weakSelf.micrAniPlaybtn.hidden = YES;
        weakSelf.micrAnilabel.text = @"点击录音";
        [weakSelf.micrAniImageView setImage:CImage(@"dyn_issue_LuYin_will") forState:UIControlStateNormal];
        weakSelf.micrdeleteBtn.hidden = YES;
        weakSelf.micrSaveimageBtn.hidden = YES;
        [weakSelf.circleView stopTimer];
    };
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
//    [UIView animateWithDuration:0.2 animations:^{
//        self.frame = CGRectMake(0, __kHeight, __kWidth, 270);
//    }];
}
-(void)SaveAct:(UIButton *)btn{

    _micrAniImageView.hidden = NO;
    _micrAniPlaybtn.hidden = YES;
    _Duralabel.hidden = YES;
    _micrAnilabel.text = @"点击录音";
    [_micrAniImageView setImage:CImage(@"dyn_issue_LuYin_will") forState:UIControlStateNormal];
    _micrdeleteBtn.hidden = YES;
    _micrSaveimageBtn.hidden = YES;
    _initRecoder = 0;
    _timeRecoder = 0;
    if (self.ReturnPath) {
        self.ReturnPath(_mp3Path);
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, __kHeight - 46, __kWidth, 270);
    }];
}


#pragma mark - Private Methods

- (void)startRecordTimer{
    _timeRecoder = 0;
    if (!self.recordTimer) {
        self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recoderTime) userInfo:nil repeats:YES];
        [self.recordTimer setFireDate:[NSDate distantPast]];
        [_circleView setTotalSecondTime:60];
//        [_circleView setTotalMinuteTime:60];
        [_circleView startTimer];
    }
}

- (void)stopRecordTimer{
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
        _initRecoder = _timeRecoder;

    }
    [_circleView stopTimer];
}
-(void)recoderTime{
    _timeRecoder++;
    _Duralabel.text = [self getFormatString:_timeRecoder];
    if (_timeRecoder >= 60) {
        [self recoderAct:_micrAniImageView];
    }
}


- (void)startPlayTimer{
    if (!self.recordTimer) {
        self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(PlayTime) userInfo:nil repeats:YES];
        [self.recordTimer setFireDate:[NSDate distantPast]];
    }
    [_circleView setTotalSecondTime:_initRecoder];
    [_circleView startTimer];
}

- (void)stopPlayTimer{
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
        _timeRecoder = _initRecoder;
        _Duralabel.text = [self getFormatString:_timeRecoder];

    }
     [_circleView stopTimer];
}
-(void)PlayTime{
    _timeRecoder--;
    if (_timeRecoder >=0) {
        _Duralabel.text = [self getFormatString:_timeRecoder];
    }
}

- (NSString *)getFormatString:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours <= 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}
#pragma - mark PlayDelegate
-(void)endPlaySound{
    [self stopPlayTimer];
    [_playSound StopPlay];
    [_micrAniPlaybtn setImage:CImage(@"dyn_issue_LuYin_play") forState:UIControlStateNormal];
    [self PlayAct:_micrAniPlaybtn];
}
#pragma - mark NSNotification
- (void)keyboardWillHide:(NSNotification *)noti {
//0, __kHeight - 46, __kWidth, 270)
    self.frame = CGRectMake(0, __kHeight -46 - __kBottomAddHeight, __kWidth, 270 + __kBottomAddHeight);
    
}
- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo=noti.userInfo;
    NSValue *keyBoardEndBounds=userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    CGFloat keyboardhight=endRect.size.height;
    CGFloat duration=[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve =[userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    [UIView setAnimationCurve:animationCurve];
//    if (!_bottomView.mj_h) {
//        if (!keyboardhight) {
//            return;
//        }
//        if (keyboardhight > _maxHeight) {
//            _maxHeight = keyboardhight;
//        }
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, -keyboardhight);
//            if (keyboardhight == self.maxHeight) {
                
//                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.mas_equalTo(keyboardhight);
//                }];
                self.transform = CGAffineTransformIdentity;
                CGRect frame = self.frame;
                frame.origin.y = __kHeight -  keyboardhight - 50;
                self.frame = frame;
                
//            }
        } completion:^(BOOL finished) {
        }];
//    } else {
//        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(keyboardhight);
//        }];
//        CGRect frame = self.frame;
//        frame.origin.y = __kHeight -  keyboardhight - 50;
//        self.frame = frame;
//        [self setNeedsUpdateConstraints];
//        [self updateConstraintsIfNeeded];
//        
//        [UIView animateWithDuration:duration animations:^{
//            [self layoutIfNeeded];
//            [self layoutSubviews];
//        }];
//    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_recoderSound deleteMp3Folder];
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}


@end

//
//  BXLiveMusicView.m
//  BXlive
//
//  Created by bxlive on 2019/6/12.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXLiveMusicView.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Lottie/Lottie.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "TimeHelper.h"
#import "BXLrcDataTool.h"
#import "BXLrcLabel.h"
#import "FilePathHelper.h"
#import "BXLrcDataTool.h"
#import "BXLrcModel.h"
#import "NewHttpManager.h"

@interface BXLiveMusicView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *operationBtns;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) BXLrcLabel *fLb;
@property (nonatomic, strong) BXLrcLabel *sLb;
@property (nonatomic, strong) UIAlertController *alertVc;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) BOOL isTransparent;

@property (nonatomic, strong) NSArray *lyricArray;

@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat currentTime;

@end

@implementation BXLiveMusicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithMusic:(BXMusicModel *)music {
    if ([super init]) {
        _music = music;
    
        CGFloat y = iPhoneX ? 140 : 110 + 90;
        self.frame = CGRectMake(10, y, __kWidth - 20, 157);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        _operationBtns = [NSMutableArray arrayWithCapacity:4];
        NSArray *titles = @[@"歌词报错", @"音效", @"重唱", @"结束"];
        NSArray *imageNames = @[@"live_reportErrors", @"live_soundEffect2", @"live_replay", @"live_musicEnd"];
        BOOL isSmall = __kWidth <= __k5Width;
        CGFloat width = 70;
        if (isSmall) {
            width -= 20;
        }
        CGFloat space = (self.mj_w - width * 4 - 23) / 5;
        UIView *lastView = nil;
        for (NSInteger i = 0; i < 4; i++) {
            CGFloat tempWidth = width;
            if (!i) {
                tempWidth += 23;
            }
            NSString *imageName = imageNames[i];
            UIButton *operationBtn = [[UIButton alloc]init];
            if (isSmall) {
                [operationBtn setTitle:titles[i] forState:BtnNormal];
            } else {
                [operationBtn setTitle:[NSString stringWithFormat:@" %@",titles[i]] forState:BtnNormal];
                [operationBtn setImage:CImage(imageName) forState:BtnNormal];
            }
            operationBtn.titleLabel.font = CFont(12);
            [operationBtn setTitleColor:sl_blackBGColors forState:BtnNormal];
            operationBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.25];
            operationBtn.layer.cornerRadius = 12.5;
            operationBtn.tag = i;
            [operationBtn addTarget:self action:@selector(operationAction:) forControlEvents:BtnTouchUpInside];
            [self addSubview:operationBtn];
            [_operationBtns addObject:operationBtn];
            [operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(25);
                make.width.mas_equalTo(tempWidth);
                if (lastView) {
                    make.left.mas_equalTo(lastView.mas_right).offset(space);
                } else {
                    make.left.mas_equalTo(space);
                }
                make.bottom.mas_equalTo(-11);
            }];
            lastView = operationBtn;
        }
        
        LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"live-music"];
        animationView.loopAnimation = YES;
        [self addSubview:animationView];
        [animationView play];
        [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-space);
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(8 + 3);
            make.width.mas_equalTo(14);
        }];
        
        _timeLb = [[UILabel alloc]init];
        _timeLb.font = CFont(12);
        _timeLb.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
        _timeLb.text = @"--/--";
        _timeLb.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(animationView.mas_left).offset(-5);
            make.width.mas_equalTo(76);
            make.centerY.mas_equalTo(animationView);
            make.height.mas_equalTo(16);
        }];
        
        _progressView = [[UIProgressView alloc]init];
        _progressView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:.4];
        _progressView.progressTintColor = normalColors;
        [self addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1.5);
            make.left.mas_equalTo(space);
            make.centerY.mas_equalTo(animationView);
            make.right.mas_equalTo(self.timeLb.mas_left).offset(-10);
        }];
        
        _fLb = [[BXLrcLabel alloc]init];
        _fLb.textColor = [UIColor whiteColor];
        _fLb.color = TextHighlightColor;
        _fLb.font = CBFont(20);
        _fLb.adjustsFontSizeToFitWidth = YES;
        _fLb.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5].CGColor;
        _fLb.layer.shadowRadius = 0;
        _fLb.layer.shadowOffset = CGSizeMake(1, 1);
        _fLb.layer.shadowOpacity = 1;
        [self addSubview:_fLb];
        [_fLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(space);
            make.top.mas_equalTo(43);
            make.height.mas_equalTo(26);
            make.right.mas_lessThanOrEqualTo(-space);
        }];
        
        _sLb = [[BXLrcLabel alloc]init];
        _sLb.textColor = [UIColor whiteColor];
        _sLb.color = TextHighlightColor;
        _sLb.font = CBFont(20);
        _sLb.adjustsFontSizeToFitWidth = YES;
        _sLb.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5].CGColor;
        _sLb.layer.shadowRadius = 0;
        _sLb.layer.shadowOffset = CGSizeMake(1, 1);
        _sLb.layer.shadowOpacity = 1;
        [self addSubview:_sLb];
        [_sLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(space);
            make.top.mas_equalTo(self.fLb.mas_bottom).offset(8);
            make.height.mas_equalTo(26);
            make.right.mas_equalTo(-space);
        }];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        NSString *lyricPath = [music lyricFilePath];
        if ([FilePathHelper fileIsExistsAtPath:lyricPath]) {
            _lyricArray = [BXLrcDataTool getLrcModelsWithPath:lyricPath];
        }
        
        if (_lyricArray && _lyricArray.count) {
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        } else {
            _fLb.text = music.title;
            _sLb.text = @"暂无歌词";
        }
        
        [self tapAction];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self tapAction];
    }
    
    CGPoint point = [recognizer translationInView:self];
    self.center = CGPointMake(self.center.x, self.center.y + point.y);
    if (self.mj_y < 20 + __kTopAddHeight) {
        self.mj_y = 20 + __kTopAddHeight;
    } else if (self.mj_y + self.mj_h > __kHeight - __kBottomAddHeight - 2) {
        self.mj_y = __kHeight - __kBottomAddHeight - 2 - self.mj_h;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)tapAction {
    [self.superview bringSubviewToFront:self];
    
    self.isTransparent = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setBackgroundColorTransparent) object:nil];
    [self performSelector:@selector(setBackgroundColorTransparent) withObject:nil afterDelay:3.0];
}

- (void)operationAction:(UIButton *)sender {
    if (sender.tag == 1) {
        [self callbackOperationWithTag:sender.tag];
    } else {
        NSString *title = nil;
        NSString *message = nil;
        NSString *cancleTitle = nil;
        NSString *sureTitle = nil;
        if (!sender.tag) {
            [NewHttpManager musicLrcReportWithMusicId:_music.music_id success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
            } failure:^(NSError *error) {
            }];
            
            message = @"感谢您的反馈，我们会尽快处理！";
            sureTitle = @"确定";
            [self performSelector:@selector(dismissAlertController) withObject:nil afterDelay:3.0];
        } else if (sender.tag == 2) {
            title = @"重新演唱";
            message = @"您确定要重新演唱吗？";
            cancleTitle = @"取消";
            sureTitle = @"确定";
        } else {
            title = @"结束演唱";
            message = @"您确定要结束演唱吗？";
            cancleTitle = @"取消";
            sureTitle = @"确定";
        }
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (cancleTitle) {
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:cancle];
        }
        UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self callbackOperationWithTag:sender.tag];
            if (!sender.tag) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlertController) object:nil];
                self.alertVc = nil;
            }
        }];
    
        [alertVc addAction:sure];
        [self.viewController presentViewController:alertVc animated:YES completion:nil];
        
        if (!sender.tag) {
            _alertVc = alertVc;
        }
    }
}

- (void)dismissAlertController {
    if (_alertVc) {
        [_alertVc dismissViewControllerAnimated:NO completion:nil];
        _alertVc = nil;
    }
}

- (void)callbackOperationWithTag:(NSInteger)tag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveMusicViewOperationType:)]) {
        [self.delegate liveMusicViewOperationType:tag];
    }
}

- (void)setBackgroundColorTransparent {
    self.isTransparent = YES;
}

- (void)setIsTransparent:(BOOL)isTransparent {
    _isTransparent = isTransparent;
    
    if (_isTransparent) {
        self.backgroundColor = [UIColor clearColor];
        [_operationBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
    } else {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
        [_operationBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
    }
}

- (void)setCurrentTime:(CGFloat)currentTime duration:(CGFloat)duration {
    _currentTime = currentTime;
    _duration = duration;
    if (duration) {
        _progressView.progress = currentTime / duration;
        _timeLb.text = [NSString stringWithFormat:@"%@/%@",[TimeHelper changeTimeWithDuration:currentTime], [TimeHelper changeTimeWithDuration:duration]];
    }
}

- (void)stopDisplayLink {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    [self dismissAlertController];
}

- (void)updateLrc {
    if (_lyricArray && _lyricArray.count) {
        NSInteger row = [BXLrcDataTool getRowWithCurrentTime:_currentTime lrcModels:_lyricArray];
        if (row >= 0 && row < _lyricArray.count) {
            BXLrcModel *lrcModel = _lyricArray[row];
            CGFloat progress = (_currentTime - lrcModel.beginTime) / (lrcModel.endTime - lrcModel.beginTime);
            if (row % 2) {
                _fLb.progress = 0;
                _sLb.progress = progress;
            } else {
                _fLb.text = lrcModel.lrcText;
                if (row + 1 < _lyricArray.count) {
                    BXLrcModel *nextLrcModel = _lyricArray[row + 1];
                    _sLb.text = nextLrcModel.lrcText;
                } else {
                    _sLb.text = nil;
                }
                _fLb.progress = progress;
                _sLb.progress = 0;
            }
        }
    }
}

- (void)dealloc {
    NSLog(@"音乐伴奏视图销毁了");
}

@end

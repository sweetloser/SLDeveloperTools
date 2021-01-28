//
//  BXPlayerControlView.m
//  BXlive
//
//  Created by bxlive on 2019/2/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXPlayerControlView.h"
#import "SLHomePageVedioPlayProgressView.h"
#import "BXProgressView.h"
#import "BXVideoLoadingView.h"
#import <KTVHTTPCache/KTVHTTPCache.h>
#import "BXReportVideoManager.h"
#import "TimeHelper.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BXTreasureChestDetailView.h"
#import <Lottie/Lottie.h>
#import "UIApplication+ActivityViewController.h"
#import "BXRewardTopThreeView.h"
//#import <UIImage+YYAdd.h>
#import <YYCategories/YYCategories.h>
#import "NSObject+Tag.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>
#import <ZFPlayer/ZFPlayer.h>
#import "SLAppInfoConst.h"
#import "BXLiveUser.h"
#import "NewHttpManager.h"
#import "../SLMaskTools/SLMaskTools.h"
@interface BXPlayerControlView ()

@property (strong, nonatomic) UIImageView *coverIv;
@property (strong, nonatomic) SLHomePageVedioPlayProgressView *progressView;
@property (strong, nonatomic) BXProgressView *LineprogressView;
@property (strong, nonatomic) BXVideoLoadingView *videoLoadingView;
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UIProgressView *volumProgressView;
@property (strong, nonatomic) MPVolumeView *volumeView;
@property (strong, nonatomic) UIImageView *playIv;
@property (strong, nonatomic) UIView *failView;

@property (strong, nonatomic) LOTAnimationView *treasureChestView;
@property (strong, nonatomic) BXRewardTopThreeView *rewardTopThreeView;


@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) NSInteger start_time;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger type;

@end

@implementation BXPlayerControlView
@synthesize player = _player;

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        _lastTapTime = 0;
        _lastTapPoint = CGPointZero;
        _type = type;
        UIImageView *topGradientView = [[UIImageView alloc]init];
        topGradientView.image = CImage(@"bg_black_1");
        [self addSubview:topGradientView];
        [topGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(topGradientView.mas_width).multipliedBy(188.0 / 750);
        }];

        UIImageView *bottomGradientView  = [[UIImageView alloc]init];
        bottomGradientView.image = CImage(@"bg_black_2");
        [self addSubview:bottomGradientView];
        [bottomGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(bottomGradientView.mas_width).multipliedBy(780.0 / 750);
        }];
        
        CGFloat bottomSpace = -49  - __kBottomAddHeight;
        if (type == 1) {
            bottomSpace = -__kBottomAddHeight;
        } else if (type == 2) {
            bottomSpace = 0;
        }
        
        UIView *bottomView = [[UIView alloc]init];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(8.5);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(bottomSpace);
        }];
        
        if (type == 2) {
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = TabBarColor;
            [bottomView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(2);
            }];
        }
    
        _progressView = [[SLHomePageVedioPlayProgressView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 8.5)];
//        _progressView.backgroundColor = [UIColor randomColor];
        [bottomView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(8.5);
            make.bottom.mas_equalTo(-5);
        }];
        
        _LineprogressView = [[BXProgressView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 1)];
        [bottomView addSubview:_LineprogressView];
        [_LineprogressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(-5);
        }];
        
        if (type == 2 || type == 1) {
            _LineprogressView.hidden = NO;
            _progressView.hidden = YES;
        }else{
            _LineprogressView.hidden = YES;
            _progressView.hidden = NO;
        }
        
        _videoLoadingView = [[BXVideoLoadingView alloc]init];
        _videoLoadingView.backgroundColor = [UIColor whiteColor];
        _videoLoadingView.layer.cornerRadius = .5;
        _videoLoadingView.layer.masksToBounds = YES;
        _videoLoadingView.hidden = YES;
        [bottomView addSubview:_videoLoadingView];
        [_videoLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(.5);
            make.center.mas_equalTo(self.progressView);
        }];
        
        UIImage *thumbImage = [UIImage yy_imageWithColor:[UIColor whiteColor] size:CGSizeMake(6, 6)];
        _slider = [[UISlider alloc]init];
        _slider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:.1];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:[thumbImage yy_imageByRoundCornerRadius:3] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTouchDownAction:) forControlEvents:UIControlEventTouchDown];
        _slider.continuous = NO;
        _slider.hidden = YES;
        [bottomView addSubview:_slider];
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(bottomView.mas_height);
            make.centerY.mas_equalTo(-1);
        }];
        
        _volumProgressView = [[UIProgressView alloc]init];
        _volumProgressView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:.2];
        _volumProgressView.progressTintColor = sl_normalColors;
        _volumProgressView.hidden = YES;
        [self addSubview:_volumProgressView];
        [_volumProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.mas_equalTo(self.progressView);
            make.top.mas_equalTo(iPhoneX ? 30 : 0);
        }];
       
        _playIv = [[UIImageView alloc]init];
        _playIv.image = CImage(@"video_play");
        [self addSubview:_playIv];
        [_playIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(66);
            make.center.mas_equalTo(0);
        }];
        
        _failView = [[UIView alloc]init];
        _failView.hidden = YES;
        [self addSubview:_failView];
        [_failView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        UIButton *failBtn = [[UIButton alloc]init];
        [failBtn addTarget:self action:@selector(failAction) forControlEvents:UIControlEventTouchUpInside];
        [failBtn setImage:CImage(@"play_fail") forState:BtnNormal];
        [_failView addSubview:failBtn];
        [failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(113);
            make.height.mas_equalTo(93);
        }];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = 1;
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderTapAction)];
        [_slider addGestureRecognizer:sliderTap];
        
        [self resetControlView];
        
        [_videoLoadingView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeDidChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baseVideoPlayVCViewAppearState:) name:@"BaseVideoPlayVCViewAppearState" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoRewardUsersChanged:) name:kVideoRewardUsersChangedNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _coverIv.frame = self.player.currentPlayerManager.view.bounds;
}

- (void)sliderTouchDownAction:(UISlider *)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenSlider) object:nil];
    sender.ds_Tag = 1;
}

- (void)sliderAction:(UISlider *)sender {
    sender.ds_Tag = 0;
    
    _progressView.progress = sender.value;
    _LineprogressView.progress = sender.value;
    [self performSelector:@selector(hiddenSlider) withObject:nil afterDelay:1.0];
    
    CGFloat totalTime = self.player.totalTime;
    if (totalTime > 12.0) {
        CGFloat time = totalTime * sender.value;
        if (totalTime - time < .3) {
            time = totalTime - .3;
        }
        [self.player seekToTime:time completionHandler:nil];
        [self.player.currentPlayerManager play];
    }
}

- (void)sliderTapAction {

}

- (void)hiddenSlider {
    _slider.hidden = YES;
}

- (void)failAction {
    [self.player.currentPlayerManager reloadPlayer];
}

-(void)singleTapAction{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenSlider) object:nil];
    if (_playIv.hidden) {
        [self.player.currentPlayerManager pause];
//        if (self.player.totalTime > 12.0) {
//            _slider.hidden = NO;
//        }
    } else {
        [self.player.currentPlayerManager play];
        _slider.hidden = YES;
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (_didLongPressAction) {
            _didLongPressAction([sender locationInView:self]);
        }
    }
}

- (void)treasureChestAction {
    if (![BXLiveUser isLogin]) {
//        [BXCodeLoginVC toLoginViewControllerWithNav:[[UIApplication sharedApplication] activityViewController].navigationController];
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":[UIApplication sharedApplication].activityViewController.navigationController}];
        return;
    }
    
    _video.treasure_chest = @"0";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidOpenTreasureChestNotification" object:nil userInfo:@{@"videoId":_video.movieID}];
    [self removeTreasureChestView];
    
    [NewHttpManager inspectionTreasureChestWithVideoId:_video.movieID success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            BXTreasureChestDetailView *detailView = [[BXTreasureChestDetailView alloc]initWithVideoId:self.video.movieID];
            [detailView show];
        } else {
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD showInfoWithMessage:@"宝箱飞走咯~"];
    }];
}

- (void)showCoverURL:(NSString *)coverUrl scalingMode:(NSInteger)scalingMode{
    [self resetControlView];
    _coverIv.contentMode = scalingMode;
    [_coverIv yy_setImageWithURL:[NSURL URLWithString:coverUrl] placeholder:nil];
    _state = -1;
}

- (void)setVideo:(BXHMovieModel *)video {
    if (_video) {
        _video.didFinishedLayout = nil;
        [BXReportVideoManager addWatchHistoryWithVideoId:_video.movieID startTime:[NSString stringWithFormat:@"%ld",_start_time] duration:[NSString stringWithFormat:@"%ld",_duration]];
    }
    
    BOOL isDisPlayRewardTopThreeView = NO;
    if (video.rewardUsers.count) {
        if (![video isEqual:_video]) {
            [self removeRewardTopThreeView];
            isDisPlayRewardTopThreeView = YES;
        }
    } else {
        [self removeRewardTopThreeView];
    }
    
    BOOL isDisPlayTreasureChestView = NO;
    if ([video.treasure_chest integerValue]) {
        isDisPlayTreasureChestView = YES;
    } else {
        [self removeTreasureChestView];
    }
    
    _video = video;
    
    if (isDisPlayRewardTopThreeView) {
        [self updateRewardTopThreeViewWithVideo:video];
    }
    if (isDisPlayTreasureChestView) {
        [self updateTreasureChestView];
    }
    
    WS(ws);
    _video.didFinishedLayout = ^{
        if (isDisPlayTreasureChestView) {
            [ws updateTreasureChestView];
        }
        if (isDisPlayRewardTopThreeView) {
            [ws updateRewardTopThreeViewWithVideo:video];
        }
    };

    _start_time = [TimeHelper getTimeSp] * 1000;
}

- (void)updateRewardTopThreeViewWithVideo:(BXHMovieModel *)video {
    if (!video.bottomSpace) {
        return;
    }
    if (!_rewardTopThreeView) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeRewardTopThreeView) object:nil];
        
        _rewardTopThreeView = [[BXRewardTopThreeView alloc]init];
        _rewardTopThreeView.liveUsers = video.rewardUsers;
        _rewardTopThreeView.videoId = video.movieID;
        [self addSubview:_rewardTopThreeView];
        [self setAnchorPoint:CGPointMake(0, 1.0) forView:_rewardTopThreeView];
        [_rewardTopThreeView startAnimation];
        
        [self performSelector:@selector(removeRewardTopThreeView) withObject:nil afterDelay:5.4];
    }
    CGFloat width = 122;
    if (video.rewardUsers.count == 1) {
        width = 63;
    } else if (video.rewardUsers.count == 2) {
        width = 94;
    }
    _rewardTopThreeView.frame = CGRectMake(56, video.bottomSpace - 42, width, 52);
}

- (void)updateTreasureChestView {
    if (!_video.bottomSpace) {
        return;
    }
    
    if (!_treasureChestView) {
        _treasureChestView = [LOTAnimationView animationNamed:@"treasureChest"];
        _treasureChestView.contentMode = UIViewContentModeScaleAspectFit;
        _treasureChestView.autoReverseAnimation = YES;
        _treasureChestView.loopAnimation = YES;
        [self addSubview:_treasureChestView];
        [_treasureChestView play];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(treasureChestAction)];
        [_treasureChestView addGestureRecognizer:tap];
    }

    CGFloat initialY =  64 + __kTopAddHeight;
    CGFloat space = _video.bottomSpace - initialY;
    CGFloat w = 111 / 2.0;
    CGFloat h = 97 / 2.0;
    CGFloat y = space / 3 - h / 2 + initialY;
    _treasureChestView.frame = CGRectMake(16, y, w, h);
}

- (void)removeTreasureChestView {
    if (_treasureChestView) {
        [_treasureChestView removeFromSuperview];
        _treasureChestView = nil;
    }
}

- (void)removeRewardTopThreeView {
    if (_rewardTopThreeView) {
        [_rewardTopThreeView removeFromSuperview];
        _rewardTopThreeView = nil;
    }
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGRect oldFrame = view.frame;
    view.layer.anchorPoint = anchorPoint;
    view.frame = oldFrame;
}

- (void)resetControlView {
    _progressView.progress = 0;
    _LineprogressView.progress = 0;
    _slider.value = _progressView.progress;
    _videoLoadingView.hidden = YES;
    _playIv.hidden = YES;
    _failView.hidden = YES;
    _slider.hidden = YES;
}

//连击爱心动画
- (void)showLikeViewAnim:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint {
    if ([BXLiveUser isLogin]) {
        if (_likeAction) {
            _likeAction();
        }
    }

    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_like_after"]];
    likeImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat k = ((oldPoint.y - newPoint.y)/(oldPoint.x - newPoint.x));
    k = fabs(k) < 0.5 ? k : (k > 0 ? 0.5f : -0.5f);
    CGFloat angle = M_PI_4 * -k;
    likeImageView.frame = CGRectMake(newPoint.x, newPoint.y, 80, 80);
    likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 0.8f, 1.8f);
    [self addSubview:likeImageView];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 1.0f, 1.0f);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5f
                                               delay:0.5f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 3.0f, 3.0f);
                                              likeImageView.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished) {
                                              [likeImageView removeFromSuperview];
                                          }];
                     }];
}

- (void)postPlayStateNotification:(NSInteger)state {
    if (_video) {
        if (state == 1 && _player.currentPlayerManager.playState != ZFPlayerPlayStatePlaying) {
            return;
        }
        
        if (_state != state) {
            if (_video.movieID == nil) {
                _video.movieID = @"";
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kVideoPlayStateNotification object:nil userInfo:@{@"videoId":_video.movieID, @"state":[NSString stringWithFormat:@"%ld",state]}];
            _state = state;
        }
    }
}

- (void)hiddenVolumProgressView {
    _volumProgressView.hidden = YES;
}

- (void)dealloc {
    if (_video) {
        [BXReportVideoManager addWatchHistoryWithVideoId:_video.movieID startTime:[NSString stringWithFormat:@"%ld",_start_time] duration:[NSString stringWithFormat:@"%ld",_duration]];
    }
    [_videoLoadingView removeObserver:self forKeyPath:@"hidden"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma - mark ZFPlayerMediaContro
- (void)setPlayer:(ZFPlayerController *)player {
    _player = player;
    if (!_coverIv) {
        _coverIv = [[UIImageView alloc] init];
        _coverIv.userInteractionEnabled = YES;
        _coverIv.contentMode = UIViewContentModeScaleAspectFit;
        _coverIv.clipsToBounds = YES;
    }
    [player.currentPlayerManager.view insertSubview:_coverIv atIndex:0];
    _coverIv.frame = player.currentPlayerManager.view.bounds;
}

- (BOOL)gestureTriggerCondition:(ZFPlayerGestureControl *)gestureControl gestureType:(ZFPlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(nonnull UITouch *)touch {
    if (gestureType == ZFPlayerGestureTypeSingleTap) {
        return YES;
    }
    return NO;
}

- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    //获取点击坐标，用于设置爱心显示位置
    CGPoint point = [gestureControl.singleTap locationInView:self];
    //获取当前时间
    NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    //判断当前点击时间与上次点击时间的时间间隔
    if(time - _lastTapTime > 0.25f) {
        //推迟0.25秒执行单击方法
        [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
    }else {
        //取消执行单击方法
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
        //执行连击显示爱心的方法
        [self showLikeViewAnim:point oldPoint:_lastTapPoint];
    }
    //更新上一次点击位置
    _lastTapPoint = point;
    //更新上一次点击时间
    _lastTapTime =  time;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer playStateChanged:(ZFPlayerPlaybackState)state {
    if (state == ZFPlayerPlayStatePlaying) {
        _playIv.hidden = YES;
        _failView.hidden = YES;
        // 开始播放时候判断是否显示loading
        if (videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStateStalled || videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStatePrepare) {
            _videoLoadingView.hidden = NO;
        }
        
        [self postPlayStateNotification:1];
    } else if (state == ZFPlayerPlayStatePaused) {
        _playIv.hidden = NO;
        _failView.hidden = YES;
        _videoLoadingView.hidden = YES;
        
        [self postPlayStateNotification:0];
    } else if (state == ZFPlayerPlayStatePlayFailed) {
        _playIv.hidden = YES;
        _slider.hidden = YES;
        _failView.hidden = NO;
        _videoLoadingView.hidden = YES;
        
        [self postPlayStateNotification:0];
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:( ZFPlayerLoadState)state {
    if (state == ZFPlayerLoadStatePrepare) {
        self.coverIv.alpha = 1.0;
    } else if (state == ZFPlayerLoadStatePlaythroughOK) {
        [UIView animateWithDuration:2.0 animations:^{
            self.coverIv.alpha = 0.0;
        }];
    }
    if ((state == ZFPlayerLoadStateStalled || state == ZFPlayerLoadStatePrepare) && videoPlayer.currentPlayerManager.isPlaying) {
        _videoLoadingView.hidden = NO;
        [self postPlayStateNotification:0];
    } else {
        _videoLoadingView.hidden = YES;
        [self postPlayStateNotification:1];
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    _progressView.progress = videoPlayer.progress;
    _LineprogressView.progress = videoPlayer.progress;
    if (!_slider.ds_Tag) {
        self.slider.value = self.progressView.progress;
    }
    _duration = roundf(videoPlayer.currentTime * 1000);
}

#pragma - mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSNumber *now = change[@"new"];
    if (self.type == 2 || self.type == 1) {
        _LineprogressView.hidden = ![now boolValue];
    }else{
        _progressView.hidden = ![now boolValue];
    }
}

#pragma - mark NSNotification
- (void)volumeDidChange:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *explicitVolumeChange = info[@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"];
    if (IsEquallString(explicitVolumeChange, @"ExplicitVolumeChange")) {
        NSNumber *volum = info[@"AVSystemController_AudioVolumeNotificationParameter"];
        if (volum) {
            if (!_volumeView) {
                _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, -100, 1, 1)];
                _volumeView.hidden = NO;
                [_volumeView setShowsRouteButton:YES];
                [_volumeView setFrame:CGRectMake(-500, -200, 40, 40)];
                [_volumeView setShowsVolumeSlider:YES];
                [self addSubview: _volumeView];
            }
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenVolumProgressView) object:nil];
            _volumProgressView.hidden = NO;
            _volumProgressView.progress = [volum floatValue];
            
            CGFloat afterDelay = 1.5;
            if (!_volumProgressView.progress) {
                afterDelay = .5;
            }
            [self performSelector:@selector(hiddenVolumProgressView) withObject:nil afterDelay:afterDelay];
        }
    }
}


- (void)baseVideoPlayVCViewAppearState:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *state = info[@"state"];
    if ([state integerValue] == 1) {
        if (!_volumeView) {
            _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, -100, 1, 1)];
            [self addSubview: _volumeView];
        }
    } else {
        if (_volumeView) {
            [_volumeView removeFromSuperview];
            _volumeView = nil;
        }
    }
}

- (void)videoRewardUsersChanged:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *videoId = info[@"videoId"];
    if ([videoId integerValue] == [_video.movieID integerValue]) {
        if (_video.rewardUsers.count) {
            [self removeRewardTopThreeView];
            [self updateRewardTopThreeViewWithVideo:_video];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

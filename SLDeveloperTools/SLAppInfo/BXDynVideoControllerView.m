//
//  BXDynVideoControllerView.m
//  BXlive
//
//  Created by mac on 2020/8/15.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynVideoControllerView.h"
#import <ZFPlayer/UIView+ZFFrame.h>
#import <ZFPlayer/UIImageView+ZFCache.h>
#import <ZFPlayer/ZFUtilities.h>
#import "BXVideoLoadingView.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import <YYWebImage/YYWebImage.h>


@interface BXDynVideoControllerView ()

/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;


@end

@implementation BXDynVideoControllerView
@synthesize player = _player;

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _progressView = [[BXProgressView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 1.5)];
        [self addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1.5);
            make.bottom.mas_equalTo(0);
        }];
        [self resetControlView];
        
    }
    return self;
}
- (void)setPlayer:(ZFPlayerController *)player {
    _player = player;
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.clipsToBounds = YES;
    }
    [player.currentPlayerManager.view insertSubview:_coverImageView atIndex:0];
    _coverImageView.frame = player.currentPlayerManager.view.bounds;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.player.currentPlayerManager.view.bounds;

}

- (void)showCoverURLString:(NSString *)coverUrl scalingMode:(NSInteger)scalingMode{
    [self resetControlView];
    self.coverImageView.contentMode = scalingMode;
    [self.coverImageView yy_setImageWithURL:[NSURL URLWithString:coverUrl] placeholder:nil];
}

- (void)resetControlView {
    _progressView.progress = 0;
}
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    _progressView.progress = currentTime*1.0f/totalTime;
    
}
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:( ZFPlayerLoadState)state {
    if (state == ZFPlayerLoadStatePrepare) {
        self.coverImageView.alpha = 1.0;
    } else if (state == ZFPlayerLoadStatePlaythroughOK) {
        [UIView animateWithDuration:2.0 animations:^{
            self.coverImageView.alpha = 0.0;
        }];
    }
    
}

@end

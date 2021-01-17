//
//  BXNormalControllView.m
//  BXlive
//
//  Created by bxlive on 2019/5/16.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXNormalControllView.h"
#import <ZFPlayer/ZFPlayer.h>
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "BXVideoLoadingView.h"
#import <YYWebImage/YYWebImage.h>

@interface BXNormalControllView ()

/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;


@end

@implementation BXNormalControllView
@synthesize player = _player;

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _progressView = [[BXProgressView alloc]initWithFrame:CGRectMake(0, 0, __kWidth/2, 1.5)];
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

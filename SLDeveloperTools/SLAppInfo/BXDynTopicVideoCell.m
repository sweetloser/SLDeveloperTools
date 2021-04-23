//
//  BXDynTopicVideoCell.m
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTopicVideoCell.h"
#import <YYText/YYText.h>
#import <YYImage/YYImage.h>
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>
#import <SLDeveloperTools/SLDeveloperTools.h>

@interface BXDynTopicVideoCell ()

@property (strong, nonatomic) UIImageView *coverIv;
@property (strong, nonatomic) UILabel *playCountLb;

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation BXDynTopicVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverIv = [[YYAnimatedImageView alloc]init];
        _coverIv.contentMode = UIViewContentModeScaleAspectFill;
        _coverIv.layer.cornerRadius = 2;
        _coverIv.layer.masksToBounds = YES;
        [self.contentView addSubview:_coverIv];
        [_coverIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.opacity = .4;
        _gradientLayer.colors = @[(__bridge id)CHHCOLOR(0x000000, 0).CGColor, (__bridge id)CHHCOLOR_D(0x000000).CGColor];
        [_coverIv.layer addSublayer:_gradientLayer];
        
        UIImageView *playIconIv = [[UIImageView alloc]init];
        playIconIv.image = CImage(@"video_play");
        [self.contentView addSubview:playIconIv];
        [playIconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        _playCountLb = [[UILabel alloc]init];
        _playCountLb.textColor = [UIColor whiteColor];
        _playCountLb.font = CFont(12);
        [self.contentView addSubview:_playCountLb];
        [_playCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(playIconIv);
            make.left.mas_equalTo(playIconIv.mas_right).offset(4);
            make.width.mas_lessThanOrEqualTo(75);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _gradientLayer.frame = CGRectMake(0, self.height - 100, self.width, 100);
    [CATransaction commit];
}
-(void)setTopicModel:(BXDynTopicModel *)topicModel{
    
}
-(void)setCircleModel:(BXDynCircleModel *)circleModel{
    
}
-(void)setDynModel:(BXDynamicModel *)dynModel{
    [_coverIv yy_setImageWithURL:[NSURL URLWithString:dynModel.msgdetailmodel.cover_url] placeholder:CImage(@"video-placeholder")];
    [[BXYYImageCacheManager sharedCacheManager] addImageURLForKey:[NSURL URLWithString:dynModel.msgdetailmodel.cover_url]];
}
//- (void)setVideo:(BXHMovieModel *)video {
//    if (_video) {
//        [_coverIv yy_cancelCurrentImageRequest];
//    }
//    _video = video;
//
//
//    if (IsNilString(video.animate_url)) {
//        [_coverIv yy_setImageWithURL:[NSURL URLWithString:video.cover_url] placeholder:CImage(@"video-placeholder")];
//        [[BXYYImageCacheManager sharedCacheManager] addImageURLForKey:[NSURL URLWithString:video.cover_url]];
//    } else {
//        [_coverIv yy_setImageWithURL:[NSURL URLWithString:video.animate_url] placeholder:CImage(@"video-placeholder") options:YYWebImageOptionIgnoreDiskCache | YYWebImageOptionIgnoreImageDecoding completion:nil];
//        [[BXYYImageCacheManager sharedCacheManager] addImageURLForKey:[NSURL URLWithString:video.animate_url]];
//    }
//    _playCountLb.text = [NSString stringWithFormat:@"%@次播放",video.play_sum];
//}

@end

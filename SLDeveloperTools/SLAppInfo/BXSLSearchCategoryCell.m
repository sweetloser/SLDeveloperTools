//
//  BXSLSearchCategoryCell.m
//  BXlive
//
//  Created by bxlive on 2019/3/7.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchCategoryCell.h"
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import <YYWebImage/YYWebImage.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLUtilities/SLUtilities.h"

@interface BXSLSearchCategoryCell ()

@property (strong, nonatomic) UIImageView *coverIv;
@property (strong, nonatomic) YYLabel *titleLb;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@end

@implementation BXSLSearchCategoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverIv = [[YYAnimatedImageView alloc]init];
        _coverIv.layer.cornerRadius = 5;
        _coverIv.layer.masksToBounds = YES;
        _coverIv.contentMode = UIViewContentModeScaleAspectFill;
        _coverIv.backgroundColor = [UIColor sl_colorWithHex:0x121A1E];
        [self.contentView addSubview:_coverIv];
        [_coverIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        _titleLb = [[YYLabel alloc] init];
        _titleLb.font = SLBFont(__ScaleWidth(14));
        _titleLb.numberOfLines = 2;
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(8));
            make.right.mas_equalTo(-__ScaleWidth(8));
            make.bottom.mas_equalTo(__ScaleWidth(-8));
            make.height.mas_equalTo(__ScaleWidth(20));
        }];
        
//        渐变背景
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, frame.size.width,frame.size.height);
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithColor:sl_blackColors alpha:0.0].CGColor,(__bridge id)[UIColor colorWithColor:sl_blackColors alpha:0.3].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        _gradientLayer.locations = @[@0.68];
        [self.layer addSublayer:_gradientLayer];
        
        
    }
    return self;
}

- (void)setVideo:(BXHMovieModel *)video {
    _video = video;
    
    if (IsNilString(video.animate_url)) {
        [_coverIv yy_setImageWithURL:[NSURL URLWithString:video.cover_url] placeholder:CImage(@"video-placeholder")];
        [[BXYYImageCacheManager sharedCacheManager] addImageURLForKey:[NSURL URLWithString:video.cover_url]];
    } else {
        [_coverIv yy_setImageWithURL:[NSURL URLWithString:video.animate_url] placeholder:CImage(@"video-placeholder") options:YYWebImageOptionIgnoreDiskCache | YYWebImageOptionIgnoreImageDecoding completion:nil];
        [[BXYYImageCacheManager sharedCacheManager] addImageURLForKey:[NSURL URLWithString:video.animate_url]];
    }
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:video.describe];
    attri.yy_font = _titleLb.font;
    attri.yy_color = [UIColor whiteColor];
    attri.yy_lineSpacing = 5;
    _titleLb.attributedText = attri;
    
    CGFloat height = [self getAttributedTextHeightWithAttributedText:attri width:self.contentView.width - 16];
    [_titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (CGFloat)getAttributedTextHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width{
    YYTextContainer *container = [YYTextContainer new];
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.maximumNumberOfRows = 2;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    return layout.textBoundingSize.height;
}

@end

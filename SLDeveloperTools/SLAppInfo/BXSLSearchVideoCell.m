//
//  BXSLSearchVideoCell.m
//  BXlive
//
//  Created by bxlive on 2019/3/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchVideoCell.h"
//#import "BXPersonHomeVC.h"
#import <YYCategories/YYCategories.h>
#import <YYText/YYText.h>
#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>
#import <Masonry/Masonry.h>
#import "SLAppInfoConst.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLUtilities/SLUtilities.h"
#import <SDWebImage/SDWebImage.h>

@interface BXSLSearchVideoCell ()

@property (strong, nonatomic) UIImageView *coverIv;
@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, strong) UILabel *nameLb;
@property (strong, nonatomic) UILabel *likeCountLb;
@property (strong, nonatomic) YYLabel *titleLb;

@end

@implementation BXSLSearchVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _coverIv = [[YYAnimatedImageView alloc]init];
        _coverIv.layer.cornerRadius = 4;
        _coverIv.layer.masksToBounds = YES;
        _coverIv.backgroundColor = [UIColor sl_colorWithHex:0x121A1E];
        _coverIv.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_coverIv];
        [_coverIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        _avatarBtn = [[UIButton alloc]init];
        _avatarBtn.layer.cornerRadius = 10;
        _avatarBtn.layer.masksToBounds = YES;
        [_avatarBtn addTarget:self action:@selector(avatarAction) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:_avatarBtn];
        [_avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
            make.left.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
        
        _nameLb = [[UILabel alloc]init];
        _nameLb.textColor = [UIColor whiteColor];
        _nameLb.font = CFont(12);
        _nameLb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.avatarBtn);
            make.left.mas_equalTo(self.avatarBtn.mas_right).offset(4);
        }];
        
        _likeCountLb = [[UILabel alloc]init];
        _likeCountLb.textColor = [UIColor whiteColor];
        _likeCountLb.font = CFont(12);
        _likeCountLb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_likeCountLb];
        [_likeCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.nameLb);
            make.left.mas_equalTo(self.nameLb.mas_right).offset(5);
            make.right.mas_equalTo(-8);
        }];
        
        _titleLb = [[YYLabel alloc] init];
        _titleLb.font = CBFont(14);
        _titleLb.numberOfLines = 2;
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarBtn);
            make.right.mas_equalTo(self.likeCountLb);
            make.bottom.mas_equalTo(self.avatarBtn.mas_top).offset(-8);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)avatarAction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":_video.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:_video.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
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
    
    [_avatarBtn sd_setImageWithURL:[NSURL URLWithString:video.avatar] forState:BtnNormal placeholderImage:CImage(@"placeholder_avatar")];
    _nameLb.text = video.nickname;
    _likeCountLb.text = [NSString stringWithFormat:@"%@赞",video.zan_sum];
    
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

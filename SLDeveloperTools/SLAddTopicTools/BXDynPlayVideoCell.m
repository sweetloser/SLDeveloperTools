//
//  BXDynPlayVideoCell.m
//  BXlive
//
//  Created by mac on 2020/8/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynPlayVideoCell.h"
#import "BXVideoLoadingView.h"
#import <Lottie/Lottie.h>
#import "BXProgressView.h"
#import "BXFocusView.h"
//#import "SharePopViewManager.h"
#import "HMovieModel+DescribeAttri.h"
//#import "BXPersonHomeVC.h"
#import "BXSLCircleRippleView.h"
//#import "HHMoviePlayVC.h"
#import "BXVideoCoverView.h"
#import "BXLikeView.h"
#import "BXTwistingMachineView.h"
#import "BXActivityView.h"
#import "BaseWebVC.h"
#import "BXSLTwistingMachineVC.h"
#import "BXLocationDetailVC.h"
#import "BXMuisicAlbumView.h"
#import "BXTextScrollView.h"
//#import "BXRecordMusicVC.h"
#import <Aspects/Aspects.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <YYWebImage/YYWebImage.h>
#import "BXYYImageCacheManager.h"
//#import "SLStorePreViewVC.h"
//#import "SLPlayGoodsBuyVC.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
@interface BXDynPlayVideoCell ()

@property (strong, nonatomic) UIImageView *coverIv;


@property (strong, nonatomic) BXSLCircleRippleView *circleRippleView;

@property (strong, nonatomic) BXActivityView *activityView;

@property (assign, nonatomic) CGFloat bottomSpace;


@end

@implementation BXDynPlayVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        CGFloat bottomSpace = 49 + __kBottomAddHeight + 26;
        if (type == 1) {
            bottomSpace = __kBottomAddHeight + 26;
        } else if (type == 2) {
            bottomSpace = 15;
        }
        _bottomSpace = bottomSpace;
        
        _coverIv = [[BXVideoCoverView alloc]init];
        _coverIv.tag = 101;
        _coverIv.userInteractionEnabled = YES;
        [self.contentView addSubview:_coverIv];
        _coverIv.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

    }
    return self;
}

-(void)setVideo:(BXHMovieModel *)video{
    [_coverIv yy_setImageWithURL:[NSURL URLWithString:video.cover_url] placeholder:nil];
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

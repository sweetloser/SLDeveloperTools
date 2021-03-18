//
//  BXHotLiveFallsCell.m
//  BXlive
//
//  Created by bxlive on 2019/5/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "SLNearByLiveCell.h"
#import <Lottie/Lottie.h>
#import <YYCategories/YYCategories.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>
@interface SLNearByLiveCell ()
@property (nonatomic , strong) UIView * gradientView;
@property (nonatomic , strong) UIImageView * photoFrameView;
//@property (nonatomic , strong) UIImageView * backImageView;
@property (nonatomic , strong) UIImageView * bgImageView;
@property (nonatomic , strong) UILabel * lookNumberLabel;
@property (nonatomic , strong) UIImageView * lookNumberImgV;

@property (nonatomic , strong) UILabel * locationLabel;
@property (nonatomic , strong) UIImageView * locationImgV;

@property (nonatomic , strong) UIImageView * genderImgV;

@property (nonatomic, strong) LOTAnimationView *statusAnimation;//直播状态(直播中,json动画)
@property (nonatomic , strong) UIImageView * stautsImageView;//直播状态(休息中)

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SLNearByLiveCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //背景图
    self.contentView.layer.cornerRadius = 12.0;
    self.contentView.layer.masksToBounds = YES;
    
    
    self.gradientView = [[UIView alloc]initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.gradientView];
    CAGradientLayer *la = [[CAGradientLayer alloc]init];
    la.frame = self.gradientView.bounds;
    [self.gradientView.layer addSublayer:la];
    la.startPoint = CGPointMake(0.5, 1);
    la.endPoint = CGPointMake(0.5, 0);
    la.colors = @[(__bridge id)UIColorHex(EC5B62).CGColor,(__bridge id)UIColorHex(FDDC6A).CGColor];

    
    self.backImageView = [[UIImageView alloc]init];
    self.backImageView.userInteractionEnabled = YES;
    self.backImageView.backgroundColor = [UIColor clearColor];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.backImageView];
    self.backImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(3, 3, 3, 3));
    
    
    
    //背景渐变图
    self.bgImageView = [[UIImageView alloc]init];
    self.bgImageView.image = [UIImage imageNamed:@"icon_live_pallsBG_1"];
    self.bgImageView.userInteractionEnabled = YES;
    [self.backImageView addSubview:self.bgImageView];
    self.bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    //lc_home_hot_living_bg
    
    self.stautsImageView = [[UIImageView alloc]init];
        self.stautsImageView.image = [UIImage imageNamed:@"icon_live_xiuxi"];
        [self.backImageView addSubview:self.stautsImageView];
    //    self.stautsImageView.sd_layout.leftSpaceToView(self.backImageView, 10).topSpaceToView(self.backImageView, 12).widthIs(54).heightIs(18);
        self.stautsImageView.sd_layout.leftSpaceToView(self.backImageView, 0).topSpaceToView(self.backImageView, 0).widthIs(96).heightIs(23);
    
    //直播状态
    self.statusAnimation = [LOTAnimationView animationNamed:@"Live_status_new"];
    [self.stautsImageView addSubview:self.statusAnimation];
//    self.statusAnimation.sd_layout.leftSpaceToView(self.backImageView, 10).topSpaceToView(self.backImageView, 12).widthIs(54).heightIs(18);
    self.statusAnimation.sd_layout.leftSpaceToView(self.stautsImageView, 0).topSpaceToView(self.stautsImageView, 1).widthIs(67).heightIs(21);
    self.statusAnimation.contentMode =UIViewContentModeScaleToFill;
    self.statusAnimation.loopAnimation =YES;//是否循环动画
    [self.statusAnimation play];//开始动画
    
    //观看人数
    self.lookNumberLabel = [UILabel initWithFrame:CGRectZero size:20 color:[UIColor sl_colorWithHex:0xF8F8F8 alpha:0.8] alignment:NSTextAlignmentRight lines:1];
    [self.contentView addSubview:self.lookNumberLabel];
    
    [self.lookNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-10));
        make.top.mas_equalTo(__ScaleWidth(5));
        make.height.mas_equalTo(__ScaleWidth(20));
        make.width.mas_equalTo(__ScaleWidth(50));
    }];
    WS(weakSelf);
    self.lookNumberImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.lookNumberImgV setImage: [UIImage imageNamed:@"nearby_look"]];
    [self.contentView addSubview:self.lookNumberImgV];
    [self.lookNumberImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.lookNumberLabel.mas_left).offset(__ScaleWidth(-5));
        make.centerY.equalTo(weakSelf.lookNumberLabel);
        make.width.mas_equalTo((16));
        make.height.mas_equalTo((15));
    }];
    
    
    self.titleLabel = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"" Font:SLPFFont(__ScaleWidth(14)) TextColor:sl_whiteTextColors];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(8));
        make.height.mas_equalTo(__ScaleWidth(20));
        make.width.mas_lessThanOrEqualTo(__ScaleWidth(56));
        make.bottom.mas_equalTo(__ScaleWidth(-5));
    }];
    
    
//    性别
    self.genderImgV = [UIImageView new];
    [self.contentView addSubview:self.genderImgV];
    [self.genderImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(__ScaleWidth(5));
        make.width.height.mas_equalTo(__ScaleWidth(16));
        make.bottom.mas_equalTo(__ScaleWidth(-6));
    }];
    
    self.locationLabel = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"未知" Font:[UIFont fontWithName:@"DINAlternate-Bold" size:18] TextColor:[UIColor sl_colorWithHex:0xF8F8F8 alpha:0.8]];
    [self.contentView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-10));
        make.bottom.mas_equalTo(__ScaleWidth(-5));
        make.height.mas_equalTo(__ScaleWidth(21));
        make.width.mas_equalTo(__ScaleWidth(50));
    }];
    
    self.locationImgV = [UIImageView new];
    [self.contentView addSubview:self.locationImgV];
    [self.locationImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.locationLabel.mas_left).offset(__ScaleWidth(-5));
        make.centerY.equalTo(weakSelf.locationLabel);
        make.width.mas_equalTo(13);
        make.width.mas_equalTo(15);
    }];
    [self.locationImgV setImage: [UIImage imageNamed:@"nearby_location"]];
    
    
    self.lookNumberLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    
    [self.backImageView sd_addSubviews:@[self.lookNumberLabel]];
    
//    self.lookNumberLabel.sd_layout.rightSpaceToView(self.backImageView, __ScaleWidth(10)).topSpaceToView(self, __ScaleWidth(5)).widthIs(50).heightIs(__ScaleWidth(21));
    
//    self.levelImageView.sd_layout.leftSpaceToView(self.backImageView, 8).bottomSpaceToView(self.backImageView, 12).widthIs(30).heightIs(14);
//    self.addressLabel.sd_layout.leftSpaceToView(self.backImageView, 41).bottomSpaceToView(self.backImageView, 12).widthIs(50).heightIs(12);
//    self.titleLabel.sd_layout.leftSpaceToView(self.backImageView, 10).bottomSpaceToView(self.backImageView, 26).rightSpaceToView(self.backImageView, 0).heightIs(20);
    
    
    
    self.photoFrameView = [UIImageView new];
    self.photoFrameView.image = CImage(@"icon_live_photFrame");
    [self.contentView addSubview:self.photoFrameView];
    self.photoFrameView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).widthIs(30).heightIs(45);
    
    
}

- (void)setLiveRoom:(BXSLLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",liveRoom.cover_url]] placeholderImage:[UIImage imageNamed:@"movie-bitmap"]];
    self.lookNumberLabel.text = [NSString stringWithFormat:@"%@",liveRoom.audience];
    CGFloat lookNumW = [UILabel getWidthWithTitle:self.lookNumberLabel.text font:self.lookNumberLabel.font];
    [self.lookNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(lookNumW+__ScaleWidth(5));
    }];
    self.genderImgV.hidden = NO;
    if ([liveRoom.gender intValue] == 1) {
        [self.genderImgV setImage:CImage(@"male_no_age")];
    }else if ([liveRoom.gender intValue] == 2){
        [self.genderImgV setImage:CImage(@"female_no_age")];
    }else if([liveRoom.gender intValue] == 0){
        self.genderImgV.hidden = YES;
    }
    self.titleLabel.text = liveRoom.title;
    if ([liveRoom.distance intValue] < 0) {
        self.locationLabel.text = @"未知";
    }else if ([liveRoom.distance intValue] < 1000) {
          self.locationLabel.text = [NSString stringWithFormat:@"%@M",liveRoom.distance];
     } else {
         self.locationLabel.text = [NSString stringWithFormat:@"%.1fKM",[liveRoom.distance intValue] / 1000.0];
    }

    CGFloat locationLabelW = [UILabel getWidthWithTitle:self.locationLabel.text font:self.lookNumberLabel.font];
    [self.locationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(locationLabelW+__ScaleWidth(5));
    }];
    
    if ([liveRoom.is_living integerValue] == 0) {
        self.statusAnimation.hidden = YES;
        self.stautsImageView.hidden = NO;
    }else{
        
        
        //0普通，1私密、2收费、3计费、4VIP  5导购  6 PK   7关注的主播  8热门主播  9魅力主播 icon_live_pallsBG_1
        switch ([liveRoom.type integerValue]) {
            case 0:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_living_bg"];
                break;
            case 1:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_type_secret"];
                break;
            case 2:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_type_money"];
                break;
            case 3:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_type_price"];
                break;
            case 4:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_type_vip"];
                break;
            case 5:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_type_daogou"];
                break;
            case 6:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_type_pk"];
                break;
            case 7:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_type_attend"];
                break;
            case 8:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_type_hot"];
                break;
            case 9:
                self.stautsImageView.image = [UIImage imageNamed:@"lc_home_hot_type_charm"];
                break;
                
            default:
                break;
        }
        if ([liveRoom.type integerValue] == 0) {
            self.statusAnimation.hidden = NO;
        }else{
            self.statusAnimation.hidden = YES;
        }
        
        self.stautsImageView.hidden = NO;
    }
    
    
    if (IsNilString(liveRoom.photo_frame)) {
        self.gradientView.hidden = YES;
        self.photoFrameView.hidden = YES;
        self.bgImageView.image = CImage(@"icon_live_pallsBG");
        self.backImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }else{
       self.gradientView.hidden = NO;
       self.photoFrameView.hidden = NO;
       [self.photoFrameView sd_setImageWithURL:[NSURL URLWithString:liveRoom.photo_frame] placeholderImage:nil];
        self.bgImageView.image = CImage(@"icon_live_pallsBG_1");
        self.backImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(3, 3, 3, 3));
    }
    
}

@end

//
//  SLDaemonListHeadGiftView.m
//  BXlive
//
//  Created by sweetloser on 2020/8/11.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLDaemonListHeadGiftView.h"
#import "SLDeveloperTools.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import <YYWebImage/YYWebImage.h>


@interface SLDaemonListHeadGiftView()

@property(nonatomic,strong)UILabel *giftTitleL;
@property(nonatomic,strong)UIImageView *giftImgV;
@property(nonatomic,strong)UILabel *giftPriceL;
@property(nonatomic,strong)UIButton *buyBtn;

@end
@implementation SLDaemonListHeadGiftView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _giftImgV = [[UIImageView alloc]init];
        [self addSubview:_giftImgV];
        _giftImgV.layer.cornerRadius = 3.0;
        _giftImgV.layer.masksToBounds = YES;
        _giftImgV.backgroundColor = UIColorHex(#F5F9FC);
        
        [_giftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.mas_top).offset(12);
            make.width.height.mas_equalTo(__GenScaleWidth(60));
        }];
        
        UIImageView *secondicon = [[UIImageView alloc]init];
        [self addSubview:secondicon];
        secondicon.image = [UIImage imageNamed:@"lc_live_guard_icon"];
        
        [secondicon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_giftImgV.mas_bottom);
            make.left.mas_equalTo(_giftImgV.mas_right).offset(-__GenScaleWidth(45/2.0*0.6));
            make.height.mas_equalTo(__GenScaleWidth(55*0.6));
            make.width.mas_equalTo(__GenScaleWidth(45*0.6));
        }];
        _giftTitleL = [[UILabel alloc]init];
        [self addSubview:_giftTitleL];
        _giftTitleL.font = SLPFFont(12);
        _giftTitleL.textColor = sl_textColors;
        _giftTitleL.textAlignment = NSTextAlignmentCenter;
        
        _giftTitleL.text = @"可爱小马驹";
        [_giftTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_giftImgV);
            make.top.mas_equalTo(_giftImgV.mas_bottom).offset(8);
            make.height.mas_equalTo(17);
        }];
        
        _giftPriceL = [[UILabel alloc]init];
        [self addSubview:_giftPriceL];
        _giftPriceL.font = SLPFFont(12);
        _giftPriceL.textColor = sl_textColors;
        _giftPriceL.textAlignment = NSTextAlignmentCenter;
        
        _giftPriceL.text = @"1314钻石";
        [_giftPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_giftTitleL);
            make.top.mas_equalTo(_giftTitleL.mas_bottom).offset(5);
            make.height.mas_equalTo(17);
        }];
        
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_buyBtn];
        _buyBtn.titleLabel.font = SLPFFont(12);
        [_buyBtn  addTarget:self action:@selector(buy) forControlEvents:BtnTouchUpInside];
        [_buyBtn setBackgroundImage:[UIImage imageNamed:@"live_guard_buyBtn"] forState:BtnNormal];
        [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_giftImgV);
            make.top.mas_equalTo(_giftPriceL.mas_bottom).offset(12);
            make.width.mas_equalTo(74);
            make.height.mas_equalTo(24);
        }];
    }
    
    return self;
}

-(void)buy{
    if (self.buyBtnOnClickBlock) {
        self.buyBtnOnClickBlock();
    }
}

-(void)updateUIForModel:(BXGift *)model;{
    
    [self.giftImgV yy_setImageWithURL:[NSURL URLWithString:model.picture_url] placeholder:[UIImage imageNamed:@"placeholder_liwu_55"]];
    self.giftTitleL.text = model.name;
    self.giftPriceL.text = [NSString stringWithFormat:@"%@%@", model.price,BXAppInfo.appInfo.app_millet_unit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

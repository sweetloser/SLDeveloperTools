//
//  SLDaemonFirstThreeView.m
//  BXlive
//
//  Created by sweetloser on 2020/8/11.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLDaemonFirstThreeView.h"
#import "BXDaemonListModel.h"
//#import "BXPersonHomeVC.h"
#import "SLDeveloperTools.h"
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>
#import <YYCategories/YYCategories.h>


@interface SLDaemonFirstThreeView()

@property(nonatomic,strong)UIImageView *bgImgV;
@property(nonatomic,strong)UIImageView *avatarImgV;
@property(nonatomic,strong)UILabel *nickNameL;
@property(nonatomic,strong)UIImageView *levelImgV;
@property(nonatomic,strong)UIImageView *ageImgV;

@property(nonatomic,strong)UILabel *giftPriceL;

@property(nonatomic,assign)CGFloat ratio;

@end

@implementation SLDaemonFirstThreeView

-(instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.ratio = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 375.f;
        
        self.bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lc_live_guard_title"]];
        [self addSubview:self.bgImgV];
        WS(weakSelf);
        [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            if (type == 0) {
                make.width.mas_equalTo(self.ratio*(62));
                make.height.mas_equalTo(self.ratio*(75));
            }else{
                make.width.mas_equalTo(self.ratio*(44.1));
                make.height.mas_equalTo(self.ratio*(54.1));
            }
        }];
        self.avatarImgV = [UIImageView new];
        [self addSubview:self.avatarImgV];
        [self.avatarImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.equalTo(weakSelf.bgImgV).offset(self.ratio*(0));
            if (type == 0) {
                make.width.mas_equalTo(self.ratio*(56));
                make.height.mas_equalTo(self.ratio*(56));
            }else{
                make.width.mas_equalTo(self.ratio*(40));
                make.height.mas_equalTo(self.ratio*(40));
            }
        }];
        self.avatarImgV.layer.masksToBounds = YES;
        self.avatarImgV.layer.cornerRadius = type==0?self.ratio*(56/2) : self.ratio*(40/2);
        
        self.nickNameL = [UILabel  createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"潮流服饰" Font:SLBFont(self.ratio*(14)) TextColor:sl_textColors];
        [self addSubview:self.nickNameL];
        [self.nickNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(weakSelf.bgImgV.mas_bottom).offset(self.ratio*(5));
            make.height.mas_equalTo(self.ratio*(20));
        }];
        self.nickNameL.textAlignment = 1;
        
        self.levelImgV = [UIImageView new];
        [self addSubview: self.levelImgV];
        [self.levelImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-self.ratio*(13.5+2.5));
            make.width.mas_equalTo(self.ratio*(27));
            make.height.mas_equalTo(self.ratio*(13));
            make.top.equalTo(weakSelf.nickNameL.mas_bottom).offset(self.ratio*(6));
        }];
        self.ageImgV = [UIImageView new];
        [self addSubview:self.ageImgV];
        [self.ageImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.ratio*(13/2.0+2.5));
            make.height.top.equalTo(weakSelf.levelImgV);
            make.width.mas_equalTo(self.ratio*(13));
        }];
//        [self.ageImgV setBackgroundColor:[UIColor randomColor]];
        
        [self bringSubviewToFront:self.bgImgV];
        
        _giftPriceL = [[UILabel alloc]init];
        [self addSubview:_giftPriceL];
        _giftPriceL.font = SLPFFont(12);
        _giftPriceL.textColor = sl_textColors;
        _giftPriceL.textAlignment = NSTextAlignmentCenter;
        
        _giftPriceL.text = @"1314钻石";
        [_giftPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_nickNameL);
            make.top.mas_equalTo(_ageImgV.mas_bottom).offset(5);
            make.height.mas_equalTo(17);
        }];
        

        
    }
    return self;
}

-(void)updateUIWithModel:(nullable BXDaemonListModel *)model;{
    [self.avatarImgV yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"placeholder_guard_82"]];
    self.nickNameL.text = model.nickname;
    NSString *price = [NSString stringWithFormat:@"%@", model.user_millet];
    if (IsNilString(price)) {
        self.giftPriceL.text = @"";
    }else{
        self.giftPriceL.text = [NSString stringWithFormat:@"%@钻石", model.user_millet];
    }
    [self.levelImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level_%@",model.level]]];
    [self.levelImgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-self.ratio*(13.5+2.5));
    }];
    [self.ageImgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ratio*(13/2.0+2.5));
    }];
    self.ageImgV.hidden = NO;
    if ([model.gender intValue] == 0) {
        self.ageImgV.hidden = YES;
        [self.levelImgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
        }];
    }else if ([model.gender intValue] == 1) {
        [self.ageImgV setImage:CImage(@"male_no_age")];
    }else if([model.gender intValue] == 2) {
        [self.ageImgV setImage:CImage(@"female_no_age")];
    }
    if (!model) {
        self.avatarImgV.image = CImage(@"placeholder_guard_82");
        self.nickNameL.text = @"暂无";
    }
    else{
        UITapGestureRecognizer *fVtap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":model.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
//            [BXPersonHomeVC toPersonHomeWithUserId:model.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
        }];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:fVtap];
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

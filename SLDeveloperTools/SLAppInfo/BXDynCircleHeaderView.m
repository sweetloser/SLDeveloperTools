//
//  BXDynCircleHeaderView.m
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleHeaderView.h"
#import "HttpMakeFriendRequest.h"
#import "AttentionAlertView.h"
//#import "BXPersonHomeVC.h"
#import <YYCategories/YYCategories.h>
#import "SLAppInfoMacro.h"
#import "SLAppInfoConst.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface BXDynCircleHeaderView()
@property(nonatomic, strong)UILabel *cirlceTitleLabel;
@property(nonatomic, strong)UIImageView *coverImageView;
@property(nonatomic, strong)UIImageView *BigHeaderImageView;
@property(nonatomic, strong)UILabel *CirlceNumLabel;
@property(nonatomic, strong)UIButton *attentionBtn;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UIImageView *AuthorHeaderImageView;
@property(nonatomic, strong)UILabel *authorNameLabel;

@property(nonatomic, strong)UIView *hazyView;

@end
@implementation BXDynCircleHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    _coverImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _coverImageView.contentMode=UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds=YES;
    _coverImageView.backgroundColor = SLClearColor;
    [self addSubview:_coverImageView];
    
    _hazyView = [[UIView alloc]initWithFrame:self.bounds];
    _hazyView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.3];
    [self addSubview:_hazyView];

    
    _BigHeaderImageView = [[UIImageView alloc]init];
    _BigHeaderImageView.layer.masksToBounds = YES;
    _BigHeaderImageView.layer.cornerRadius = 5;
    [self addSubview:_BigHeaderImageView];
    [_BigHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.top.mas_equalTo(self.mas_top).offset(70+__kTopAddHeight);
        make.width.height.mas_equalTo(__ScaleWidth(76));
    }];
    
    _cirlceTitleLabel = [[UILabel alloc]init];
    _cirlceTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    _cirlceTitleLabel.textColor = [UIColor whiteColor];
    _cirlceTitleLabel.textAlignment = 0;
    [self addSubview:_cirlceTitleLabel];
    [_cirlceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.BigHeaderImageView.mas_right).offset(14);
        make.top.mas_equalTo(self.mas_top).offset(84+__kTopAddHeight);
        make.right.mas_equalTo(self.right).offset(-90);
        make.height.mas_equalTo(25);
    }];
    
    _CirlceNumLabel = [[UILabel alloc]init];
    _CirlceNumLabel.textColor = [UIColor whiteColor];
    _CirlceNumLabel.font = [UIFont systemFontOfSize:12];
    _CirlceNumLabel.textAlignment = 0;
    [self addSubview:_CirlceNumLabel];
    [_CirlceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(self.BigHeaderImageView.mas_right).offset(19);
        make.top.mas_equalTo(self.cirlceTitleLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:12];
    _contentLabel.textAlignment = 0;
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.top.mas_equalTo(self.BigHeaderImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(40);
    }];
    
    UIView *AuthorBackView = [[UIView alloc]init];
    AuthorBackView.backgroundColor = UIColorHex(#000000);
    AuthorBackView.alpha = 0.3;
    AuthorBackView.layer.cornerRadius = 5;
    AuthorBackView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PersonHomeAct)];
    [AuthorBackView addGestureRecognizer:tap];
    AuthorBackView.userInteractionEnabled = YES;
    [self addSubview:AuthorBackView];
    [AuthorBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(54);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
    }];
    
    _AuthorHeaderImageView = [[UIImageView alloc]init];
    _AuthorHeaderImageView.layer.masksToBounds = YES;
    _AuthorHeaderImageView.layer.cornerRadius = 19;
    [self addSubview:_AuthorHeaderImageView];
    [_AuthorHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(27);
        make.centerY.mas_equalTo(AuthorBackView.mas_centerY);
        make.width.height.mas_equalTo(38);
    }];
    
    _authorNameLabel = [[UILabel alloc]init];
    _authorNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    _authorNameLabel.text = @"创始者";
    _authorNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_authorNameLabel];
    [_authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.AuthorHeaderImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(self.AuthorHeaderImageView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *rowImageView = [[UIImageView alloc]init];
    rowImageView.image = CImage(@"icon_dyn_more");
    [self addSubview:rowImageView];
    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-37);
        make.centerY.mas_equalTo(AuthorBackView.mas_centerY);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    
    _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_attentionBtn addTarget:self action:@selector(AttenAct) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_attentionBtn];
    [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.cirlceTitleLabel.mas_bottom);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(32);
    }];
    
    
    UIView *bottomview = [[UIView alloc]init];
    bottomview.backgroundColor = [UIColor whiteColor];
    bottomview.layer.masksToBounds = YES;
    bottomview.layer.cornerRadius = 10;

    [self addSubview:bottomview];
    [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    

}

-(void)setModel:(BXDynCircleModel *)model{
    _model = model;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",model.circle_background_img]] placeholderImage:CImage(@"video-placeholder")];
    [_BigHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",model.circle_cover_img]] placeholderImage:CImage(@"video-placeholder")];
    _cirlceTitleLabel.text = model.circle_name;
    _CirlceNumLabel.text = [NSString stringWithFormat:@"%@条动态", model.circilenums];
    _contentLabel.text = model.circle_describe;
    if ([[NSString stringWithFormat:@"%@", model.myfollow] isEqualToString:@"1"]) {
        [_attentionBtn setImage:CImage(@"icon_dyn_cirlce_attented") forState:UIControlStateNormal];

        [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicCircleFollowStatusNotification object:nil userInfo:@{@"circle_id":model.circle_id, @"extend_circlfollowed":@"1"}];
    }else{
        [_attentionBtn setImage:CImage(@"icon_dyn_cirlce_attent") forState:UIControlStateNormal];
         [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicCircleFollowStatusNotification object:nil userInfo:@{@"circle_id":model.circle_id, @"extend_circlfollowed":@"0"}];
    }
    if ([[NSString stringWithFormat:@"%@", model.ismy] isEqualToString:@"1"]) {
        _attentionBtn.hidden = YES;
    }else{
        _attentionBtn.hidden = NO;
    }
    [_AuthorHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"video-placeholder")];
}

-(void)setIsHiddenPart:(BOOL)isHiddenPart{
    if (isHiddenPart) {
        _attentionBtn.hidden = YES;
        _AuthorHeaderImageView.hidden = YES;
        _authorNameLabel.hidden = YES;
    }
    else{
        _attentionBtn.hidden = NO;
        _AuthorHeaderImageView.hidden = NO;
        _authorNameLabel.hidden = NO;
    }
}
-(void)AttenAct{
    NSString *myfollow = [NSString stringWithFormat:@"%@", self.model.myfollow];
    if ([myfollow isEqualToString:@"1"]) {
        AttentionAlertView *alert = [[AttentionAlertView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
        alert.DidClickBlock = ^{
            [self OperationAttention];
        };
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [alert showWithView:window];
    }else{
        [self OperationAttention];
    }
 

}
-(void)OperationAttention{
    WS(weakSelf);
     [HttpMakeFriendRequest FollowCircleWithcircle_id:self.model.circle_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
         if (flag) {
             NSString *datastr = [NSString stringWithFormat:@"%@", jsonDic[@"data"]];
             if ([datastr isEqualToString:@"1"]) {
                 [weakSelf.attentionBtn setImage:CImage(@"icon_dyn_cirlce_attented") forState:UIControlStateNormal];
                 weakSelf.model.myfollow = @"1";
             }else{
                 [weakSelf.attentionBtn setImage:CImage(@"icon_dyn_cirlce_attent") forState:UIControlStateNormal];
                 weakSelf.model.myfollow = @"0";
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicCircleFollowStatusNotification object:nil userInfo:@{@"circle_id":weakSelf.model.circle_id, @"extend_circlfollowed":weakSelf.model.myfollow}];
         }else{
             [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
         }
     } Failure:^(NSError * _Nonnull error) {
          [BGProgressHUD showInfoWithMessage:@"操作失败"];
     }];
     
     if (self.DidClickCircle) {
         self.DidClickCircle(0);
     }
}
-(void)PersonHomeAct{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":_model.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:_model.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
}
- (void)scrollViewDidScroll:(CGFloat)offsetY {
    if (offsetY<0) {
        self.coverImageView.frame = CGRectMake( offsetY / 2.0, offsetY, self.width - offsetY, self.height- offsetY);
        self.hazyView.frame = CGRectMake( offsetY / 2.0, offsetY, self.width - offsetY, self.height- offsetY);
    }
    else{
        self.coverImageView.frame = CGRectMake( 0, 0, self.width, self.height);
        self.hazyView.frame = CGRectMake( 0, 0, self.width, self.height);
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

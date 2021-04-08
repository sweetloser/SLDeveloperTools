//
//  BXSLLiveUserCell.m
//  BXlive
//
//  Created by bxlive on 2019/3/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLLiveUserCell.h"
//#import "BXPersonHomeVC.h"
#import "BXGradientButton.h"
#import "SLAppInfoConst.h"
#import "BXAppInfo.h"
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "NewHttpManager.h"
#import "../SLMaskTools/SLMaskTools.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface BXSLLiveUserCell ()

@property (nonatomic, strong) UIImageView *avatarBtn;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *idLb;
@property (nonatomic, strong) UILabel *infoLb;
@property (nonatomic, strong) UIImageView *livingImageView;

@end

@implementation BXSLLiveUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarBtn = [[UIImageView alloc]init];
        _avatarBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarBtn.layer.borderWidth = 1;
        _avatarBtn.layer.cornerRadius = __ScaleWidth(32);
        _avatarBtn.layer.masksToBounds = YES;
//        [_avatarBtn addTarget:self action:@selector(avatarAction) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:_avatarBtn];
        [_avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(__ScaleWidth(64));
            make.left.mas_equalTo(__ScaleWidth(12));
            make.centerY.mas_equalTo(0);
        }];
        
        _livingImageView = [UIImageView new];
        _livingImageView.image = CImage(@"video_isLive");
        [_avatarBtn addSubview:_livingImageView];
        _livingImageView.sd_layout.widthIs(__ScaleWidth(34)).heightIs(__ScaleWidth(13)).centerXEqualToView(_avatarBtn).topEqualToView(_avatarBtn);
        
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followBtn setTitle:@"关注" forState:BtnNormal];
        [_followBtn setTitle:@"已关注" forState:BtnSelected];
        [_followBtn setBackgroundImage:[UIImage imageWithColor:sl_normalColors] forState:BtnNormal];
        [_followBtn setBackgroundImage:[UIImage imageWithColor:[UIColor sl_colorWithHex:0xF5F9FC]] forState:BtnSelected];
        [_followBtn setTitleColor:[UIColor sl_colorWithHex:0xF8F8F8] forState:BtnNormal];
        [_followBtn setTitleColor:sl_textSubColors forState:BtnSelected];
        _followBtn.titleLabel.font = SLPFFont(__ScaleWidth(14));
        _followBtn.layer.masksToBounds = YES;
        _followBtn.layer.cornerRadius = __ScaleWidth(15);
        [_followBtn addTarget:self action:@selector(followAction:) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:_followBtn];
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-__ScaleWidth(12));
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(__ScaleWidth(84));
            make.height.mas_equalTo(__ScaleWidth(30));
        }];
        
        _nameLb = [[UILabel alloc]init];
        _nameLb.textColor = sl_textColors;
        _nameLb.font = SLBFont(__ScaleWidth(16));
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarBtn.mas_top);
            make.height.mas_equalTo(__ScaleWidth(22));
            make.left.mas_equalTo(self.avatarBtn.mas_right).offset(__ScaleWidth(10));
            make.right.mas_equalTo(self.followBtn.mas_left).offset(-__ScaleWidth(10));
        }];
        
        _idLb = [[UILabel alloc]init];
        _idLb.textColor = [UIColor sl_colorWithHex:0xB2B2B2];
        _idLb.font = SLPFFont(__ScaleWidth(12));
        [self.contentView addSubview:_idLb];
        [_idLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLb);
            make.top.mas_equalTo(self.nameLb.mas_bottom).offset(__ScaleWidth(5));
            make.height.mas_equalTo(__ScaleWidth(17));
        }];
        
        _infoLb = [[UILabel alloc]init];
        _infoLb.textColor = [UIColor sl_colorWithHex:0xB2B2B2];
        _infoLb.font = SLPFFont(__ScaleWidth(12));
        [self.contentView addSubview:_infoLb];
        [_infoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.idLb);
            make.top.mas_equalTo(self.idLb.mas_bottom).offset(__ScaleWidth(5));
            make.height.mas_equalTo(__ScaleWidth(17));
        }];
        
    }
    return self;
}
-(void)setDynmodel:(BXDynamicModel *)dynmodel{
    BXLiveUser *liveUser = dynmodel.msgdetailmodel.liveuserModel;
    _liveUser = liveUser;
    [_avatarBtn sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar] placeholderImage:CImage(@"placeholder_avatar")];
//    [_avatarBtn sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar] forState:BtnNormal placeholderImage:CImage(@"placeholder_avatar")];
    _followBtn.selected = [liveUser.is_follow integerValue];
    _nameLb.attributedText = [self getAttributedStringName:liveUser];
    _idLb.text = [NSString stringWithFormat:@"%@：%@",[BXAppInfo appInfo].app_account_name,liveUser.user_id];
    _infoLb.text = liveUser.sign;
    
    if ([liveUser.is_live integerValue] == 1 || dynmodel.msgdetailmodel.sysModel.is_live.integerValue == 1) {
        _livingImageView.hidden = NO;
    }else{
        _livingImageView.hidden = YES;
    }
}
- (void)setLiveUser:(BXLiveUser *)liveUser {
    _liveUser = liveUser;
    
    [_avatarBtn sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar] placeholderImage:CImage(@"placeholder_avatar")];
    _followBtn.selected = [liveUser.is_follow integerValue];
    _nameLb.attributedText = [self getAttributedStringName:liveUser];
    _idLb.text = [NSString stringWithFormat:@"%@：%@",[BXAppInfo appInfo].app_account_name,liveUser.user_id];
    _infoLb.text = liveUser.sign;
    
    if ([liveUser.is_live integerValue] == 1) {
        _livingImageView.hidden = NO;
    }else{
        _livingImageView.hidden = YES;
    }
}

- (void)followAction:(UIButton *)sender {
    [NewHttpManager followWithUserId:_liveUser.user_id success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            NSDictionary *dataDic = jsonDic[@"data"];
            self.liveUser.is_follow = dataDic[@"status"];
            self.dynmodel.msgdetailmodel.liveuserModel.is_follow = dataDic[@"status"];
            sender.selected = [self.liveUser.is_follow integerValue];
        } else {
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}

-(NSAttributedString *)getAttributedStringName:(BXLiveUser *)liver{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:liver.nickname];
    [attribute appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    //性别
    if ([liver.gender integerValue] != 0) {
        UIImage *sexImage = nil;
        if ([liver.gender integerValue]==1){
        //        男
            sexImage = [UIImage imageNamed:@"gender_icon_male"];
        }else{
        //        女
            sexImage = [UIImage imageNamed:@"gender_icon_female"];
        }
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = sexImage;
        // 设置图片大小
        attch.bounds = CGRectMake(0,-2,16,16);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attribute appendAttributedString:string];
        [attribute appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    if ([liver.level integerValue]>0) {
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image =  [UIImage imageNamed:[NSString stringWithFormat:@"level_%@",liver.level]];
        // 设置图片大小
        attch.bounds = CGRectMake(0,-2,34,16);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attribute appendAttributedString:string];
        [attribute appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }

    //vip
    if ([liver.vip_status integerValue] == 1) {

        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image =  CImage(@"mine_vipIdentification");
        // 设置图片大小
        attch.bounds = CGRectMake(0,-2,16,16);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attribute appendAttributedString:string];
        [attribute appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];

    }
    //创作号
    if ([liver.is_creation integerValue] == 1) {
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = CImage(@"mine-creationer");
        // 设置图片大小
        attch.bounds = CGRectMake(0,-2,12,16);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attribute appendAttributedString:string];
        [attribute appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
       
    }
    //认证
    if ([liver.verified integerValue] == 1) {
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = CImage(@"mine_app_Ident");
        // 设置图片大小
        attch.bounds = CGRectMake(0,-2,16,16);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attribute appendAttributedString:string];
        [attribute appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }

    return attribute;
}



- (void)avatarAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":_liveUser.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

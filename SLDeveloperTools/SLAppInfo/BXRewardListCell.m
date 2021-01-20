//
//  BXRewardListCell.m
//  BXlive
//
//  Created by bxlive on 2019/4/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXRewardListCell.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <SDWebImage/SDWebImage.h>
#import "NewHttpManager.h"
#import "BXAppInfo.h"
#import "../SLMaskTools/SLMaskTools.h"

@interface BXRewardListCell ()

@property (nonatomic, strong) UIImageView *numIv;
@property (nonatomic, strong) UILabel *numLb;
@property (nonatomic, strong) UIImageView *headBgIv;
@property (nonatomic, strong) UIImageView *headIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *countLb;
@property (nonatomic, strong) UIButton *attentionBtn;

@end

@implementation BXRewardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *subContentView = [[UIView alloc]init];
        [self.contentView addSubview:subContentView];
        [subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-__ScaleWidth(0));
        }];
        subContentView.backgroundColor = [UIColor clearColor];
        
//        关注按钮
        _attentionBtn = [[UIButton alloc]init];
        [_attentionBtn setTitle:@"关注" forState:BtnNormal];
        [_attentionBtn setTitle:@"已关注" forState:BtnSelected];
        _attentionBtn.titleLabel.font = SLPFFont(__ScaleWidth(14));
        [_attentionBtn setTitleColor:[UIColor sl_colorWithHex:0xF8F8F8] forState:BtnNormal];
        [_attentionBtn setTitleColor:sl_textSubColors forState:BtnSelected];
        [_attentionBtn setBackgroundImage:[UIImage imageWithColor:sl_normalColors] forState:BtnNormal];
        [_attentionBtn setBackgroundImage:[UIImage imageWithColor:[UIColor sl_colorWithHex:0xF5F9FC]] forState:BtnSelected];
        _attentionBtn.layer.cornerRadius = __ScaleWidth(15);
        _attentionBtn.layer.masksToBounds = YES;
        [_attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:BtnTouchUpInside];
        [subContentView addSubview:_attentionBtn];
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(__ScaleWidth(-15));
            make.width.mas_equalTo(__ScaleWidth(70));
            make.height.mas_equalTo(__ScaleWidth(30));
        }];
        
        _numIv = [[UIImageView alloc]init];
        _numIv.contentMode = UIViewContentModeScaleAspectFit;
        [subContentView addSubview:_numIv];
        [_numIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(44);
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(__ScaleWidth(16));
        }];
        
        _numLb = [[UILabel alloc]init];
        _numLb.font = SLPFFont(__ScaleWidth(14));
        
        _numLb.textColor = sl_textSubColors;
        _numLb.textAlignment = NSTextAlignmentCenter;
        [subContentView addSubview:_numLb];
        [_numLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.numIv);
        }];
        
        
        _headIv = [[UIImageView alloc]init];
        _headIv.layer.masksToBounds = YES;
        _headIv.contentMode = UIViewContentModeScaleAspectFill;
        [subContentView addSubview:_headIv];
        [_headIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(__ScaleWidth(68));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.numIv.mas_right).offset(12);
        }];
        _headIv.layer.cornerRadius = __ScaleWidth(34);
        
        _headBgIv = [[UIImageView alloc]init];
        [subContentView addSubview:_headBgIv];
        [_headBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(__ScaleWidth(80-0.5));
            make.width.mas_equalTo(__ScaleWidth(80-2));
            make.centerY.mas_equalTo(__ScaleWidth(-4));
            make.centerX.equalTo(self.headIv).offset(__ScaleWidth(-3));
        }];
        
        _nameLb = [[UILabel alloc]init];
        _nameLb.font = SLPFFont(__ScaleWidth(16));
        [subContentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(self.headBgIv.mas_right).offset(7);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.attentionBtn.mas_left).offset(-5);
        }];
        
        _countLb = [[UILabel alloc]init];
        _countLb.font = SLPFFont(__ScaleWidth(14));
        _countLb.textColor = sl_textSubColors;
        [subContentView addSubview:_countLb];
        [_countLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLb.mas_bottom).offset(8);
            make.left.right.mas_equalTo(self.nameLb);
            make.height.mas_equalTo(18);
        }];
        
        self.num = 0;
      
        
        
        
    }
    return self;
}

- (void)setNum:(NSInteger)num {
    _num = num;
    if (num > 2) {
        _headBgIv.hidden = YES;
        _numLb.text = [NSString stringWithFormat:@"%ld",(long)(num+1)];
        _nameLb.textColor = WhiteBgTitleColor;
    } else {
        _numLb.text = [NSString stringWithFormat:@"%ld",(long)num];
        _headBgIv.hidden = NO;
        NSString *imageName = [NSString stringWithFormat:@"reward_rank_1%ld",(long)(num+1)];
        _numIv.image = CImage(imageName);
        
        NSString *bgImageName = [NSString stringWithFormat:@"reward_rank_0%ld",(long)(num+1)];
        _headBgIv.image = CImage(bgImageName);
        
//        if (!num) {
//            _nameLb.textColor = CHHCOLOR_D(0xDF4A49);
//        } else if (num == 1) {
//            _nameLb.textColor = CHHCOLOR_D(0xED7220);
//        } else {
//            _nameLb.textColor = CHHCOLOR_D(0xF19500);
//        }
    }
    _numIv.hidden = _headBgIv.hidden;
    _numLb.hidden = !_numIv.hidden;
}

-(void)setLiveUser:(BXLiveUser *)liveUser{
    
    _liveUser = liveUser;
    [_headIv sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar]];
    _nameLb.text = liveUser.nickname;
    _countLb.text = [NSString stringWithFormat:@"打赏%@%@",liveUser.give_coin,[BXAppInfo appInfo].app_recharge_unit];
    _attentionBtn.selected = [liveUser.is_follow integerValue];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)attentionAction:(UIButton *)sender {

    [NewHttpManager followWithUserId:_liveUser.user_id success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            NSDictionary *dataDic = jsonDic[@"data"];
            self.liveUser.is_follow = dataDic[@"status"];
            sender.selected = [self.liveUser.is_follow integerValue];
        } else {
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
    
}

@end

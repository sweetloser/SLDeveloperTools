//
//  BXDaemonSecondCell.m
//  BXlive
//
//  Created by bxlive on 2017/12/4.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BXDaemonSecondCell.h"
#import "SLDeveloperTools.h"
#import <Masonry/Masonry.h>

#define beishu MIN(SCREEN_WIDTH,SCREEN_HEIGHT)/375.0

@interface BXDaemonSecondCell ()

@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UIImageView *headImageView;//头像
//@property (strong, nonatomic) UIImageView *realNameIV;
@property (strong, nonatomic) UILabel *nameLabel;//昵称
//@property (strong, nonatomic) UIImageView *sexIV;
//@property (strong, nonatomic) UIImageView *levelIV;
//@property (strong, nonatomic) UIImageView *vipIV;
//@property (strong, nonatomic) UIImageView *creationerIV;
//@property (strong, nonatomic) UILabel *signLb;
//@property (strong, nonatomic) UIView *fengeView;//分割线

@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation BXDaemonSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _numberLabel = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"" Font:SLPFFont(14) TextColor:sl_textColors];
    _numberLabel.textAlignment = 1;
    [self.contentView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(__GenScaleWidth(47));
        make.height.mas_equalTo(__GenScaleWidth(20));
    }];
    
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.layer.cornerRadius = 21.5 *beishu;
    _headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(43 * beishu);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.numberLabel.mas_right);
    }];
    
//    _realNameIV = [[UIImageView alloc]init];
//    _realNameIV.image = [UIImage imageNamed:@"mine_app_Ident"];
//    [self.contentView addSubview:_realNameIV];
//    [_realNameIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(13 * beishu);
//        make.right.bottom.mas_equalTo(self.headImageView).offset(-1 * beishu);
//    }];
    
    _nameLabel = [UILabel initWithFrame:CGRectZero size:14*beishu color:sl_textColors alignment:NSTextAlignmentLeft lines:1];
    _nameLabel.font = SLPFFont(14);
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(__GenScaleWidth(14));
        make.centerY.mas_equalTo(0 * beishu);
        make.height.mas_equalTo(21 *beishu);
        make.width.mas_lessThanOrEqualTo(200 * beishu);
    }];
    
    _timeLabel = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"" Font:SLPFFont(__GenScaleWidth(12)) TextColor:sl_textColors];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-__GenScaleWidth(12));
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(__GenScaleWidth(100));
    }];

//    _sexIV = [[UIImageView alloc]init];
//    _sexIV.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_sexIV];
//    [_sexIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(15 * beishu);
//        make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
//        make.centerY.mas_equalTo(self.nameLabel);
//    }];
    
//    _levelIV = [[UIImageView alloc]initWithFrame:CGRectZero];
//    [self.contentView addSubview:_levelIV];
//    [_levelIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(30 * beishu);
//        make.height.mas_equalTo(14 *beishu);
//        make.left.mas_equalTo(self.sexIV.mas_right).offset(5);
//        make.centerY.mas_equalTo(self.nameLabel);
//    }];
    
//    _vipIV = [[UIImageView alloc]initWithFrame:CGRectZero];
//    _vipIV.image = [UIImage imageNamed:@"mine_vipIdentification"];
//    [self.contentView addSubview:_vipIV];
//    [_vipIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(15 * beishu);
//        make.left.mas_equalTo(self.levelIV.mas_right).offset(5);
//        make.centerY.mas_equalTo(self.nameLabel);
//    }];
    
    
//    _creationerIV = [[UIImageView alloc]initWithFrame:CGRectZero];
//    _creationerIV.image = [UIImage imageNamed:@"mine-creationer"];
//    _creationerIV.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_creationerIV];
//    [_creationerIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(18 * beishu);
//        make.left.mas_equalTo(self.vipIV.mas_right).offset(5);
//        make.centerY.mas_equalTo(self.nameLabel);
//    }];
    
//    _signLb = [UILabel initWithFrame:CGRectZero size:12*beishu color:UIColorHex(B0B0B0) alignment:NSTextAlignmentLeft lines:1];
//    [self.contentView addSubview:_signLb];
//    [_signLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.nameLabel);
//        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5 * beishu);
//        make.right.mas_equalTo(-15 * beishu);
//        make.height.mas_equalTo(12 * beishu);
//    }];
    
//    _fengeView = [[UIView alloc]initWithFrame:CGRectZero];
//    _fengeView.backgroundColor = CHHCOLOR_D(0xebebeb);
//    [self.contentView addSubview:_fengeView];
//    [_fengeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(.5);
//    }];
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"BXDaemonSecondCell";
    BXDaemonSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BXDaemonSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)loadCellData:(BXDaemonListModel *)model indexPath:(NSIndexPath *)indexPath{
    _nameLabel.text = model.nickname;
    [_headImageView zzl_setImageWithURLString:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"placeplaceholder"]];
    _numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 3];
    _timeLabel.text = [NSString stringWithFormat:@"守护了%@",@"3个月"];
//    _levelIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%d",[model.level intValue]]];
//    _signLb.text  = model.sign;
//    [_sexIV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(__GenScaleWidth(15));
//    }];
//    switch ([model.gender integerValue]) {
//        case 0:
////            _sexIV.image = [UIImage imageNamed:@"gender_icon_weishezhi"];
//            [_sexIV mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(0);
//            }];
//            break;
//
//        case 1:
//            _sexIV.image = [UIImage imageNamed:@"gender_icon_male"];
//            break;
//
//        default:
//            _sexIV.image = [UIImage imageNamed:@"gender_icon_female"];
//            break;
//    }
//    _realNameIV.hidden = !([model.verified integerValue] == 1);
//    if ([model.vip_status integerValue] == 1) {
//        _vipIV.hidden = NO;
//        [_creationerIV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.vipIV.mas_right).offset(5);
//        }];
//    } else {
//        _vipIV.hidden = YES;
//        [_creationerIV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.vipIV);
//        }];
//    }
//    _creationerIV.hidden = ![model.is_creation integerValue];
//
//    if (model.type) {
//        _nameLabel.textColor = MainTitleColor;
//        _fengeView.backgroundColor = LineNormalColor;
//    }else{
//        _nameLabel.textColor = UIColorHex(373737);
//        _fengeView.backgroundColor = UIColorHex(ebebeb);
//    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

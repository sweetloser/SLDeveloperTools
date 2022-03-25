//
//  BXDaemonFirstCell.m
//  BXlive
//
//  Created by bxlive on 2017/12/4.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BXDaemonFirstCell.h"
#import "SLDaemonFirstThreeView.h"
#import "SLDeveloperTools.h"
#import <Masonry/Masonry.h>

@interface BXDaemonFirstCell ()

@property (strong, nonatomic) UIImageView *numberHeaderImgView;//前三名头像挂饰
@property (strong, nonatomic) UIImageView *headImageView;//头像
@property (strong, nonatomic) UIView *infoView;                              //信息视图
@property (strong, nonatomic) UILabel *nameLabel;//昵称
@property (strong, nonatomic) UIImageView *sexIV;
@property (strong, nonatomic) UIImageView *levelIV;                          //等级图片
@property (strong, nonatomic) UIImageView *vipIV;
@property (strong, nonatomic) UIImageView *creationerIV;
@property (strong, nonatomic) UILabel *signLb;//股权
@property (strong, nonatomic) UIView *fengeView;//分割线


@property (strong, nonatomic) SLDaemonFirstThreeView *fView;
@property (strong, nonatomic) SLDaemonFirstThreeView *sView;
@property (strong, nonatomic) SLDaemonFirstThreeView *tView;


@end

@implementation BXDaemonFirstCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    _fView = [[SLDaemonFirstThreeView alloc] initWithFrame:CGRectZero withType:0];
    [self addSubview:_fView];
    WS(weakSelf);
    [_fView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(__GenScaleWidth(100));
        make.top.mas_equalTo(__GenScaleWidth(15));
        make.height.mas_equalTo(__GenScaleWidth(125));
    }];
    
    _sView = [[SLDaemonFirstThreeView alloc] initWithFrame:CGRectZero withType:1];
    [self addSubview:_sView];
    
    [_sView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__GenScaleWidth(15));
        make.top.equalTo(weakSelf.fView.mas_top).offset(__GenScaleWidth(30));
        make.width.mas_equalTo(__GenScaleWidth(100));
        make.height.mas_equalTo(100);
    }];
    
    _tView = [[SLDaemonFirstThreeView alloc] initWithFrame:CGRectZero withType:1];
    [self addSubview:_tView];
    
    [_tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-__GenScaleWidth(15));
        make.width.height.top.equalTo(weakSelf.sView);
    }];
    
    
//    _headImageView = [[UIImageView alloc]init];
//    _headImageView.layer.masksToBounds = YES;
//    _headImageView.layer.cornerRadius = 35.5  * beishu;
//    [self.contentView addSubview:_headImageView];
//    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.top.mas_equalTo(38 * beishu);
//        make.width.height.mas_equalTo(71*beishu);
//    }];
//
//    _numberHeaderImgView = [[UIImageView alloc]init];
//    _numberHeaderImgView.image = [UIImage imageNamed:@"守护之星"];
//    [self.contentView addSubview:_numberHeaderImgView];
//    [_numberHeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.top.mas_equalTo(12.5 * beishu);
//        make.width.mas_equalTo(171.5 * beishu);
//        make.height.mas_equalTo(112 * beishu);
//    }];
//
//    _infoView = [[UIView alloc]init];
//    _infoView.clipsToBounds = YES;
//    [self.contentView addSubview:_infoView];
//
//    _nameLabel = [UILabel initWithFrame:CGRectZero size:14 * beishu color:UIColorHex(373737) alignment:NSTextAlignmentLeft lines:1];
//    [_infoView addSubview:_nameLabel];
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.mas_equalTo(0);
//        make.width.mas_lessThanOrEqualTo(130 * beishu);
//    }];
//
//    _sexIV = [[UIImageView alloc]init];
//    [_infoView addSubview:_sexIV];
//    [_sexIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
//        make.centerY.mas_equalTo(self.nameLabel);
//        make.width.height.mas_equalTo(15 * beishu);
//    }];
//
//    _levelIV = [[UIImageView alloc]init];
//    [_infoView addSubview:_levelIV];
//    [_levelIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(30 * beishu);
//        make.height.mas_equalTo(14 * beishu);
//        make.centerY.mas_equalTo(self.nameLabel);
//        make.left.mas_equalTo(self.sexIV.mas_right).offset(5);
//    }];
//
//    _vipIV = [[UIImageView alloc]initWithFrame:CGRectZero];
//    _vipIV.image = [UIImage imageNamed:@"mine_vipIdentification"];
//    [_infoView addSubview:_vipIV];
//    [_vipIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(15 * beishu);
//        make.left.mas_equalTo(self.levelIV.mas_right).offset(5);
//        make.centerY.mas_equalTo(self.self.nameLabel);
//    }];
//
//    _creationerIV = [[UIImageView alloc]initWithFrame:CGRectZero];
//    _creationerIV.image = [UIImage imageNamed:@"mine-creationer"];
//    _creationerIV.contentMode = UIViewContentModeScaleAspectFit;
//    [_infoView addSubview:_creationerIV];
//    [_creationerIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(18 * beishu);
//        make.left.mas_equalTo(self.vipIV.mas_right).offset(5);
//        make.centerY.mas_equalTo(self.nameLabel);
//    }];
//
//    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.numberHeaderImgView.mas_bottom).offset(3.5 * beishu);
//        make.centerX.mas_equalTo(0);
//        make.height.mas_equalTo(18 * beishu);
//        make.right.mas_equalTo(self.creationerIV.mas_right);
//    }];
//
//
//    _signLb = [UILabel initWithFrame:CGRectZero size:12*beishu color:UIColorHex(B0B0B0) alignment:NSTextAlignmentCenter lines:1];
//    [self.contentView addSubview:_signLb];
//    [_signLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.infoView.mas_bottom).offset(7 * beishu);
//        make.height.mas_equalTo(12 * beishu);
//    }];
//
//    _fengeView = [[UIView alloc]initWithFrame:CGRectZero];
//    _fengeView.backgroundColor = CHHCOLOR_D(0xebebeb);
//    [self.contentView addSubview:_fengeView];
//    [_fengeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(.5);
//    }];
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"BXDaemonFirstCell";
    BXDaemonFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BXDaemonFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

-(void)updateUIWithDataList:(NSArray *)listModel{
    _fView.hidden = YES;
    _sView.hidden = YES;
    _tView.hidden = YES;

    if (listModel.count >= 3) {
        _fView.hidden = NO;
        _sView.hidden = NO;
        _tView.hidden = NO;
        [_fView updateUIWithModel:listModel[0]];
         [_sView updateUIWithModel:listModel[1]];
        [_tView updateUIWithModel:listModel[2]];
    }
    else if (listModel.count >= 2){
        _fView.hidden = NO;
        _sView.hidden = NO;
        _tView.hidden = NO;
        [_fView updateUIWithModel:listModel[0]];
        [_sView updateUIWithModel:listModel[1]];
        [_tView updateUIWithModel:nil];
    }
    else if (listModel.count >= 1){
        _fView.hidden = NO;
        _sView.hidden = NO;
        _tView.hidden = NO;
        [_fView updateUIWithModel:listModel[0]];
        [_sView updateUIWithModel:nil];
        [_tView updateUIWithModel:nil];
    }else{
        
    }
}

- (void)loadCellData:(BXDaemonListModel *)model indexPath:(NSIndexPath *)indexPath{
    _nameLabel.text = model.nickname;
    switch ([model.gender integerValue]) {
        case 0:
            _sexIV.image = [UIImage imageNamed:@"gender_icon_weishezhi"];
            break;
            
        case 1:
            _sexIV.image = [UIImage imageNamed:@"gender_icon_male"];
            break;
            
        default:
            _sexIV.image = [UIImage imageNamed:@"gender_icon_female"];
            break;
    }
    _levelIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%@",model.level]];
    
    [_headImageView zzl_setImageWithURLString:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"placeplaceholder"]];
    UIView *lastView = _levelIV;
    if ([model.vip_status integerValue] == 1) {
        _vipIV.hidden = NO;
        lastView = _vipIV;
        [_creationerIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.vipIV.mas_right).offset(5);
        }];
    } else {
        _vipIV.hidden = YES;
        [_creationerIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.vipIV.mas_left);
        }];
    }
    if ([model.is_creation integerValue]) {
        _creationerIV.hidden = NO;
        lastView = _creationerIV;
        
    } else {
        _creationerIV.hidden = YES;
    }
    [_infoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lastView.mas_right);
    }];
    
    _signLb.text  = model.sign;
    
    if (model.type) {
        _nameLabel.textColor = MainTitleColor;
        _fengeView.backgroundColor = LineNormalColor;
    }else{
        _nameLabel.textColor = [UIColor sl_colorWithHex:0x373737];
        _fengeView.backgroundColor = CHHCOLOR_D(0xebebeb);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

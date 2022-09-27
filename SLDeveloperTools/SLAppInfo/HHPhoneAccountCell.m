//
//  HHPhoneAccountCell.m
//  BXlive
//
//  Created by bxlive on 2018/5/3.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "HHPhoneAccountCell.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <SDAutoLayout/SDAutoLayout.h>

@interface HHPhoneAccountCell()

@property (nonatomic, strong) UIImageView *iconImageView;         //图标
@property (nonatomic, strong) UILabel *titleLabel;                //标题
@property (nonatomic, strong) UIButton *bindBtn;
@property (nonatomic, strong) UIImageView *nextImageView;         //跳转箭头

@end

@implementation HHPhoneAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    HHPhoneAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHPhoneAccountCell"];
    if (cell == nil) {
        cell = [[HHPhoneAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HHPhoneAccountCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconImageView = [UIImageView new];
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLabel = [UILabel initWithFrame:CGRectZero size:13 color:sl_textColors alignment:NSTextAlignmentLeft lines:1];
        self.titleLabel.font = SLBFont(__ScaleWidth(15));
        [self.contentView addSubview:self.titleLabel];
        
        
        
        self.nextImageView = [UIImageView new];
        self.nextImageView.image = [UIImage imageNamed:@"箭头下一步"];
        [self.contentView addSubview:self.nextImageView];
        
        
        self.bindBtn = [[UIButton alloc]init];
        self.bindBtn.titleLabel.font = SLPFFont(__ScaleWidth(15));
        [self.bindBtn setTitleColor:sl_textSubColors forState:UIControlStateNormal];
        self.bindBtn.backgroundColor = [UIColor clearColor];
        [self.bindBtn setTitle:@"请绑定手机号" forState:UIControlStateNormal];
        self.bindBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.bindBtn];
        
        
        self.iconImageView.sd_layout.leftSpaceToView(self.contentView,15).centerYEqualToView(self.contentView).widthIs(26).heightIs(26);
        self.titleLabel.sd_layout.leftSpaceToView(self.iconImageView,13).topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0).widthIs(100);
        self.nextImageView.sd_layout.rightSpaceToView(self.contentView,15).centerYEqualToView(self.contentView).widthIs(7).heightIs(12);
        
        self.bindBtn.sd_layout.rightSpaceToView(self.nextImageView,10).centerYEqualToView(self.contentView);
        [self.bindBtn setupAutoSizeWithHorizontalPadding:2.f buttonHeight:30];
    }
    return self;
}

- (void)setTitle:(NSString *)title icon:(NSString *)icon phone:(NSString *)phone {
    _titleLabel.text = title;
    _iconImageView.image = CImage(icon);
    
    if (IsNilString(phone)) {
        phone = @"请绑定手机号";
    }
    [_bindBtn setTitle:phone forState:BtnNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

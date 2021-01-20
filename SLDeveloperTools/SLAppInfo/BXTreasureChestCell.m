//
//  BXTreasureChestCell.m
//  BXlive
//
//  Created by bxlive on 2019/4/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXTreasureChestCell.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface BXTreasureChestCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *countLb;

@end

@implementation BXTreasureChestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconIv = [[UIImageView alloc]init];
        _iconIv.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconIv];
        [_iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(22);
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(0);
        }];
        
        _countLb = [[UILabel alloc]init];
        _countLb.font = CFont(17);
        _countLb.textColor = CHHCOLOR_D(0xDD390F);
        _countLb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_countLb];
        [_countLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-24);
            make.top.bottom.mas_equalTo(self.iconIv);
            make.width.mas_greaterThanOrEqualTo(29);
        }];
        
        _nameLb = [[UILabel alloc]init];
        _nameLb.font = CFont(14);
        _nameLb.textColor = CHHCOLOR_D(0x906632);
        _nameLb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconIv.mas_right).offset(12);
            make.right.mas_lessThanOrEqualTo(self.countLb.mas_left).offset(-5);
            make.top.bottom.mas_equalTo(self.iconIv);
            make.width.mas_greaterThanOrEqualTo(29);
        }];
    }
    return self;
}

- (void)setGift:(BXTreasureChestGift *)gift {
    _gift = gift;
    [_iconIv sd_setImageWithURL:[NSURL URLWithString:gift.icon]];
    _nameLb.text = gift.name;
    _countLb.text = [NSString stringWithFormat:@"%@",gift.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

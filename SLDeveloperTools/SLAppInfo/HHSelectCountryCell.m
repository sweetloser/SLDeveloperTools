//
//  HHSelectCountryCell.m
//  BXlive
//
//  Created by bxlive on 2018/9/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "HHSelectCountryCell.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Masonry/Masonry.h>

@interface HHSelectCountryCell ()

@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) UILabel *codeLb;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation HHSelectCountryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _codeLb = [[UILabel alloc]init];
        _codeLb.font = CFont(16);
        _codeLb.textColor = CHHCOLOR_D(0xB0B0B0);
        _codeLb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_codeLb];
        [_codeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_lessThanOrEqualTo(150);
            make.top.bottom.mas_equalTo(0);
        }];
        
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = CFont(16);
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.codeLb.mas_left).offset(-5);
            make.top.bottom.mas_equalTo(0);
        }];
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = CHHCOLOR_D(0xebebeb);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(.5);
            make.left.mas_equalTo(self.titleLb);
            make.right.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCountry:(HHCountry *)country {
    _country = country;
    
    _titleLb.text = country.area;
    _codeLb.text = [NSString stringWithFormat:@"+%@",country.code];
}

@end

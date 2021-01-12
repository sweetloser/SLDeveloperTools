//
//  BXSLSearchHistoryCell.m
//  BXlive
//
//  Created by bxlive on 2019/3/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchHistoryCell.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>

@interface BXSLSearchHistoryCell ()

@property (nonatomic, strong) UILabel *textLb;

@end

@implementation BXSLSearchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *iconIv = [[UIImageView alloc]init];
        iconIv.image = CImage(@"sousuo_icon_shijian");
        [self.contentView addSubview:iconIv];
        
        UIButton *removeBtn = [[UIButton alloc]init];
        [removeBtn setImage:CImage(@"sousuo_icon_shanchu") forState:BtnNormal];
        [removeBtn addTarget:self action:@selector(removeAction) forControlEvents:BtnTouchUpInside];
        [self.contentView addSubview:removeBtn];
        
        _textLb = [[UILabel alloc]init];
        _textLb.textColor = CHHCOLOR_D(0xB8C2C2);
        _textLb.font = CFont(14);
        [self.contentView addSubview:_textLb];
        
        
        [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(16);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.textLb);
        }];
        
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(16);
            make.left.mas_equalTo(24);
            make.centerY.mas_equalTo(removeBtn);
        }];
        
        [_textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconIv.mas_right).offset(8);
            make.right.mas_equalTo(removeBtn.mas_left).offset(-8);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _textLb.text = text;
}

- (void)removeAction {
    if (_removeText) {
        _removeText(_text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

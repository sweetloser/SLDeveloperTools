//
//  BXDynTipOffCell.m
//  BXlive
//
//  Created by mac on 2020/7/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTipOffCell.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import "../SLCategory/SLCategory.h"

@interface BXDynTipOffCell()

@property (nonatomic,strong)UILabel *titleLabel;


@end
@implementation BXDynTipOffCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
        
    }
    return self;
}
-(void)setView{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = sl_textColors;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(12);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.width.mas_equalTo(100);
    }];
    
    _Sellabel = [[UILabel alloc]init];
    _Sellabel.backgroundColor = sl_subBGColors;
    _Sellabel.layer.cornerRadius = 10;
    _Sellabel.layer.masksToBounds = YES;
//    #FF2D52
    [self.contentView addSubview:_Sellabel];
    [_Sellabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(20);
    }];
    
    
}
-(void)setModel:(BXDynTitleListModel *)model{
    _titleLabel.text = model.child_name;
    if ([model.sel_tip isEqualToString:@"0"]) {
        _Sellabel.backgroundColor = sl_subBGColors;
    }else{
        _Sellabel.backgroundColor = [UIColor sl_colorWithHex:0xFF2D52];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

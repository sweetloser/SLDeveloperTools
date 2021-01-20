//
//  SLReportToolCell.m
//  BXlive
//
//  Created by sweetloser on 2020/12/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLReportToolCell.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>

@interface SLReportToolCell()

@property (nonatomic,strong)UILabel *titleLabel;

@end
@implementation SLReportToolCell
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
    
    _selLabel = [[UILabel alloc]init];
    _selLabel.backgroundColor = sl_subBGColors;
    _selLabel.layer.cornerRadius = 10;
    _selLabel.layer.masksToBounds = YES;
//    #FF2D52
    [self.contentView addSubview:_selLabel];
    [_selLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(20);
    }];
}
-(void)setModel:(SLReportToolModel *)model{
    _titleLabel.text = model.entry_dis;
    if (model.isSelected == NO) {
        _selLabel.backgroundColor = sl_subBGColors;
    }else{
        _selLabel.backgroundColor = sl_normalColors;
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

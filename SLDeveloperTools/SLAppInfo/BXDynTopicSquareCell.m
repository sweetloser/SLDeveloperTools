//
//  BXDynTopicSquareCell.m
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTopicSquareCell.h"
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>

@implementation BXDynTopicSquareCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];

    }
    return self;
}
-(void)setView{
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"dyn_issue_huati"];
    
    _huatiLabel = [UILabel new];
    _huatiLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    _huatiLabel.textColor = [UIColor blackColor];
    
    _huatiNumLabel = [UILabel new];
    _huatiNumLabel.text = @"创建话题";
    _huatiNumLabel.textAlignment = 2;
    _huatiNumLabel.textColor = sl_textSubColors;
    _huatiNumLabel.font = [UIFont systemFontOfSize:14];

    
    [self.contentView sd_addSubviews:@[image, _huatiNumLabel, _huatiLabel]];
    image.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 15).widthIs(15).heightIs(15);
    _huatiNumLabel.sd_layout.rightSpaceToView(self.contentView, 12).centerYEqualToView(image).heightIs(20).widthIs(100);
    _huatiLabel.sd_layout.leftSpaceToView(image, 5).centerYEqualToView(image).rightSpaceToView(_huatiNumLabel, 10).heightIs(20);
    [self setupAutoHeightWithBottomView:image bottomMargin:15];
    
}
-(void)setHuatiLabel:(UILabel *)huatiLabel{
    _huatiLabel.text = huatiLabel.text;
}
-(void)setHuatiNumLabel:(UILabel *)huatiNumLabel{
    _huatiNumLabel.text = [NSString stringWithFormat:@"%@条动态", huatiNumLabel.text];
}
-(void)AddHuaTi{
    if (_CreateHuaTi) {
        self.CreateHuaTi(_huatiLabel.text);
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

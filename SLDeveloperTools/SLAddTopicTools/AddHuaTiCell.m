//
//  AddHuaTiCell.m
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "AddHuaTiCell.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>

@implementation AddHuaTiCell
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
    
    _createLabel = [UILabel new];
    _createLabel.text = @"创建话题";
    _createLabel.textColor = sl_textSubColors;
    _createLabel.font = [UIFont systemFontOfSize:14];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AddHuaTi)];
    [_createLabel addGestureRecognizer:tap];
    _createLabel.userInteractionEnabled = YES;
    
    _topicNumLabel = [UILabel new];
    _topicNumLabel.textColor = sl_textSubColors;
    _topicNumLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView sd_addSubviews:@[image, _createLabel, _huatiLabel]];
    image.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 15).widthIs(15).heightIs(15);
    _createLabel.sd_layout.rightSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 12.5).heightIs(20).widthIs(60);
    _topicNumLabel.sd_layout.rightSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 12.5).heightIs(20).widthIs(100);
    _huatiLabel.sd_layout.leftSpaceToView(image, 5).topSpaceToView(self.contentView, 12.5).rightSpaceToView(_createLabel, 10).heightIs(20);
    [self setupAutoHeightWithBottomView:image bottomMargin:15];
    
}

-(void)setTopicname:(NSString *)topicname{
    _huatiLabel.text = topicname;
}
-(void)setTopicNum:(NSString *)topicNum{
    _topicNumLabel.text = [NSString stringWithFormat:@"%@条动态", topicNum];
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

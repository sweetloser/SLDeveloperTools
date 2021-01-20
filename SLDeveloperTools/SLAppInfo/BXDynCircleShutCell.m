//
//  BXDynCircleShutCell.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleShutCell.h"
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>

@interface BXDynCircleShutCell()
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property(nonatomic, strong)UIImageView *headerImageView;
@property(nonatomic, strong)UIButton *shutBtn;

@end
@implementation BXDynCircleShutCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}
-(void)setView{
    _headerImageView = [[UIImageView alloc]init];
    _headerImageView.backgroundColor = [UIColor cyanColor];
    _headerImageView.layer.cornerRadius = 25;
    _headerImageView.layer.masksToBounds = YES;
    

    _nameLabel = [UILabel new];
    _nameLabel.textColor = UIColorHex(#282828);
    _nameLabel.textAlignment = 0;
    _nameLabel.font = [UIFont systemFontOfSize:16];
    

    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = UIColorHex(#8C8C8C);
    _timeLabel.textAlignment = 0;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    
    _shutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_shutBtn setTitle:@"解除禁言" forState:UIControlStateNormal];
    [_shutBtn setTitleColor:UIColorHex(#8C8C8C) forState:UIControlStateNormal];
    [_shutBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    _shutBtn.backgroundColor = UIColorHex(#F5F9FC);
    _shutBtn.layer.masksToBounds = YES;
    _shutBtn.layer.cornerRadius = 17;
    
    [self.contentView sd_addSubviews:@[self.headerImageView,self.nameLabel,self.timeLabel, self.shutBtn]];
    self.headerImageView.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 12).widthIs(50).heightIs(50);

    self.nameLabel.sd_layout.leftSpaceToView(self.headerImageView, 10).topSpaceToView(self.contentView, 16).widthIs(100).heightIs(22);
    self.timeLabel.sd_layout.leftSpaceToView(self.headerImageView, 10).topSpaceToView(self.nameLabel, 3).heightIs(17).widthIs(200);
    self.shutBtn.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 12).widthIs(86).heightIs(33);


    
}
-(void)setModel:(BXDynMemberModel *)model{
    [self layoutIfNeeded];
    
    self.nameLabel.text = model.nickname;
    self.timeLabel.text = [NSString stringWithFormat:@"禁言时间：%@",model.ctime];

    
    [self setupAutoHeightWithBottomView:self.headerImageView bottomMargin:12];
}
-(void)moreClick{
    if (self.DidShutClick) {
        self.DidShutClick();
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

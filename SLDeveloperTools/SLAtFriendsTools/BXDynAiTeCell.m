//
//  BXDynAiTeCell.m
//  BXlive
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynAiTeCell.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>

@interface BXDynAiTeCell()
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property(nonatomic, strong)UIImageView *headerImageView;
@property(nonatomic, strong)UIImageView *genderImageView;
@property(nonatomic, strong)UIImageView *aiteImageView;
@end
@implementation BXDynAiTeCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
        
    }
    return self;
}
-(void)setView{
    
    _headerImageView = [[UIImageView alloc]init];
//    _headerImageView.backgroundColor = [UIColor cyanColor];
    _headerImageView.layer.cornerRadius = 21;
    _headerImageView.layer.masksToBounds = YES;
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = sl_textColors;
    _nameLabel.textAlignment = 0;
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    
    _genderImageView = [[UIImageView alloc]init];
    _genderImageView.image = [UIImage imageNamed:@"dyn_issue_gender_girl"];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor sl_colorWithHex:0xB2B2B2];
    _timeLabel.textAlignment = 0;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    
    _aiteImageView = [[UIImageView alloc]init];
    

//    #2B2E37
    UILabel *downlabel = [[UILabel alloc]init];
    downlabel.backgroundColor = [UIColor sl_colorWithHex:0x2B2E37];
    
//    icon_aite_selected
    [self.contentView sd_addSubviews:@[self.headerImageView,self.nameLabel,self.genderImageView,self.timeLabel,self.aiteImageView]];
    self.headerImageView.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 15).widthIs(42).heightIs(42);
    self.nameLabel.sd_layout.leftSpaceToView(self.headerImageView, 10).topEqualToView(self.headerImageView).widthIs(40).heightIs(20);
    self.genderImageView.sd_layout.leftSpaceToView(self.nameLabel, 10).centerYEqualToView(self.nameLabel).widthIs(12).heightIs(12);
    self.timeLabel.sd_layout.leftEqualToView(self.nameLabel).bottomEqualToView(self.headerImageView).topSpaceToView(self.nameLabel, 5).widthIs(60);
    self.aiteImageView.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.headerImageView).widthIs(18).heightIs(13);
     [self setupAutoHeightWithBottomView:self.headerImageView bottomMargin:15];
    
}
-(void)setModel:(DynAiTeFriendModel *)model{
    [self layoutIfNeeded];
    
    self.nameLabel.text = model.nickname;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"placeplaceholder")];
    if ([[NSString stringWithFormat:@"%@", model.gender] isEqualToString:@"1"]) {
        _genderImageView.image = [UIImage imageNamed:@"dyn_issue_gender_boy"];
    }
    else if([[NSString stringWithFormat:@"%@", model.gender] isEqualToString:@"2"]){
        _genderImageView.image = [UIImage imageNamed:@"dyn_issue_gender_girl"];
    }
    else{
         _genderImageView.image = [UIImage imageNamed:@""];
    }
    if ([model.is_aite_selected isEqualToString:@"1"]) {
        self.aiteImageView.image = CImage(@"icon_aite_selected");
    }else{
        self.aiteImageView.image = CImage(@"icon_aite_select");
    }
    self.timeLabel.text = model.timedeiff;
    self.nameLabel.sd_layout.leftSpaceToView(self.headerImageView, 10).topEqualToView(self.headerImageView).widthIs([UILabel getWidthWithTitle:self.nameLabel.text font:self.nameLabel.font]).heightIs(20);
   
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

//
//  BXDynPeopleAdminCell.m
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynPeopleAdminCell.h"
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import "BXLiveUser.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"

@interface BXDynPeopleAdminCell()
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property(nonatomic, strong)UIImageView *headerImageView;
@property(nonatomic, strong)UIImageView *genderImageView;
@property(nonatomic, strong)UILabel *identLabel;

@property(nonatomic, strong)UIButton *moreBtn;
@end
@implementation BXDynPeopleAdminCell
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
    
    _identLabel = [[UILabel alloc]init];
    _identLabel.textAlignment = 1;
    _identLabel.textColor = [UIColor whiteColor];
    _identLabel.font = [UIFont systemFontOfSize:11];
    _identLabel.text = @"管理员";
    _identLabel.backgroundColor = UIColorHex(#91B8F4);//管理员
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = UIColorHex(#282828);
    _nameLabel.textAlignment = 0;
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    
    _genderImageView = [[UIImageView alloc]init];
    _genderImageView.image = [UIImage imageNamed:@"dyn_issue_gender_girl"];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = UIColorHex(#B2B2B2);
    _timeLabel.textAlignment = 0;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    
    UILabel *downlabel = [[UILabel alloc]init];
    downlabel.backgroundColor = UIColorHex(#2B2E37);
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:CImage(@"dyn_issue_more") forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.contentView sd_addSubviews:@[self.headerImageView,self.identLabel,self.nameLabel,self.genderImageView,self.timeLabel, self.moreBtn]];
    self.headerImageView.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 12).widthIs(50).heightIs(50);
    self.identLabel.sd_layout.leftSpaceToView(self.headerImageView, 15).topSpaceToView(self.contentView, 19).widthIs(50).heightIs(18);
    self.nameLabel.sd_layout.leftSpaceToView(self.identLabel, 10).centerYEqualToView(self.identLabel).widthIs(100).heightIs(22);
    self.timeLabel.sd_layout.leftSpaceToView(self.headerImageView, 15).topSpaceToView(self.identLabel, 6).heightIs(17).widthIs(60);
    self.genderImageView.sd_layout.leftSpaceToView(self.timeLabel, 10).centerYEqualToView(self.timeLabel).widthIs(12).heightIs(12);
    self.moreBtn.sd_layout.rightSpaceToView(self.contentView, 12).centerYEqualToView(self.contentView).heightIs(10).widthIs(20);
    
}
-(void)setModel:(BXDynMemberModel *)model{
    [self layoutIfNeeded];
    NSString *user_id = [NSString stringWithFormat:@"%@", model.user_id];
    if ([user_id isEqualToString:[BXLiveUser currentBXLiveUser].user_id]) {
        _moreBtn.hidden = YES;
    }else{
        _moreBtn.hidden = NO;
    }
      self.nameLabel.text = model.nickname;
      self.timeLabel.text = model.difftime;
    self.timeLabel.sd_layout.leftSpaceToView(self.headerImageView, 15).topSpaceToView(self.identLabel, 6).widthIs([UILabel getWidthWithTitle:self.timeLabel.text font:self.timeLabel.font]).heightIs(17);
      [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"video-placeholder")];
      
      if ([[NSString stringWithFormat:@"%@",model.gender] isEqualToString:@"2"]) {
          _genderImageView.image = [UIImage imageNamed:@"dyn_issue_gender_girl"];
      }else{
          _genderImageView.image = [UIImage imageNamed:@"dyn_issue_gender_boy"];
      }
    
    [self setupAutoHeightWithBottomView:self.headerImageView bottomMargin:12];
}
-(void)moreClick{
    if (self.DidClickMore) {
        self.DidClickMore();
    }
    if ([self.delegate respondsToSelector:@selector(DidClickMore)]) {
        [self.delegate DidClickMore];
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

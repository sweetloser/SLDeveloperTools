//
//  BXAiteFriendCell.m
//  BXlive
//
//  Created by bxlive on 2019/5/9.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAiteFriendCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLCategory/SLCategory.h"
#import <SDWebImage/SDWebImage.h>
#import "../SLMacro/SLMacro.h"


@interface BXAiteFriendCell()
@property (nonatomic , strong) UIImageView *iconImageView;//头像
@property (nonatomic , strong) UILabel *nicknameLabel;//姓名
@end

@implementation BXAiteFriendCell

+ (instancetype)cellWithTableView :(UITableView *)tableView{
    static NSString *cellIdentifier = @"BXAiteFriendCell";
    BXAiteFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BXAiteFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 26;
    self.nicknameLabel = [UILabel initWithFrame:CGRectZero size:14 color:MainTitleColor alignment:NSTextAlignmentLeft lines:1];
    [self.contentView sd_addSubviews:@[self.iconImageView,self.nicknameLabel]];
    
    self.iconImageView.sd_layout.leftSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).widthIs(52).heightEqualToWidth();
    
    self.nicknameLabel.sd_layout.leftSpaceToView(self.iconImageView, 12).centerYEqualToView(self.contentView).heightIs(20).rightSpaceToView(self.contentView, 20);
}

-(void)setModel:(BXAttentFollowModel *)model{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"placeplaceholder")];
    self.nicknameLabel.text = model.nickname;
}

@end

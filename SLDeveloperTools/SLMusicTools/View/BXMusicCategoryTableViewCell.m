//
//  BXMusicCategoryTableViewCell.m
//  BXlive
//
//  Created by bxlive on 2019/4/17.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicCategoryTableViewCell.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
//
@interface BXMusicCategoryTableViewCell ()
@property (nonatomic , strong) UIImageView *iconImageView;
@property (nonatomic , strong) UILabel * titleLabel;
@end

@implementation BXMusicCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCellView];
    }
    return self;
}

- (void)initCellView{
    _iconImageView = [[UIImageView alloc]init];
    _titleLabel = [UILabel initWithFrame:CGRectZero size:16 color:WhiteBgTitleColor alignment:NSTextAlignmentLeft lines:1];
    [self.contentView sd_addSubviews:@[_iconImageView,_titleLabel]];
    _iconImageView.sd_layout.leftSpaceToView(self.contentView, 16).centerYEqualToView(self.contentView).widthIs(28).heightIs(28);
    _titleLabel.sd_layout.leftSpaceToView(_iconImageView, 12).centerYEqualToView(self.contentView).widthIs(100).heightIs(48);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"BXMusicCategoryTableViewCell";
    BXMusicCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[BXMusicCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(void)setModel:(BXMusicCategoryModel *)model{
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.icon]] placeholderImage:[UIImage imageNamed:@""]];
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
}

@end

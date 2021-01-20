//
//  BXSearchTagCell.m
//  BXlive
//
//  Created by mac on 2020/9/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXSearchTagCell.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>


@interface BXSearchTagCell()
@property(nonatomic, strong)UIImageView *titleImageView;
@property(nonatomic, strong)UILabel *titlelable;
@end
@implementation BXSearchTagCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}
-(void)setView{
    _titleImageView = [UIImageView new];
    _titleImageView.contentMode=UIViewContentModeScaleAspectFill;
    _titleImageView.clipsToBounds=YES;
    _titlelable = [[UILabel alloc]init];
    _titlelable.textColor = [UIColor blackColor];
    _titlelable.font = SLBFont(16);
    _titlelable.textAlignment = 0;
    
    [self.contentView sd_addSubviews:@[_titleImageView, _titlelable]];
    self.titleImageView.sd_layout.topSpaceToView(self.contentView, 12).leftSpaceToView(self.contentView, 12).widthIs(20).heightIs(20);
    self.titlelable.sd_layout.leftSpaceToView(self.titleImageView, 10).centerYEqualToView(self.titleImageView).heightIs(15).widthIs(150);
    
    [self updateLayout];
    [self setupAutoHeightWithBottomView:self.titleImageView bottomMargin:12];
}
-(void)setModel:(BXDynamicModel *)model{
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.msgdetailmodel.icon] placeholderImage:CImage( @"placeplaceholder")];
    self.titlelable.text = model.msgdetailmodel.content;
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

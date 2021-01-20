//
//  BXDynShareLiveCell.m
//  BXlive
//
//  Created by mac on 2020/7/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynShareLiveCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <YYCategories/YYCategories.h>
@interface BXDynShareLiveCell()
@property(nonatomic, strong)UIImageView *titleImageView;
@property(nonatomic, strong)UILabel *titlelable;
@property(nonatomic, strong)UILabel *concentlable;
@end
@implementation BXDynShareLiveCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}
-(void)setView{
    UIView *backview = [[UIView alloc]init];
    backview.backgroundColor = UIColorHex(#F5F9FC);
    [self.concenterBackview sd_addSubviews:@[backview]];
    backview.sd_layout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).rightEqualToView(self.concenterBackview).bottomEqualToView(self.concenterBackview);
    
    _titleImageView = [[UIImageView alloc]init];
    _titleImageView.backgroundColor = UIColorHex(#F5F9FC);
    
    _titlelable = [[UILabel alloc]init];
    _titlelable.textAlignment = 0;
    _titlelable.font = [UIFont systemFontOfSize:16];
    _titlelable.textColor = UIColorHex(#282828);
    
    _concentlable = [[UILabel alloc]init];
    _concentlable.textAlignment = 0;
    _concentlable.font = [UIFont systemFontOfSize:14];
    _concentlable.textColor = UIColorHex(#8C8C8C);
    
    [backview sd_addSubviews:@[_titleImageView, _titlelable, _concentlable]];
    _titleImageView.sd_layout.leftSpaceToView(backview, 10).topSpaceToView(backview, 8).widthIs(66).heightIs(66);
    _titlelable.sd_layout.leftSpaceToView(_titleImageView, 15).rightSpaceToView(backview, 15).topSpaceToView(backview, 15).heightIs(22);
    _concentlable.sd_layout.leftSpaceToView(_titleImageView, 15).rightSpaceToView(backview, 15).topSpaceToView(_titlelable, 10).heightIs(22);
}
-(void)updateCenterView{
    self.concenterBackview.sd_layout.heightIs(82);
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

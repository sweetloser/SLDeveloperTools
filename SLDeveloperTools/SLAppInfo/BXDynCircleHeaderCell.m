//
//  BXDynCircleHeaderCell.m
//  BXlive
//
//  Created by mac on 2020/8/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleHeaderCell.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>

@interface BXDynCircleHeaderCell()
@property(nonatomic, strong)UIImageView *coverImage;
@property(nonatomic, strong)UILabel *titlelabel;
@property(nonatomic, strong)UILabel *numlabel;
@end
@implementation BXDynCircleHeaderCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}
-(void)initView{
    _coverImage = [[UIImageView alloc]init];
    _coverImage.layer.masksToBounds = YES;
    _coverImage.layer.cornerRadius = 5;
    
    
    _titlelabel = [[UILabel alloc]init];
    _titlelabel.textColor = sl_textColors;
    _titlelabel.textAlignment = 1;
    _titlelabel.font = [UIFont systemFontOfSize:14];
    
    _numlabel = [[UILabel alloc]init];
    _numlabel.textColor = sl_textSubColors;
    _numlabel.textAlignment = 1;
    _numlabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView sd_addSubviews:@[_coverImage, _titlelabel, _numlabel]];
    _coverImage.sd_layout.leftSpaceToView(self.contentView, 12).rightSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 12).widthIs(( __kWidth - 48 ) / 3 - 24).heightEqualToWidth();
    _titlelabel.sd_layout.leftEqualToView(_coverImage).rightEqualToView(_coverImage).topSpaceToView(_coverImage, 9).heightIs(20);
    _numlabel.sd_layout.leftEqualToView(_coverImage).rightEqualToView(_coverImage).topSpaceToView(_titlelabel, 5).heightIs(17);
    
}
-(void)setModel:(BXDynCircleModel *)model{
    [ _coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",model.circle_cover_img]] placeholderImage:CImage( @"placeplaceholder")];
    _titlelabel.text = model.circle_name;
    _numlabel.text = [NSString stringWithFormat:@"%@人", model.follow];
}
@end

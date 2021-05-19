//
//  MorePicCollectionViewCell.m
//  BXlive
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import "MorePicCollectionViewCell.h"
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMacro/SLMacro.h"

@interface MorePicCollectionViewCell()
@end
@implementation MorePicCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _CoverimageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    _CoverimageView.layer.cornerRadius = 5;
    _CoverimageView.layer.masksToBounds = YES;
    _CoverimageView.contentMode=UIViewContentModeScaleAspectFill;
    _CoverimageView.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
    _CoverimageView.backgroundColor = sl_subBGColors;
    [self.contentView addSubview:_CoverimageView];
    
    _identificationImage = [[UIImageView alloc]init];
    _identificationImage.hidden = YES;
    [_CoverimageView addSubview:_identificationImage];
    self.identificationImage.sd_layout.rightEqualToView(self.CoverimageView).bottomEqualToView(self.CoverimageView).heightIs(20).widthIs(40);
}
-(void)setModel:(BXDynamicModel *)model{
    
}
@end

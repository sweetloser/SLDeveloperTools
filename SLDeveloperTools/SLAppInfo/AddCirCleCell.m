//
//  AddCirCleCell.m
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "AddCirCleCell.h"
#import <Masonry.h>
#import <YYCategories/YYCategories.h>
#import "../SLMacro/SLMacro.h"
#import <SDWebImage/SDWebImage.h>

@interface AddCirCleCell()
@property(nonatomic, strong)UIImageView *titleImage;
@property(nonatomic, strong)UILabel *titleLable;
@property(nonatomic, strong)UILabel *numLable;
@end
@implementation AddCirCleCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView{
    UIView *backView = [[UIView alloc]init];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = UIColorHex(#F5F9FC);
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.contentView);
    }];
    
    _titleImage = [[UIImageView alloc]init];
    _titleImage.layer.cornerRadius = 5;
    _titleImage.layer.masksToBounds = YES;
    [backView addSubview:_titleImage];
    [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView.mas_centerX);
        make.top.mas_equalTo(backView.mas_top).offset(__ScaleWidth(13));
        make.height.width.mas_equalTo(__ScaleWidth(82));
        
    }];
    
    _titleLable = [[UILabel alloc]init];
    _titleLable.textColor = UIColorHex(#282828);
    _titleLable.font = [UIFont systemFontOfSize:14];
    _titleLable.textAlignment = 1;
    [backView addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView.mas_centerX);
        make.top.mas_equalTo(_titleImage.mas_bottom).offset(__ScaleWidth(8));
        make.width.mas_equalTo(__ScaleWidth(93));
        make.height.mas_equalTo(__ScaleWidth(20));
    }];
    
    _numLable = [[UILabel alloc]init];
    _numLable.textAlignment = 1;
    _numLable.textColor = UIColorHex(#8C8C8C);
    _numLable.font = [UIFont systemFontOfSize:12];
    [backView addSubview:_numLable];
    [_numLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView.mas_centerX);
        make.top.mas_equalTo(_titleLable.mas_bottom).offset(__ScaleWidth(2));
        make.width.mas_equalTo(__ScaleWidth(93));
        make.height.mas_equalTo(__ScaleWidth(17));
    }];

}
-(void)setModel:(BXDynCircleModel *)model{
    [_titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",model.circle_cover_img]] placeholderImage:CImage(@"placeplaceholder")];
    _titleLable.text = model.circle_name;
    _numLable.text = [NSString stringWithFormat:@"%@人",model.follow];
}
@end

//
//  BXDynNearHeaderCell.m
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynNearHeaderCell.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <SDWebImage/SDWebImage.h>

@interface BXDynNearHeaderCell()
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UILabel *titleLable;
@property(nonatomic, strong)UILabel *numLabel;
@end
@implementation BXDynNearHeaderCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _imageView = [[UIImageView alloc]init];
//    _imageView.backgroundColor = [UIColor randomColor];
    _imageView.layer.cornerRadius = 5;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(12);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    _titleLable = [[UILabel alloc]init];
    _titleLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
//    _titleLable.backgroundColor = [UIColor randomColor];
    [self.contentView addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10);
        make.top.mas_equalTo(self.imageView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        make.height.mas_equalTo(20);
    }];
    
    _numLabel = [[UILabel alloc]init];
    _numLabel.textColor = sl_textSubColors;
    _numLabel.font = [UIFont systemFontOfSize:12];
//    _numLabel.backgroundColor = [UIColor randomColor];
    [self.contentView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLable.mas_left);
        make.top.mas_equalTo(self.titleLable.mas_bottom);
        make.right.mas_equalTo(self.titleLable.mas_right);
        make.height.mas_equalTo(20);
    }];
}
-(void)setModel:(BXDynTopicModel *)model{
    _titleLable.text = [NSString stringWithFormat:@"#%@", model.topic_name];
    if ([model.is_local_img isEqualToString:@"1"]) {
        _numLabel.text = [NSString stringWithFormat:@"%@", model.dynamic];
        _imageView.image = CImage(@"icon_dyn_topic_square");
    }else{
        _numLabel.text = [NSString stringWithFormat:@"%@条动态", model.dynamic];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CImage(@"placeplaceholder")];
    }
}
@end

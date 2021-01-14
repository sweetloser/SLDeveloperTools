//
//  DetailSendcomCollectionViewCell.m
//  BXlive
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailSendcomCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <SDWebImage/SDWebImage.h>

@interface DetailSendcomCollectionViewCell()
@property(nonatomic, strong)UIButton *Delbtn;
@end
@implementation DetailSendcomCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createview];
        self.contentView.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
    }
    return self;
}
-(void)createview{
    _picImage = [[UIImageView alloc]init];
    _picImage.layer.cornerRadius = 5;
    _picImage.contentMode = UIViewContentModeScaleAspectFill;
    _picImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_picImage];
    [_picImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.contentView);
    }];
    
    _Delbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _Delbtn.backgroundColor = [UIColor clearColor];
    _Delbtn.contentMode = UIViewContentModeScaleAspectFit;
    [_Delbtn setImage:[UIImage imageNamed:@"dyn_comment_Del_addPic"] forState:UIControlStateNormal];
    [_Delbtn addTarget:self action:@selector(delPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_Delbtn];
    [_Delbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.width.height.mas_equalTo(7);
    }];
}
-(void)setPicImage:(UIImageView *)picImage{
    _picImage = picImage;
}
-(void)setPicurl:(NSString *)picurl{
//    NSString *picstr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",picurl];
    NSString *picstr = [NSString stringWithFormat:@"%@",picurl];
    [_picImage sd_setImageWithURL:[NSURL URLWithString:picstr]];
}
-(void)setType:(NSString *)type{
    if ([type isEqualToString:@"1"]) {
        _Delbtn.hidden = YES;
    }
    else{
        _Delbtn.hidden = NO;
    }
}
-(void)delPicture{
    if (_DelPicture) {
        self.DelPicture();
    }
}
@end

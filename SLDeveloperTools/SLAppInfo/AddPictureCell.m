//
//  AddPictureCell.m
//  BXlive
//
//  Created by mac on 2020/7/10.
//  Copyright © 2020 cat. All rights reserved.
//

#import "AddPictureCell.h"
#import "AddPicturePhotoShow.h"
#import "HZPhotoBrowser.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
@interface AddPictureCell()
@property(nonatomic, strong)UIButton *Delbtn;
@property (nonatomic,strong) AddPicturePhotoShow *groupView;
@end
@implementation AddPictureCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.groupView];
        [self createview];
        self.contentView.backgroundColor = UIColorHex(#F5F9FC);
    }
    return self;
}
-(void)createview{
    _picImage = [[FLAnimatedImageView alloc]init];
    _picImage.layer.cornerRadius = 5;
    _picImage.layer.masksToBounds = YES;
    _picImage.contentMode=UIViewContentModeScaleAspectFill;
    _picImage.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
    [self.contentView addSubview:_picImage];
    [_picImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.contentView);
    }];
    
    _Delbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _Delbtn.backgroundColor = [UIColor clearColor];
    _Delbtn.contentMode = UIViewContentModeScaleAspectFit;
    [_Delbtn setImage:[UIImage imageNamed:@"picture_delete_right_row"] forState:UIControlStateNormal];
    [_Delbtn addTarget:self action:@selector(delPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_Delbtn];
    [_Delbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.width.height.mas_equalTo(18);
    }];
}
- (AddPicturePhotoShow *)groupView{
    if (!_groupView) {
        _groupView = [[AddPicturePhotoShow alloc] initWithFrame:self.bounds];
    }
    return _groupView;
}
//-(void)setPicImage:(UIImageView *)picImage{
//    _picImage = picImage;
//}
-(void)setImageArray:(NSArray<UIImage *> *)imageArray{
    _imageArray = imageArray;
    self.groupView.imageArray = imageArray;
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



- (void)tap:(NSInteger)index
{

    //启动图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = NO;
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.currentImageIndex = (int)index;
    browser.imageCount = _imageArray.count - 1; // 图片总数
    [browser show];
}
@end

//
//  AddPicturePhotoShow.m
//  BXlive
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import "AddPicturePhotoShow.h"
#import "HZPhotoBrowser.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
@interface AddPicturePhotoShow()<HZPhotoBrowserDelegate>
@end
@implementation AddPicturePhotoShow
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
                 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexAct:) name:@"showDynPhoto" object:nil];
    }
    return self;
}
-(void)setImageArray:(NSArray<UIImage *> *)imageArray{
    _imageArray = imageArray;
    //清除所有子控件，根据数据重新布局
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        //默认占位图whiteplaceholder必须设置，否则在小图都没有加载成功时候，点击展示图片浏览器会崩溃
        imageView.image = obj;
        
//        imageView.tag = idx;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//        [imageView addGestureRecognizer:tap];
        
        [self addSubview:imageView];
    }];
}
- (void)indexAct:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSInteger index = [info[@"index"] integerValue];
    [self click:index];
}
-(void)click:(NSInteger)index{
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = NO;
    browser.hiddenbottom = YES;
    browser.hiddenSavebottom = YES;
    browser.delegate = self;
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.currentImageIndex = (int)index;
    browser.imageCount = _imageArray.count; // 图片总数
    [browser show];
}
- (void)tap:(UIGestureRecognizer *)gesture
{
    FLAnimatedImageView *imageView = (FLAnimatedImageView *)gesture.view;
    //启动图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = NO;
    browser.hiddenbottom = YES;
    browser.hiddenSavebottom = YES;
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.currentImageIndex = (int)imageView.tag;
    browser.imageCount = _imageArray.count; // 图片总数
    [browser show];
}
#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
//    FLAnimatedImageView *imageView = (FLAnimatedImageView *)self.subviews[index];
    
    return _imageArray[index];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

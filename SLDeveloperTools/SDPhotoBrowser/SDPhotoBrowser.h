//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SDPhotoBrowserStyle){
    // None
    SDPhotoBrowserStyleNone = 1,
    //顶部Label
    SDPhotoBrowserStyleIndexLabel = 2,
    //All
    SDPhotoBrowserStyleAll =  3
};


@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@optional
//设置头像
- (void)photoBrowser:(SDPhotoBrowser *)browser setAvatar:(NSInteger)avatar;
- (void)photoBrowser:(SDPhotoBrowser *)browser delteAvatar:(NSInteger)avatar;
@end


@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic , assign) SDPhotoBrowserStyle browserStyle;
@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

- (void)show;

@end

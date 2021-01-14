//
//  HZPhotoBrowser.h
//  photobrowser
//
//  Created by huangzhenyu on 15-2-3.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLDeveloperTools/SLDeveloperTools.h>

@class HZButton, HZPhotoBrowser;

//配置小图和大图
@protocol HZPhotoBrowserDelegate <NSObject>
@required
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
@end


@interface HZPhotoBrowser : UIView <UIScrollViewDelegate>
//第一种展示方式（退出时能回到原来的位置），需要定义九图控件，下面两个参数必传
@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger imageCount;

//@property (nonatomic, strong) BXDynamicModel *model;
@property (nonatomic, strong) NSString *fcmid;//评论内容id
@property (nonatomic, assign) BOOL hiddenbottom;
@property (nonatomic, assign) BOOL hiddenSavebottom;

//第二种展示方式（退出时不能回到原来的位置，默认回到屏幕正中央）直接传url,图片url列表必传
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *SmallImageArray;

@property (nonatomic,strong) NSArray *imageDataArray;

//从第几张图片开始展示，默认 0（第一种或者第二种方式展示都必须传）
@property (nonatomic, assign) int currentImageIndex;
//是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES(默认值YES)
@property (nonatomic, assign) BOOL isFullWidthForLandScape;
//是否支持横竖屏，默认支持（YES）
@property (nonatomic, assign) BOOL isNeedLandscape;
@property (nonatomic, weak) id<HZPhotoBrowserDelegate> delegate;

@property(nonatomic,copy)void (^DidClick)(NSInteger type);//0喜欢 1评论 2分享
@property(nonatomic,copy)void (^LikeClick)(void);
@property(nonatomic,copy)void (^ShareClick)(void);
- (void)show;

-(void)updateLikeImage:(UIImage *)image;
-(void)updateLikeNumlableText:(NSString *)text;
-(void)updateCommentNumlableText:(NSString *)text;

@end

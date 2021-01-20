//
//  HZPhotoBrowser.m
//  photobrowser
//
//  Created by huangzhenyu on 15-2-3.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.
//

#import "HZPhotoBrowser.h"
#import "HZPhotoBrowserView.h"
#import "HZPhotoBrowserConfig.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Masonry/Masonry.h>
#import "BGProgressHUD.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <YYCategories/YYCategories.h>
#import "HttpMakeFriendRequest.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
//#import "DynSharePopViewManager.h"
@interface HZPhotoBrowser()
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,strong) UIImageView *tempView;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) HZPhotoBrowserView *photoBrowserView;
@property (nonatomic,assign) UIDeviceOrientation orientation;
@property (nonatomic,assign) HZPhotoBrowserStyle photoBrowserStyle;

@property(nonatomic, strong)UIImageView *likeImage;
@property(nonatomic, strong)UILabel *likeNumlable;
@property(nonatomic, strong)UILabel *commentNumlable;
@property(nonatomic, strong)UIImageView *maskImageView;
//icon_dyn_photo_masking
@end
@implementation HZPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;//开始展示图片浏览器
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIView *_contentView;
    
    UIButton *_backButton;
    UIImageView *_comimage;
    UIImageView *_shareimage;
}

#pragma mark recyle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.isFullWidthForLandScape = YES;
        self.isNeedLandscape = YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendChangeStatus:) name:TMSeedLikeStatus object:nil];
    }
    
    return self;
}


//-(void)setModel:(BXDynamicModel *)model{
//    _model = model;
//     _likeNumlable.text = [NSString stringWithFormat:@"%@", model.msgdetailmodel.like_num];
//    _commentNumlable.text = [NSString stringWithFormat:@"%@", model.msgdetailmodel.comment_num];
//    if ([[NSString stringWithFormat:@"%@",_model.msgdetailmodel.extend_already_live] isEqualToString:@"1"]) {
//        _likeImage.image = CImage(@"dyn_issue_liked");
//    }else{
//        _likeImage.image = CImage(@"dyn_issue_like_whiteBack");
//    }
//}

-(void)updateLikeImage:(UIImage *)image;{
    _likeImage.image = image;
}
-(void)updateLikeNumlableText:(NSString *)text{
    _likeNumlable.text = text;
}
-(void)updateCommentNumlableText:(NSString *)text{
    _commentNumlable.text = text;
}

//当视图移动完成后调用
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    //处理下标可能越界的bug
    _currentImageIndex = _currentImageIndex < 0 ? 0 : _currentImageIndex;
    NSInteger count = _imageCount - 1;
    if (count > 0) {
        if (_currentImageIndex > count) {
            _currentImageIndex = 0;
        }
    }
    [self setupScrollView];
    [self setupToolbars];
    [self addGestureRecognizer:self.singleTap];
    [self addGestureRecognizer:self.doubleTap];
    [self addGestureRecognizer:self.pan];
    self.photoBrowserView = _scrollView.subviews[self.currentImageIndex];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"layoutSubviews -- ");
    CGRect rect = self.bounds;
    rect.size.width += HZPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
    _scrollView.center = CGPointMake(self.bounds.size.width *0.5, self.bounds.size.height *0.5);
    NSLog(@"%@",NSStringFromCGRect(_scrollView.frame));
    CGFloat y = 0;
    __block CGFloat w = _scrollView.frame.size.width - HZPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    [_scrollView.subviews enumerateObjectsUsingBlock:^(HZPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = HZPhotoBrowserImageViewMargin + idx * (HZPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    _indexLabel.frame = CGRectMake((self.bounds.size.width - 80)*0.5, 20 + __kTopAddHeight + 12, 80, 30);
    
    _saveButton.frame = CGRectMake(self.bounds.size.width - 32, self.bounds.size.height - 70, 20, 20);
    _tipLabel.frame = CGRectMake((self.bounds.size.width - 150)*0.5, (self.bounds.size.height - 40)*0.5, 150, 40);
}

- (void)dealloc
{
    NSLog(@"图片浏览器销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setSourceImagesContainerView:(UIView *)sourceImagesContainerView{
    _sourceImagesContainerView = sourceImagesContainerView;
    _imageArray = nil;
    _photoBrowserStyle = HZPhotoBrowserStyleDefault;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    _imageCount = imageArray.count;
    _sourceImagesContainerView = nil;
    _photoBrowserStyle = HZPhotoBrowserStyleSimple;
}
-(void)setImageDataArray:(NSArray *)imageDataArray{
    _imageDataArray = imageDataArray;
    _imageCount = imageDataArray.count;
    _sourceImagesContainerView = nil;
    _photoBrowserStyle = HZPhotoBrowserStyleImageData;
}
#pragma mark getter settter
- (UITapGestureRecognizer *)singleTap{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        //只能有一个手势存在
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
//        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

- (UIPanGestureRecognizer *)pan{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    }
    return _pan;
}

- (UIImageView *)tempView{
    if (!_tempView) {
        HZPhotoBrowserView *photoBrowserView = _scrollView.subviews[self.currentImageIndex];
        UIImageView *currentImageView = photoBrowserView.imageview;
        CGFloat tempImageX = currentImageView.frame.origin.x - photoBrowserView.scrollOffset.x;
        CGFloat tempImageY = currentImageView.frame.origin.y - photoBrowserView.scrollOffset.y;
        
        CGFloat tempImageW = photoBrowserView.zoomImageSize.width;
        CGFloat tempImageH = photoBrowserView.zoomImageSize.height;
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsLandscape(orientation)) {//横屏
            
            //处理长图,图片太长会导致旋转动画飞掉
            if (tempImageH > kSCREEN_HEIGHT) {
                tempImageH = tempImageH > (tempImageW * 1.5)? (tempImageW * 1.5):tempImageH;
                if (fabs(tempImageY) > tempImageH) {
                    tempImageY = 0;
                }
            }

        }
        
        _tempView = [[UIImageView alloc] init];
        //这边的contentmode要跟 HZPhotoGrop里面的按钮的 contentmode保持一致（防止最后出现闪动的动画）
        _tempView.contentMode = UIViewContentModeScaleAspectFill;
        _tempView.clipsToBounds = YES;
        _tempView.frame = CGRectMake(tempImageX, tempImageY, tempImageW, tempImageH);
        _tempView.image = currentImageView.image;
    }
    return _tempView;
}

//做颜色渐变动画的view，让退出动画更加柔和
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = HZPhotoBrowserBackgrounColor;
    }
    return _coverView;
}

- (void)setPhotoBrowserView:(HZPhotoBrowserView *)photoBrowserView{
    _photoBrowserView = photoBrowserView;
    @weakify(self);
    _photoBrowserView.scrollViewWillEndDragging = ^(CGPoint velocity,CGPoint offset) {
        @strongify(self);
        if (((velocity.y < -2 && offset.y < 0) || offset.y < -100)) {
            [self hidePhotoBrowser];
        }
    };
}

- (void)setCurrentImageIndex:(int)currentImageIndex{
    _currentImageIndex = currentImageIndex < 0 ? 0 : currentImageIndex;
    NSInteger count0 = _imageCount;
    NSInteger count1 = _imageArray.count;
    if (count0 > 0) {
        if (_currentImageIndex > count0) {
            _currentImageIndex = 0;
        }
    }
    if (count1 > 0) {
        if (_currentImageIndex > count1) {
            _currentImageIndex = 0;
        }
    }
}

#pragma mark private methods
- (void)setupToolbars
{
    
    [self addSubview:self.maskImageView];
    //返回
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"icon_return_white"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(12));
        make.width.height.mas_equalTo(18.5);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:14];
    indexLabel.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.6];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.center = CGPointMake(kSCREEN_WIDTH * 0.5, 20 + __kTopAddHeight + 12 + 15);
    indexLabel.layer.cornerRadius = 15;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
        _indexLabel = indexLabel;
        [self addSubview:indexLabel];
    }

    // 2.保存按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [saveButton setImage:[UIImage imageNamed:@"dyn_issue_savePicture"] forState:UIControlStateNormal];

    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
    if (self.hiddenSavebottom) {
        _saveButton.hidden = YES;
    }
    
    _likeImage = [[UIImageView alloc]init];
//    if ([[NSString stringWithFormat:@"%@",_model.msgdetailmodel.extend_already_live] isEqualToString:@"1"]) {
//        _likeImage.image = CImage(@"dyn_issue_liked");
//    }else{
//        _likeImage.image = CImage(@"dyn_issue_like_whiteBack");
//    }
    UITapGestureRecognizer *liketap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeAct:)];
    [_likeImage addGestureRecognizer:liketap];
    _likeImage.userInteractionEnabled = YES;
    [self addSubview:_likeImage];
    [_likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-50);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(19);
    }];
    if (self.hiddenbottom) {
        _likeImage.hidden = YES;
    }
    
    _likeNumlable = [[UILabel alloc]init];
    _likeNumlable.font = [UIFont systemFontOfSize:14];
    _likeNumlable.textAlignment = 0;
    _likeNumlable.textColor = [UIColor whiteColor];
//    _likeNumlable.text = [NSString stringWithFormat:@"%@", _model.msgdetailmodel.like_num];
    [self addSubview:_likeNumlable];
    [_likeNumlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_likeImage.mas_right).offset(5);
        make.bottom.mas_equalTo(_likeImage.mas_bottom);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    if (self.hiddenbottom) {
        _likeNumlable.hidden = YES;
    }
    
    
    _comimage = [[UIImageView alloc]init];
    _comimage.image = [UIImage imageNamed:@"dyn_issue_recommend_whiteBack"];
    UITapGestureRecognizer *comtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comAct:)];
    [_comimage addGestureRecognizer:comtap];
    _comimage.userInteractionEnabled = YES;
    [self addSubview:_comimage];
    [_comimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_likeNumlable.mas_right).offset(5);
        make.bottom.mas_equalTo(_likeNumlable.mas_bottom);
        make.width.height.mas_equalTo(21);
    }];
    if (self.hiddenbottom) {
        _comimage.hidden = YES;
    }
    
    
    _commentNumlable = [[UILabel alloc]init];
    _commentNumlable.font = [UIFont systemFontOfSize:14];
    _commentNumlable.textColor = [UIColor whiteColor];
    _commentNumlable.textAlignment = 0;
//    _commentNumlable.text = [NSString stringWithFormat:@"%@", _model.msgdetailmodel.comment_num];
    [self addSubview:_commentNumlable];
    [_commentNumlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_comimage.mas_right).offset(5);
        make.bottom.mas_equalTo(_comimage.mas_bottom);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    if (self.hiddenbottom) {
        _commentNumlable.hidden = YES;
    }
    
    
    
    _shareimage = [[UIImageView alloc]init];
    _shareimage.image = [UIImage imageNamed:@"dyn_issue_share_whiteBack"];
    UITapGestureRecognizer *sharetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareAct:)];
    [_shareimage addGestureRecognizer:sharetap];
    _shareimage.userInteractionEnabled = YES;
    [self addSubview:_shareimage];
    [_shareimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_commentNumlable.mas_right).offset(5);
        make.bottom.mas_equalTo(_commentNumlable.mas_bottom);
        make.width.height.mas_equalTo(21);
    }];
    if (self.hiddenbottom) {
         _shareimage.hidden = YES;
     }
}
//分享
-(void)shareAct:(id)sender{
    if (self.ShareClick) {
        self.ShareClick();
        return;
    }
//    [DynSharePopViewManager shareWithVideoId:[self.model fcmid] user_Id:@"" likeNum:@"" is_zan:@"" is_collect:@"" is_follow:@"" vc:self.viewController type:1 share_type:@"dynamic"];

}
//收藏
-(void)likeAct:(id)sender{
    if (self.LikeClick) {
        self.LikeClick();
        return;
    }
//    WS(weakSelf);
//    [HttpMakeFriendRequest GiveLikeWithfcmid:[self.model fcmid] Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
//        if (flag) {
//            if ([[NSString stringWithFormat:@"%@",weakSelf.model.msgdetailmodel.extend_already_live] isEqualToString:@"1"]) {
//                weakSelf.model.msgdetailmodel.extend_already_live = @"0";
//                NSInteger like_num = [weakSelf.model.msgdetailmodel.like_num integerValue] - 1;
//                weakSelf.model.msgdetailmodel.like_num = [NSString stringWithFormat:@"%ld", (long)like_num];
//
//                weakSelf.likeImage.image = CImage(@"dyn_issue_like_whiteBack");
//                weakSelf.likeNumlable.text = [NSString stringWithFormat:@"%ld", (long)like_num];
//
//            }else{
//                weakSelf.likeImage.image = CImage(@"dyn_issue_liked");
//                weakSelf.model.msgdetailmodel.extend_already_live = @"1";
//                NSInteger like_num = [weakSelf.model.msgdetailmodel.like_num integerValue] + 1;
//                weakSelf.model.msgdetailmodel.like_num = [NSString stringWithFormat:@"%ld", (long)like_num];
//                weakSelf.likeNumlable.text = [NSString stringWithFormat:@"%ld", (long)like_num];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:DynamdicLikeStatusNotification object:nil userInfo:@{@"model":self.model}];
//        }else{
//            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
//        }
//    } Failure:^(NSError * _Nonnull error) {
//        [BGProgressHUD showInfoWithMessage:@"操作失败"];
//    }];
}
-(void)setHiddenbottom:(BOOL)hiddenbottom{
    _hiddenbottom = hiddenbottom;
    if (hiddenbottom) {
        _likeImage.hidden = YES;
        _likeNumlable.hidden = YES;
        _comimage.hidden = YES;
        _commentNumlable.hidden = YES;
        _shareimage.hidden = YES;
    }
}
-(void)setHiddenSavebottom:(BOOL)hiddenSavebottom{
    _hiddenSavebottom = hiddenSavebottom;
    if (hiddenSavebottom) {
        _saveButton.hidden = YES;
    }
}
//评论
-(void)comAct:(id)sender{

    if (self.DidClick) {
        [self hidePhotoBrowser];
        self.DidClick(1);
    }
}
//保存图像
- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    HZPhotoBrowserView *currentView = _scrollView.subviews[index];
    if (currentView.hasLoadedImage) {
        FLAnimatedImageView *animatedImageView;
        if ([currentView.imageview isKindOfClass:[FLAnimatedImageView class]]) {
            animatedImageView = (FLAnimatedImageView *)currentView.imageview;
            NSData *imageData = animatedImageView.animatedImage.data;
            if (!imageData) {
                imageData = UIImagePNGRepresentation(animatedImageView.image);
            }
            if (!imageData) {
                [self showTip:HZPhotoBrowserSaveImageFailText];
                return;
            }
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            NSDictionary *metadata = @{@"UTI":(__bridge NSString *)kUTTypeImage} ;
            [library writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
                if (error) {
                    // "保存图片失败"
//                    [self showTip:HZPhotoBrowserSaveImageFailText];
                    [BGProgressHUD showInfoWithMessage:@"保存失败"];
                }else{
                    //保存图片成功"
//                    [self showTip:HZPhotoBrowserSaveImageSuccessText];
                    [BGProgressHUD showInfoWithMessage:@"保存成功"];
                }
            }] ;
        } else {
            UIImageWriteToSavedPhotosAlbum(currentView.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
        
    } else {
        [self showTip:HZPhotoBrowserSaveImageFailText];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (error) {
        [self showTip:HZPhotoBrowserSaveImageFailText];
    } else {
        [self showTip:HZPhotoBrowserSaveImageSuccessText];
    }
}

- (void)showTip:(NSString *)tipStr{
    if (_tipLabel) {
        [_tipLabel removeFromSuperview];
        _tipLabel = nil;
    }
    UILabel *label = [[UILabel alloc] init];
    _tipLabel = label;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = tipStr;
    [self addSubview:label];
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    for (int i = 0; i < self.imageCount; i++) {
        HZPhotoBrowserView *view = [[HZPhotoBrowserView alloc] init];
        view.isFullWidthForLandScape = self.isFullWidthForLandScape;
        view.imageview.tag = i;
        [_scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    HZPhotoBrowserView *view = _scrollView.subviews[index];
    if (view.beginLoadingImage) return;
    
    if (_photoBrowserStyle == HZPhotoBrowserStyleImageData) {
        [view setImageWithImage:_imageDataArray[index]];
         view.beginLoadingImage = YES;
        return;
    }
    
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index] placeholderURL:[NSURL URLWithString:self.SmallImageArray[index]]];
    } else {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}

- (void)onDeviceOrientationChangeWithObserver
{
    [self onDeviceOrientationChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)onDeviceOrientationChange
{
    if (!self.isNeedLandscape) {
        return;
    }
    
    HZPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    self.orientation = orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        if (self.bounds.size.width < self.bounds.size.height) {
            [currentView.scrollview setZoomScale:1.0 animated:YES];//还原
        }
        [UIView animateWithDuration:kRotateAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
            self.bounds = CGRectMake(0, 0, kSCREEN_HEIGHT, kSCREEN_WIDTH);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        
        }];
        
    }else if (orientation==UIDeviceOrientationPortrait){
        if (self.bounds.size.width > self.bounds.size.height) {
            [currentView.scrollview setZoomScale:1.0 animated:YES];//还原
        }
        [UIView animateWithDuration:kRotateAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
            self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)showFirstImage
{
    self.userInteractionEnabled = NO;
    @weakify(self);
    if (_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
//        UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
//        CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
        UIImageView *tempView = [[UIImageView alloc] init];
        tempView.frame = _sourceImagesContainerView.frame;
        tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
        [self addSubview:tempView];
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGFloat placeImageSizeW = tempView.image.size.width;
        CGFloat placeImageSizeH = tempView.image.size.height;
        CGRect targetTemp;
        CGFloat selfW = self.frame.size.width;
        CGFloat selfH = self.frame.size.height;
        
        CGFloat placeHolderH = (placeImageSizeH * selfW)/placeImageSizeW;
        if (placeHolderH <= selfH) {
            targetTemp = CGRectMake(0, (selfH - placeHolderH) * 0.5 , selfW, placeHolderH);
        } else {//图片高度>屏幕高度
            targetTemp = CGRectMake(0, 0, selfW, placeHolderH);
        }
        //先隐藏scrollview
        _scrollView.hidden = YES;
        _indexLabel.hidden = YES;
        _saveButton.hidden = YES;
        
        [UIView animateWithDuration:HZPhotoBrowserShowImageAnimationDuration animations:^{
            //将点击的临时imageview动画放大到和目标imageview一样大
            tempView.frame = targetTemp;
        } completion:^(BOOL finished) {
            @strongify(self);
            //动画完成后，删除临时imageview，让目标imageview显示
            self->_hasShowedFistView = YES;
            [tempView removeFromSuperview];
            self->_scrollView.hidden = NO;
            self->_indexLabel.hidden = NO;
            self->_saveButton.hidden = NO;
            self.userInteractionEnabled = YES;
        }];
    } else {
        _photoBrowserView.alpha = 0;
        _contentView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
             @strongify(self);
            //将点击的临时imageview动画放大到和目标imageview一样大
            self->_photoBrowserView.alpha = 1;
            self->_contentView.alpha = 1;
        } completion:^(BOOL finished) {
             @strongify(self);
            self->_hasShowedFistView = YES;
            self.userInteractionEnabled = YES;
        }];
    }
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
//    if (_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
            return [self.delegate photoBrowser:self placeholderImageForIndex:index];
        }
//    } else {
//        return nil;
//    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
//    if (_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
            return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
//        }
    } else {
        return [NSURL URLWithString:_imageArray[index]];
    }
    return nil;
}

- (NSURL *)ImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:_imageArray[index]];
}

- (void)hidePhotoBrowser
{
    [self prepareForHide];
    [self hideAnimation];
}

- (void)hideAnimation{
    self.userInteractionEnabled = NO;
    CGRect targetTemp;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *sourceView = [self getSourceView];
    if (!sourceView) {
        targetTemp = CGRectMake(window.center.x, window.center.y, 0, 0);
    }
    if (_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
        UIView *sourceView = [self getSourceView];
       targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    } else {
        //默认回到屏幕中央
        targetTemp = CGRectMake(window.center.x, window.center.y, 0, 0);
    }
    self.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    @weakify(self);
    [UIView animateWithDuration:HZPhotoBrowserHideImageAnimationDuration animations:^{
        @strongify(self);
        if (self->_photoBrowserStyle == HZPhotoBrowserStyleDefault) {
            self->_tempView.transform = CGAffineTransformInvert(self.transform);
        }
        self->_coverView.alpha = 0;
        self->_tempView.frame = targetTemp;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self->_tempView removeFromSuperview];
        [self->_scrollView removeFromSuperview];
        [self->_contentView removeFromSuperview];
        self->_tempView = nil;
        self->_scrollView = nil;
        self->_contentView = nil;
        sourceView.hidden = NO;

    }];
}

- (UIView *)getSourceView{
    if (_currentImageIndex <= self.sourceImagesContainerView.subviews.count - 1) {
        UIView *sourceView = self.sourceImagesContainerView.subviews[_currentImageIndex];
        return sourceView;
    }
    return nil;
}

- (void)prepareForHide{
    [_contentView insertSubview:self.coverView belowSubview:self];
    _backButton.hidden = YES;
    _likeImage.hidden = YES;
    _likeNumlable.hidden = YES;
    _comimage.hidden = YES;
    _commentNumlable.hidden = YES;
    _shareimage.hidden = YES;
    _saveButton.hidden = YES;
    _indexLabel.hidden = YES;
    [self addSubview:self.tempView];
    _photoBrowserView.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    UIView *view = [self getSourceView];
    view.hidden = YES;
}

- (void)bounceToOrigin{
    @weakify(self);
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:HZPhotoBrowserHideImageAnimationDuration animations:^{
        @strongify(self);
        self.tempView.transform = CGAffineTransformIdentity;
        self->_coverView.alpha = 1;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.userInteractionEnabled = YES;
        self->_backButton.hidden = NO;
        self->_likeImage.hidden = NO;
        self->_likeNumlable.hidden = NO;
        self->_comimage.hidden = NO;
        self->_commentNumlable.hidden = NO;
        self-> _shareimage.hidden = NO;
        self->_saveButton.hidden = NO;
        self->_indexLabel.hidden = NO;
        [self->_tempView removeFromSuperview];
        [self->_coverView removeFromSuperview];
        self->_tempView = nil;
        self->_coverView = nil;
        self->_photoBrowserView.hidden = NO;
        self.backgroundColor = [UIColor grayColor];
        self->_contentView.backgroundColor = HZPhotoBrowserBackgrounColor;
        UIView *view = [self getSourceView];
        view.hidden = NO;
        if (self.hiddenbottom) {
            self->_likeImage.hidden = YES;
            self->_likeNumlable.hidden = YES;
            self->_comimage.hidden = YES;
            self->_commentNumlable.hidden = YES;
            self-> _shareimage.hidden = YES;
        }
        if (self.hiddenSavebottom) {
            self->_saveButton.hidden = YES;
        }
    }];
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {

    NSInteger index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    NSLog(@"%ld",(long)index);
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)(index + 1), (long)self.imageCount];
    //预加载 前3张 后3张
    NSInteger left = index - 3;
    NSInteger right = index + 3;
    left = left>0?left : 0;
    right = right>self.imageCount?self.imageCount:right;
    
    for (NSInteger i = left; i < right; i++) {
         [self setupImageOfImageViewForIndex:i];
    }
    }
}

//scrollview结束滚动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    self.photoBrowserView = _scrollView.subviews[self.currentImageIndex];
    
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (HZPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
                view.scrollview.zoomScale = 1.0;
        }
    }
}

#pragma mark - tap
#pragma mark 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    [self hidePhotoBrowser];
}

#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    HZPhotoBrowserView *view = _scrollView.subviews[self.currentImageIndex];
    CGPoint touchPoint = [recognizer locationInView:self];
    if (view.scrollview.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;//需要放大的图片的Y点
        [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark 长按
- (void)didPan:(UIPanGestureRecognizer *)panGesture {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {//横屏不允许拉动图片
        return;
    }
    //transPoint : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。
    //locationPoint ： 手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置。
    //velocity： 手指在视图上移动的速度（x,y）, 正负也是代表方向。
    CGPoint transPoint = [panGesture translationInView:self];
//    CGPoint locationPoint = [panGesture locationInView:self];
    CGPoint velocity = [panGesture velocityInView:self];//速度
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self prepareForHide];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            _saveButton.hidden = YES;
            _indexLabel.hidden = YES;
            double delt = 1 - fabs(transPoint.y) / self.frame.size.height;
            delt = MAX(delt, 0);
            double s = MAX(delt, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(transPoint.x/s, transPoint.y/s);
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            self.tempView.transform = CGAffineTransformConcat(translation, scale);
            self.coverView.alpha = delt;
        }
            break;
        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled:
        {
            if (fabs(transPoint.y) > 220 || fabs(velocity.y) > 500) {//退出图片浏览器
                [self hideAnimation];
            } else {//回到原来的位置
                [self bounceToOrigin];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark public methods
- (void)show
{
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = HZPhotoBrowserBackgrounColor;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    _contentView.bounds = window.bounds;
    
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    window.windowLevel = UIWindowLevelStatusBar+10.0f;//隐藏状态栏
    [_contentView addSubview:self];
    
    
    [window addSubview:_contentView];
    
   
    
    [self performSelector:@selector(onDeviceOrientationChangeWithObserver) withObject:nil afterDelay:HZPhotoBrowserShowImageAnimationDuration + 0.2];
}
-(UIImageView *)maskImageView{
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc]init];
        _maskImageView.image = CImage(@"icon_dyn_photo_masking");
        _maskImageView.center = _contentView.center;
        _maskImageView.bounds = _contentView.bounds;
    }
    return _maskImageView;
}
#pragma mark 种草点赞
- (void)sendChangeStatus:(NSNotification *)noti {
//    NSDictionary *info = noti.userInfo;
//    BXDynamicModel *model = info[@"model"];
//    NSString *fcmid = [NSString stringWithFormat:@"%@", model.fcmid];
//    NSString *datafcmid = [NSString stringWithFormat:@"%@",[_model fcmid]];
//    if (IsEquallString(fcmid, datafcmid)) {
//        self.model = model;
//    }
}
@end

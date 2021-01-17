//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"
#import "ZZLActionSheetView.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>

//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"

//  =============================================

@implementation SDPhotoBrowser
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;//索引
    UIButton *_saveButton;//保存
    UIButton *_moreButton;//更多
    UIButton *_closeButton;//关闭
    UIActivityIndicatorView *_indicatorView;
    BOOL _willDisappear;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor sl_colorWithHex:0x676767 alpha:1];
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)dealloc
{
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 75, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = sl_whiteTextColors;
    indexLabel.font = SLBFont(14);
    indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
    indexLabel.clipsToBounds = YES;
    indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];
    
    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
    
    
    //更多按钮
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setImage:CImage(@"icon_genduo_white") forState:BtnNormal];
    _moreButton = moreButton;
    [self addSubview:moreButton];
    
    //关闭按钮
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:CImage(@"back_white") forState:BtnNormal];
    closeBtn.userInteractionEnabled = NO;
    _closeButton = closeBtn;
    [self addSubview:closeBtn];
    
    [self updateIndexVisible];
    
}

-(void)moreButtonClick{

    
    WS(ws);
    ZZLActionSheetView *action = [[ZZLActionSheetView alloc] initWithTitleView:nil optionsArr:@[@"设置头像",@"删除"] cancelTitle:@"取消" cancelBlock:^{
    } selectBlock:^(NSInteger index) {
        if (index==0) {
            if ([ws.delegate respondsToSelector:@selector(photoBrowser:setAvatar:)]) {
                [ws.delegate photoBrowser:ws setAvatar:ws.currentImageIndex];
            }
        }else{
            if ([ws.delegate respondsToSelector:@selector(photoBrowser:delteAvatar:)]) {
                [ws.delegate photoBrowser:ws delteAvatar:ws.currentImageIndex];
                ws.backgroundColor = [UIColor clearColor];
                [ws removeFromSuperview];
            }
        }
    }];
    [action show];
    
    
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
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
        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
        imageView.tag = i;
        
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSingleTaped:)];
        
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        
        if (self.browserStyle == SDPhotoBrowserStyleNone) {
            
        }else{
            UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewLongPress:)];
            longPressReger.minimumPressDuration = 1.0;
            [imageView addGestureRecognizer:longPressReger];
        }
        
        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    SDBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)imageViewSingleTaped:(UITapGestureRecognizer *)recognizer
{
    _scrollView.hidden = YES;
    _willDisappear = YES;
    
    if (self.browserStyle == SDPhotoBrowserStyleNone) {
        [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
            self.backgroundColor = [UIColor clearColor];
            self->_indexLabel.alpha = 0.1;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        return;
    }
    
    
    SDBrowserImageView *currentImageView = (SDBrowserImageView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = nil;
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        NSIndexPath *path = [NSIndexPath indexPathForItem:currentIndex inSection:0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
        sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    }
    
    
    
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    
    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    
    _saveButton.hidden = YES;
    
    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        self->_indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    SDBrowserImageView *imageView = (SDBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }
    
    SDBrowserImageView *view = (SDBrowserImageView *)recognizer.view;
    
    [view doubleTapToZommWithScale:scale];
}

-(void)imageViewLongPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state==UIGestureRecognizerStateBegan) {
        WS(ws);
        ZZLActionSheetView *action = [[ZZLActionSheetView alloc] initWithTitleView:nil optionsArr:@[@"设置头像",@"删除"] cancelTitle:@"取消" cancelBlock:^{
        } selectBlock:^(NSInteger index) {
            if (index==0) {
                if ([ws.delegate respondsToSelector:@selector(photoBrowser:setAvatar:)]) {
                    [ws.delegate photoBrowser:ws setAvatar:ws.currentImageIndex];
                }
            }else{
                if ([ws.delegate respondsToSelector:@selector(photoBrowser:delteAvatar:)]) {
                    [ws.delegate photoBrowser:ws delteAvatar:ws.currentImageIndex];
                    ws.backgroundColor = [UIColor clearColor];
                    [ws removeFromSuperview];
                    
                }
            }
        }];
        [action show];
    }
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
    
    _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    _indexLabel.centerX_sd= self.width_sd * 0.5;
    _indexLabel.centerY_sd = 45;
    _indexLabel.layer.cornerRadius = _indexLabel.height_sd * 0.5;
    
    _closeButton.bounds = CGRectMake(0, 0, 30, 30);
    _closeButton.centerX_sd = 30;
    _closeButton.centerY_sd = 45;
    
    _moreButton.bounds = CGRectMake(0, 0, 30, 30);
    _moreButton.centerX_sd = self.width_sd - 30;
    _moreButton.centerY_sd = 45;
    
//    _moreButton.backgroundColor = [UIColor redColor];
//    _closeButton.backgroundColor = [UIColor redColor];
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        SDBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[SDBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}

- (void)showFirstImage
{
    UIView *sourceView = nil;
    
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentImageIndex inSection:0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    }
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        self->_hasShowedFistView = YES;
        [tempView removeFromSuperview];
        self->_scrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        SDBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    
    if (!_willDisappear) {
        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    }
    [self setupImageOfImageViewForIndex:index];
}

- (void)setBrowserStyle:(SDPhotoBrowserStyle)browserStyle
{
    _browserStyle = browserStyle;
    [self updateIndexVisible];
}
/**
 更新索引指示控件的显隐逻辑
 */
- (void)updateIndexVisible
{
    switch (self.browserStyle) {
        case SDPhotoBrowserStyleNone:
        {
            _saveButton.hidden = YES;
            _indexLabel.hidden = YES;
            _closeButton.hidden = YES;
            _moreButton.hidden = YES;
        }
            break;
        case SDPhotoBrowserStyleIndexLabel:
        {
            _saveButton.hidden = YES;
            _indexLabel.hidden = NO;
            _closeButton.hidden = YES;
            _moreButton.hidden = YES;
        }
            break;
        case SDPhotoBrowserStyleAll:
        {
            _saveButton.hidden = YES;
            _indexLabel.hidden = NO;
            _closeButton.hidden = NO;
            _moreButton.hidden = NO;
        }
            break;
        default:
            break;
    }
    
}
@end

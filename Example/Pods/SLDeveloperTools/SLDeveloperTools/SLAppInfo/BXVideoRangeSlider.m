//
//  BXVideoRangeSlider.m
//  SAVideoRangeSliderExample
//
//  Created by annidyfeng on 2017/4/18.
//  Copyright © 2017年 Andrei Solovjev. All rights reserved.
//

#import "BXVideoRangeSlider.h"
#import "UIView+Additions.h"
#import "UIView+CustomAutoLayout.h"
#import "VideoRangeConst.h"

@implementation VideoColorInfo

@end

@interface BXVideoRangeSlider()<RangeContentDelegate, UIScrollViewDelegate>

@property BOOL disableSeek;

@end

@implementation BXVideoRangeSlider
{
    NSMutableArray <VideoColorInfo *> *_colorInfos;
    ColorType       _colorType;
    VideoColorInfo *_selectColorInfo;
    BOOL          _startColor;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.bgScrollView = ({
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [self addSubview:scroll];
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.scrollsToTop = NO;
        scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        scroll.delegate = self;
        scroll;
    });
    self.middleLine = ({
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:imageView];
        imageView;
    });
    
    _colorInfos = [NSMutableArray array];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgScrollView.width = self.width;
    self.middleLine.center = self.bgScrollView.center = CGPointMake(self.width/2, self.height/2);
    
    CGFloat h = self.bgScrollView.height + 8;
    CGFloat w = 4;
    self.middleLine.bounds = CGRectMake(0, 0, w, h);
    self.middleLine.layer.cornerRadius = w / 2;
}


- (void)setAppearanceConfig:(RangeContentConfig *)appearanceConfig {
    _appearanceConfig = appearanceConfig;
}

- (void)setImageList:(NSArray *)images
{
    if (self.rangeContent) {
        [self.rangeContent removeFromSuperview];
    }
    if (_appearanceConfig) {
        self.rangeContent = [[BXRangeContent alloc] initWithImageList:images config:_appearanceConfig];
    } else {
        self.rangeContent = [[BXRangeContent alloc] initWithImageList:images];
    }
    
    if (_colorType != ColorType_Cut) {
        [self setLeftPanHidden:YES];
        [self setRightPanHidden:YES];
        self.rangeContent.leftCover.hidden = YES;
        self.rangeContent.rightCover.hidden = YES;
    }
    self.rangeContent.delegate = self;
    
    [self.bgScrollView addSubview:self.rangeContent];
    self.bgScrollView.contentSize = [self.rangeContent intrinsicContentSize];
    self.bgScrollView.height = self.bgScrollView.contentSize.height;
    self.bgScrollView.contentInset = UIEdgeInsetsMake(0, self.width/2-self.rangeContent.pinWidth, 0, self.width/2-self.rangeContent.pinWidth);
    
    [self setCurrentPos:0];
}

- (void)updateImage:(UIImage *)image atIndex:(NSUInteger)index;
{
    self.rangeContent.imageViewList[index].image = image;
}

- (void)setLeftPanHidden:(BOOL)isHidden
{
    self.rangeContent.leftPin.hidden = isHidden;
    [self.rangeContent unpdateBorder];
}

- (void)setCenterPanHidden:(BOOL)isHidden
{
    self.rangeContent.centerPin.hidden = isHidden;
}

- (void)setRightPanHidden:(BOOL)isHidden
{
    self.rangeContent.rightPin.hidden = isHidden;
    [self.rangeContent unpdateBorder];
}

- (void)setLeftPanFrame:(CGFloat)time
{
    _leftPos = time;
    self.rangeContent.leftPinCenterX = time / _durationMs * self.rangeContent.imageListWidth + self.rangeContent.pinWidth / 2;
    self.rangeContent.leftPin.center = CGPointMake(self.rangeContent.leftPinCenterX, self.rangeContent.leftPin.center.y);
    [self.rangeContent unpdateBorder];
}

- (void)setCenterPanFrame:(CGFloat)time
{
    self.rangeContent.centerPinCenterX = time / _durationMs * self.rangeContent.imageListWidth + self.rangeContent.pinWidth;
    self.rangeContent.centerPin.center = CGPointMake(self.rangeContent.centerPinCenterX, self.rangeContent.centerPin.center.y);
}

- (void)setRightPanFrame:(CGFloat)time
{
    _rightPos = time;
    self.rangeContent.rightPinCenterX = time / _durationMs * self.rangeContent.imageListWidth + self.rangeContent.pinWidth * 3 / 2;
    self.rangeContent.rightPin.center = CGPointMake(self.rangeContent.rightPinCenterX, self.rangeContent.rightPin.center.y);
    [self.rangeContent unpdateBorder];
}

- (void)setColorType:(ColorType)colorType
{
    _colorType = colorType;
    if (_colorType == ColorType_Cut) {
        [self setLeftPanHidden:NO];
        [self setRightPanHidden:NO];
    }else{
        [self setLeftPanHidden:YES];
        [self setRightPanHidden:YES];
        [self setLeftPanFrame:0];
        [self setRightPanFrame:_rightPos];
        [self.rangeContent unpdateBorder];
        self.rangeContent.leftCover.hidden = YES;
        self.rangeContent.rightCover.hidden = YES;
    }
    for (VideoColorInfo *info in _colorInfos) {
        if (info.colorType != _colorType) {
            info.colorView.hidden = YES;
        }else{
            info.colorView.hidden = NO;
        }
    }
    
}

- (void)startColoration:(UIColor *)color alpha:(CGFloat)alpha
{
    VideoColorInfo *info = [[VideoColorInfo alloc] init];
    info.colorView = [UIView new];
    info.colorView.backgroundColor = color;
    info.colorView.alpha = alpha;
    info.colorType = _colorType;
    [_colorInfos addObject:info];
    if (_colorType == ColorType_Effect) {
        info.startPos = _currentPos;
    }else{
        info.startPos = _leftPos;
        info.endPos   = _rightPos;
        CGFloat x = self.rangeContent.pinWidth + _leftPos * self.rangeContent.imageListWidth / _durationMs;
        CGFloat width = fabs(_leftPos - _rightPos) * self.rangeContent.imageListWidth / _durationMs;
        info.colorView.frame = CGRectMake(x, 0, width, self.height);
    }
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [info.colorView addGestureRecognizer:tapGes];
    [self.rangeContent insertSubview:info.colorView belowSubview:self.rangeContent.leftPin];
    _startColor = YES;
    _selectColorInfo = info;
}

- (void)stopColoration
{
    if (_colorType == ColorType_Effect) {
        VideoColorInfo *info = [_colorInfos lastObject];
        info.endPos = _currentPos;
    }
    _startColor = NO;
}

- (VideoColorInfo *)removeLastColoration:(ColorType)colorType;
{
    for (NSInteger i = _colorInfos.count - 1; i >= 0; i ++) {
        VideoColorInfo *info = (VideoColorInfo *)_colorInfos[i];
        if (info.colorType == colorType) {
            [info.colorView removeFromSuperview];
            [_colorInfos removeObject:info];
            return info;
        }
    }
    return nil;
}

- (void)removeColoration:(ColorType)colorType index:(NSInteger)index;
{
    NSInteger count = 0;
    for (NSInteger i = 0; i < _colorInfos.count; i ++) {
        VideoColorInfo *info = (VideoColorInfo *)_colorInfos[i];
        if (info.colorType == colorType) {
            if (count == index) {
                [info.colorView removeFromSuperview];
                [_colorInfos removeObject:info];
                break;
            }
            count++;
        }
    }
}

- (void)setDurationMs:(CGFloat)durationMs {
    //duration 发生变化的时候，更新下特效所在的位置
    if (_durationMs != durationMs) {
        for (VideoColorInfo *info in _colorInfos) {
            CGFloat x = self.rangeContent.pinWidth + info.startPos * self.rangeContent.imageListWidth / durationMs;
            CGFloat width = fabs(info.endPos - info.startPos) * self.rangeContent.imageListWidth / durationMs;
            info.colorView.frame = CGRectMake(x, 0, width, self.height);
        }
        _durationMs = durationMs;
    }
    
    _leftPos = 0;
    _rightPos = _durationMs;
    [self setCurrentPos:_currentPos];
    
    _leftPos =  self.durationMs * self.rangeContent.leftScale;
    _centerPos = self.durationMs * self.rangeContent.centerScale;
    _rightPos = self.durationMs * self.rangeContent.rightScale;
}

- (void)setCurrentPos:(CGFloat)currentPos
{
    _currentPos = currentPos;
    if (_durationMs <= 0) {
        return;
    }
    CGFloat off = currentPos * self.rangeContent.imageListWidth / _durationMs;
    //    off += self.rangeContent.leftPin.width;
    off -= self.bgScrollView.contentInset.left;
    
    self.disableSeek = YES;
    self.bgScrollView.contentOffset = CGPointMake(off, 0);
    
    VideoColorInfo *info = [_colorInfos lastObject];
    if (_colorType == ColorType_Effect && _startColor) {
        CGFloat x = 0;
        if (_currentPos > info.startPos) {
            x = self.rangeContent.pinWidth + info.startPos * self.rangeContent.imageListWidth / _durationMs;
        }else{
            x = self.rangeContent.pinWidth + _currentPos * self.rangeContent.imageListWidth / _durationMs;
        }
        CGFloat width = fabs(_currentPos - info.startPos) * self.rangeContent.imageListWidth / _durationMs;
        info.colorView.frame = CGRectMake(x, 0, width, self.height);
    }
    self.disableSeek = NO;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [gesture locationInView:self.rangeContent];
        CGFloat tapTime = (point.x - self.rangeContent.pinWidth) / self.rangeContent.imageListWidth * _durationMs;
        for (VideoColorInfo *info in _colorInfos) {
            if (info.colorType == _colorType && tapTime >= info.startPos && tapTime <= info.endPos) {
                _selectColorInfo = info;
                break;
            }
        }
        [self.delegate onVideoRangeTap:tapTime];
    }
}

#pragma mark TXVideoRangeContentDelegate

- (void)onRangeLeftChanged:(BXRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    
    [self.delegate onVideoRangeLeftChanged:self];
    
    if (_colorType == ColorType_Paster || _colorType == ColorType_Text) {
        CGFloat x = self.rangeContent.pinWidth + _leftPos * self.rangeContent.imageListWidth / _durationMs;
        CGFloat width = fabs(_leftPos - _rightPos) * self.rangeContent.imageListWidth / _durationMs;
        _selectColorInfo.startPos = _leftPos;
        _selectColorInfo.colorView.frame = CGRectMake(x, 0, width, self.height);
    }
}

- (void)onRangeLeftChangeEnded:(BXRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    
    [self.delegate onVideoRangeLeftChangeEnded:self];
}

- (void)onRangeCenterChanged:(BXRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    _centerPos =  self.durationMs * sender.centerScale;
    [self.delegate onVideoRangeCenterChanged:self];
}

- (void)onRangeCenterChangeEnded:(BXRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    _centerPos =  self.durationMs * sender.centerScale;
    
    [self.delegate onVideoRangeCenterChangeEnded:self];
}

- (void)onRangeRightChanged:(BXRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    
    [self.delegate onVideoRangeRightChanged:self];
    
    if (_colorType == ColorType_Paster || _colorType == ColorType_Text) {
        CGFloat x = self.rangeContent.pinWidth + _leftPos * self.rangeContent.imageListWidth / _durationMs;
        CGFloat width = fabs(_leftPos - _rightPos) * self.rangeContent.imageListWidth / _durationMs;
        _selectColorInfo.endPos = _rightPos;
        _selectColorInfo.colorView.frame = CGRectMake(x, 0, width, self.height);
    }
}

- (void)onRangeRightChangeEnded:(BXRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
    
    [self.delegate onVideoRangeRightChangeEnded:self];
}

- (void)onRangeLeftAndRightChanged:(BXRangeContent *)sender
{
    _leftPos  = self.durationMs * sender.leftScale;
    _rightPos = self.durationMs * sender.rightScale;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pos = scrollView.contentOffset.x;
    pos += scrollView.contentInset.left;
    if (pos < 0) pos = 0;
    if (pos > self.rangeContent.imageListWidth) pos = self.rangeContent.imageListWidth;
    
    _currentPos = self.durationMs * pos/self.rangeContent.imageListWidth;
    if (self.disableSeek == NO) {
        NSLog(@"seek %f", _currentPos);
        [self.delegate onVideoRange:self seekToPos:self.currentPos];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onVideoRangeEnd:seekToPos:)]) {
        [self.delegate onVideoRangeEnd:self seekToPos:self.currentPos];
    }
}

@end

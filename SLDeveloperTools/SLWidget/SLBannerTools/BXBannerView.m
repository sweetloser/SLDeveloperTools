//
//  BXBannerView.m
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXBannerView.h"
//#import <iCarousel.h>
#import <iCarousel/iCarousel.h>
#import <SDWebImage/SDWebImage.h>
#import "BXBannerPageControl.h"
#import "BXSLBannerModel.h"
#import "../../SLCategory/SLCategory.h"
#import "../../SLMacro/SLMacro.h"

@interface BXBannerView ()<iCarouselDataSource,iCarouselDelegate>

@property (strong, nonatomic) iCarousel *carousel;
@property (strong, nonatomic) BXBannerPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation BXBannerView


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _carousel=[[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _carousel.delegate=self;
        _carousel.dataSource=self;
        _carousel.backgroundColor=[UIColor clearColor];
        _carousel.type = iCarouselTypeLinear;
        _carousel.decelerationRate = 0.5;
        _carousel.vertical = NO;
        _carousel.clipsToBounds = YES;
        _carousel.layer.masksToBounds = YES;
        _carousel.layer.cornerRadius = 4;
        [self addSubview:_carousel];
        
        _pageControl=[[BXBannerPageControl alloc]initWithFrame:CGRectMake(0, self.height - 30, self.width, 24)];
        [_pageControl addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)setBanners:(NSArray *)banners {
    _banners = banners;
    _pageControl.numberOfPages = banners.count;
    _pageControl.hidden = (banners.count == 1);
    [_carousel reloadData];
    _carousel.scrollEnabled = !_pageControl.hidden;
}

- (void)setIsEvent:(BOOL)isEvent {
    _isEvent = isEvent;
    
    if (_isEvent) {
        _carousel.frame = self.bounds;
        _pageControl.frame = CGRectMake(0, self.height, self.width, 20);
        _pageControl.width = 5;
    }
}

-(void)pageAction{
    NSInteger index = _pageControl.currentPage;
    [_carousel scrollToItemAtIndex:index animated:YES];
    [self stopScroll];
    
    if (_banners.count > 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(carouselUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopScroll {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc {
    NSLog(@"=========banner销毁了");
}

#pragma - mark iCarousel
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _banners.count;
}
- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    NSUInteger num=_banners.count;
    if (num > 1) {
        num = 1;
    }
    return num;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:carousel.bounds];
        imageView.contentMode = _isEvent ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        view = imageView;
    }
    
    NSString *imageStr = @"";
    if (index < _banners.count) {
        BXSLBannerModel *banner=_banners[index];
        imageStr = banner.imageNormal;
        if (iPhoneX && !IsNilString(banner.imageX)) {
            imageStr = banner.imageX;
        }
    }
    UIImageView *imageView=(UIImageView*)view;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"icon_remeng_lunbo"]];
    return view;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    if (option==iCarouselOptionWrap) {
        return YES;
    }else{
        return value;
    }
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if (_selectedBanner) {
        _selectedBanner(index);
    }
}
- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel {
    [self stopScroll];
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
    if (!_timer) {
        if (_banners.count > 1) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(carouselUpdate) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
    }
}
-(void)carouselUpdate
{
    NSInteger index = _carousel.currentItemIndex;
    if (index<_banners.count) {
        index++;
    }else
    {
        index=0;
    }
    [_carousel scrollToItemAtIndex:index animated:YES];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    NSInteger index = _carousel.currentItemIndex;
    _pageControl.currentPage=index;
}

@end

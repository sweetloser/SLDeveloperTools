//
//  BXLocationHeaderView.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXLocationHeaderView.h"
#import "SDPhotoBrowser.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "../SLMacro/SLMacro.h"

@interface BXLocationHeaderView () <SDPhotoBrowserDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BXLocationHeaderView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)tapAction {
    if (IsNilString(_imageUrl)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(locationHeaderViewDidTap)]) {
            [self.delegate locationHeaderViewDidTap];
        }
    } else {
        
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = _imageView.tag;
        browser.sourceImagesContainerView = self;
        browser.browserStyle = 1;
        browser.imageCount = 1;
        browser.delegate = self;
        [browser show];
        
        
       
    }
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:_imageUrl];
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    if (_imageView.image) {
        return _imageView.image;
    }
    return nil;
}






@end

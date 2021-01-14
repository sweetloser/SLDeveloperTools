//
//  BXHHEmojiCell.m
//  BXlive
//
//  Created by bxlive on 2018/9/21.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXHHEmojiCell.h"
#import <Masonry/Masonry.h>
#import <YYImage/YYImage.h>

@interface BXHHEmojiCell ()

@property (strong, nonatomic) YYAnimatedImageView *imageView;

@end

@implementation BXHHEmojiCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[YYAnimatedImageView alloc]init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.center.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setEmoji:(BXHHEmoji *)emoji {
    _emoji = emoji;
    _imageView.image = [BXHHEmoji imageWithEmojiString:emoji.desc];
}

@end

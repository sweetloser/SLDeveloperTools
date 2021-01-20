//
//  BXSLSearchHeaderView.m
//  BXlive
//
//  Created by bxlive on 2019/3/7.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchHeaderView.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"

@interface BXSLSearchHeaderView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLb;

@end

@implementation BXSLSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(__ScaleWidth(18));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(__ScaleWidth(12));
        }];
        
        _textLb = [[UILabel alloc]init];
        _textLb.font = SLPFFont(__ScaleWidth(16));
        _textLb.textColor = sl_textColors;
        [self addSubview:_textLb];
        [_textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.imageView);
            make.left.mas_equalTo(self.imageView.mas_right).offset(__ScaleWidth(10));
        }];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setText:(NSString *)text {
    _text = text;
    _textLb.text = text;
}

@end

//
//  BXliveCoverView.m
//  BXlive
//
//  Created by bxlive on 2019/3/13.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXVideoCoverView.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>

@interface BXVideoCoverView ()

@property (nonatomic, strong) UIImageView *topGradientView;
@property (nonatomic, strong) UIImageView *bottomGradientView;

@end

@implementation BXVideoCoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if ([super init]) {
        self.backgroundColor = PageBackgroundColor;
        
        _topGradientView = [[UIImageView alloc]init];
        _topGradientView.image = CImage(@"bg_black_1");
        [self addSubview:_topGradientView];
        [_topGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(self.topGradientView.mas_width).multipliedBy(188.0 / 750);
        }];
        _bottomGradientView  = [[UIImageView alloc]init];
        _bottomGradientView.image = CImage(@"bg_black_2");
        [self addSubview:_bottomGradientView];
        [_bottomGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(self.bottomGradientView.mas_width).multipliedBy(780.0 / 750);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topGradientView.hidden = (self.subviews.count > 2);
    _bottomGradientView.hidden = _topGradientView.hidden;
}

@end

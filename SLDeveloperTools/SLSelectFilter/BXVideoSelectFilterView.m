//
//  BXliveSelectFilterView.m
//  BXlive
//
//  Created by bxlive on 2019/4/18.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXVideoSelectFilterView.h"
#import "HMFilterView.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>

@interface BXVideoSelectFilterView () <HMFilterViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@end

@implementation BXVideoSelectFilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithIndex:(NSInteger)index filterArr:(NSArray *)filterArr{
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:maskView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer* panGensture = [[UIPanGestureRecognizer alloc] initWithTarget:self action: @selector (handlePanSlide)];
        [self addGestureRecognizer:panGensture];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 98 + __kBottomAddHeight)];
        [self addSubview:_contentView];
        
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *backView = [[UIVisualEffectView alloc]initWithEffect:beffect];
        [_contentView insertSubview:backView atIndex:0];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.contentView);
        }];
    
        HMFilterView *filterView = [[HMFilterView alloc] initWithFrame:CGRectZero filtersName:filterArr];
        filterView.selectedIndex = index;
        filterView.mDelegate = self;
        [_contentView addSubview:filterView];
        [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(98);
        }];
        [filterView reloadData];
    }
    return self;
}

- (void)tapAction {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRemoveFromSuperview)]) {
        [self.delegate didRemoveFromSuperview];
    }
}

- (void)handlePanSlide {
    
}

- (void)show {
    [UIView animateWithDuration:.5 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -self.contentView.height);
    }];
}

#pragma - mark HMFilterViewDelegate
- (void)filterViewDidSelectedFilter:(NSString *)filterName  selectedIndex:(NSInteger)selectedIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedFilter:)]) {
        [self.delegate didSelectedFilter:selectedIndex];
    }
}

@end

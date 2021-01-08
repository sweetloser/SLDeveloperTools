//
//  DSLoadingView.m
//  BXlive
//
//  Created by bxlive on 2019/2/28.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXLoadingView.h"
#import <Lottie/Lottie.h>
#import <Masonry/Masonry.h>
@interface BXLoadingView ()

@end

@implementation BXLoadingView

+ (instancetype)showInView:(UIView *)view width:(CGFloat)width height:(CGFloat)height{
    BXLoadingView *loading = [[BXLoadingView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [view addSubview:loading];
    
    return loading;
}


+ (void)hide:(BXLoadingView *)loadingView {
    
    [loadingView removeFromSuperview];
}

#pragma mark -
#pragma mark 初始化方法

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

#pragma mark 动画相关

- (void)buildUI {
    self.backgroundColor =  [UIColor colorWithRed:23/255.0f green:25/255.0f blue:41/255.0f alpha:1];
    LOTAnimationView *lottieView = [LOTAnimationView animationNamed:@"dsLoading"];
    lottieView.loopAnimation = YES;
    [self addSubview:lottieView];
    [lottieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(70*120/375);
    }];
    [lottieView play];
}




@end

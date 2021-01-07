//
//  BXNoNetworkView.m
//  BXlive
//
//  Created by bxlive on 2018/9/4.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXNoNetworkView.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
@interface BXNoNetworkView ()
@property(nonatomic,strong)UIImageView *imgv;
@end

@implementation BXNoNetworkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithHeight:(CGFloat)height {
    if ([super init]) {
        if (height <= 0) {
            height = [UIScreen mainScreen].bounds.size.height;
        }
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
        [self addConstraint:heightConstraint];
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageBtn setImage:[UIImage imageNamed:@"image_internet"] forState:UIControlStateNormal];
        [imageBtn setImage:[UIImage imageNamed:@"image_internet"] forState:UIControlStateHighlighted];
        [self addSubview:imageBtn];
        [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(0);
            make.width.mas_equalTo(211);
            make.height.mas_equalTo(201);
        }];
        [imageBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIView *subTitleView = [[UIView alloc]init];
        [self addSubview:subTitleView];
        
        UILabel *leftLb = [[UILabel alloc]init];
        leftLb.font = CFont(13);
        leftLb.textColor = CHHCOLOR_D(0xB0B0B0);
        leftLb.text = @"请检查您的";
        [subTitleView addSubview:leftLb];
        [leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
        }];
        
        UIButton *setBtn = [[UIButton alloc]init];
        [setBtn setTitle:@"网络设置" forState:BtnNormal];
        setBtn.titleLabel.font = CFont(13);
        [setBtn setTitleColor:CHHCOLOR_D(0x01aaef) forState:BtnNormal];
        [setBtn addTarget:self action:@selector(setAction:) forControlEvents:BtnTouchUpInside];
        [subTitleView addSubview:setBtn];
        [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(leftLb.mas_right);
        }];
        
        UILabel *rightLb = [[UILabel alloc]init];
        rightLb.font = CFont(13);
        rightLb.textColor = CHHCOLOR_D(0xB0B0B0);
        rightLb.text = @"，再刷新试试吧";
        [subTitleView addSubview:rightLb];
        [rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.left.mas_equalTo(setBtn.mas_right);
        }];
        
        [subTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(14);
            make.top.mas_equalTo(imageBtn.mas_bottom).offset(17);
        }];
        
//        UIButton *refreshBtn = [[UIButton alloc]init];
//        [refreshBtn setBackgroundImage:CImage(@"prompt_refresh") forState:BtnNormal];
//        [refreshBtn setTitle:@"刷新" forState:BtnNormal];
//        [refreshBtn setTitleColor:CHHCOLOR_D(0xffffff) forState:BtnNormal];
//        [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:BtnTouchUpInside];
//        [self addSubview:refreshBtn];
//        [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(0);
//            make.top.mas_equalTo(setBtn.mas_bottom).offset(23);
//            make.width.mas_equalTo(97);
//            make.height.mas_equalTo(35);
//        }];
    }
    return self;
}

- (void)setAction:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)refreshAction{
    if (_needRefresh) {
        _needRefresh();
    }
}
@end

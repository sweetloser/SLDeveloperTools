//
//  ShareView.m
//  BXlive
//
//  Created by bxlive on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "ShareView.h"
#import "../../SLMacro/SLMacro.h"
#import "../../SLCategory/SLCategory.h"
#import "BXAppInfo.h"
#import <Masonry/Masonry.h>

@interface ShareView ()

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) NSArray *shareObjects;

@end

@implementation ShareView

- (instancetype)initWithShareObjects:(NSArray *)shareObjects {
    _shareObjects = shareObjects;
    
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        maskView.backgroundColor = SLClearColor;
        [self addSubview:maskView];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, __kHeight, __kWidth, __ScaleWidth(303-34) + __kBottomAddHeight)];
        if ([[BXAppInfo appInfo].is_dynamic_open integerValue] == 0) {
            contentView.frame = CGRectMake(0, __kHeight, __kWidth, __ScaleWidth(200) + __kBottomAddHeight);
        }
        contentView.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
        [self addSubview:contentView];
        _contentView = contentView;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.path = bezierPath.CGPath;
        _contentView.layer.mask = shapeLayer;
        
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, __ScaleWidth(50), __ScaleWidth(22))];
        titleLb.text = @"分享到";
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.textColor = sl_textSubColors;
        titleLb.font = SLPFFont(__ScaleWidth(16));
        [contentView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(__ScaleWidth(15));
            make.centerX.mas_equalTo(0);
        }];
        
        UIView *leftLine = [UIView new];
        [_contentView addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(titleLb.mas_left).offset(__ScaleWidth(-10));
            make.centerY.equalTo(titleLb);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(__ScaleWidth(30));
        }];
        leftLine.backgroundColor = sl_divideLineColor;
        UIView *rightLine = [UIView new];
        [_contentView addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLb.mas_right).offset(__ScaleWidth(10));
            make.centerY.equalTo(titleLb);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(__ScaleWidth(30));
        }];
        rightLine.backgroundColor = sl_divideLineColor;
        
        NSMutableArray *btnArray = [NSMutableArray new];
        
        CGFloat fixSpace = __ScaleWidth(375-24-24 - 60 * 4) / 3;
        
        for (NSInteger i = 0; i < shareObjects.count; i++) {
            ShareObject * shareObject = shareObjects[i];
            
            UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectZero];
            shareBtn.tag = i;
            [shareBtn setImage:CImage(shareObject.iconName) forState:BtnNormal];
            [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:BtnTouchUpInside];
            shareBtn.imageEdgeInsets = UIEdgeInsetsMake(-__ScaleWidth(10), 0, __ScaleWidth(10), 0);
            [contentView addSubview:shareBtn];
            
            [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLb.mas_bottom).offset(__ScaleWidth(20));
                make.height.mas_equalTo(__ScaleWidth(66));
                make.width.mas_equalTo(__ScaleWidth(60));
                make.left.mas_equalTo(__ScaleWidth(60 * i) + __ScaleWidth(24) + fixSpace * i);
            }];
            
            UILabel *textLb = [[UILabel alloc]init];
            textLb.text = shareObject.name;
            textLb.font = SLPFFont(12);
            textLb.textColor = sl_textSubColors;
            textLb.textAlignment = NSTextAlignmentCenter;
            [shareBtn addSubview:textLb];
            [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(__ScaleWidth(17));
            }];
            
            [btnArray addObject:shareBtn];
        }
        
//        [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:__ScaleWidth(60) leadSpacing:__ScaleWidth(24) tailSpacing:__ScaleWidth(24)];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tap];
        
        if ([[BXAppInfo appInfo].is_dynamic_open integerValue] == 1) {
//        分割线
        UIView *lineV = [UIView new];
        [_contentView  addSubview:lineV];
        lineV.backgroundColor = sl_divideLineColor;
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(25));
            make.right.mas_equalTo(-__ScaleWidth(25));
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(__ScaleWidth(143));
        }];
        
        UIButton *share_dynamicBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        share_dynamicBtn.tag = 4;
        [share_dynamicBtn setImage:CImage(@"share_dynamic") forState:BtnNormal];
        [share_dynamicBtn addTarget:self action:@selector(shareAction:) forControlEvents:BtnTouchUpInside];
        share_dynamicBtn.imageEdgeInsets = UIEdgeInsetsMake(-__ScaleWidth(10), 0, __ScaleWidth(10), 0);
        [_contentView addSubview:share_dynamicBtn];
        
        [share_dynamicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineV.mas_bottom).offset(__ScaleWidth(14));
            make.height.mas_equalTo(__ScaleWidth(66));
            make.width.mas_equalTo(__ScaleWidth(60));
            make.left.mas_equalTo(__ScaleWidth(24));
        }];
        
        UILabel *textLb = [[UILabel alloc]init];
        textLb.text = @"分享动态";
        textLb.font = SLPFFont(12);
        textLb.textColor = sl_textSubColors;
        textLb.textAlignment = NSTextAlignmentCenter;
        [share_dynamicBtn addSubview:textLb];
        [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(__ScaleWidth(17));
        }];
        }
        
        
//        取消
        UIButton *cancelBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_contentView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentView.mas_bottom).offset(__ScaleWidth(-15) - __kBottomAddHeight);
            make.width.mas_equalTo(__ScaleWidth(100));
            make.height.mas_equalTo(__ScaleWidth(25));
            make.centerX.mas_equalTo(0);
        }];
        [cancelBtn setTitle:@"取消" forState:BtnNormal];
        [cancelBtn setTitleColor:sl_normalColors forState:BtnNormal];
        cancelBtn.titleLabel.font = SLPFFont(__ScaleWidth(14));
        [cancelBtn addTarget:self action:@selector(tapAction) forControlEvents:BtnTouchUpInside];
    }
    return self;
}

- (void)tapAction {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.contentView.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.contentView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)shareAction:(UIButton *)sender {
    if (sender.tag == 4) {
//        分享动态
        if (_shareDynamic) {
            _shareDynamic();
        }
        [self tapAction];
        return;
    }
    ShareObject *shareObject = _shareObjects[sender.tag];
    if (_shareTo) {
        _shareTo(shareObject.type);
    }
    [self tapAction];
}

- (void)show {
    
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.contentView.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.contentView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
    
    
    
}

@end

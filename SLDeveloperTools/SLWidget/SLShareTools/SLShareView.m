//
//  SLShareView.m
//  BXlive
//
//  Created by sweetloser on 2020/8/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLShareView.h"
#import "../../SLMacro/SLMacro.h"
#import "../../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>

@interface SLShareView ()

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) NSArray *shareObjects;

@property (strong, nonatomic) UIScrollView *shareScrollView;

@end

@implementation SLShareView

- (instancetype)initWithShareObjects:(NSArray <SLShareObjs *> *)shareObjects {
    _shareObjects = shareObjects;
    
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        maskView.backgroundColor = [UIColor colorWithColor:sl_blackColors alpha:0.6];
        [self addSubview:maskView];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, __kHeight, __kWidth, __ScaleWidth(218-34) + __kBottomAddHeight)];
        contentView.backgroundColor = sl_BGColors;
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
        
        _shareScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        [_contentView addSubview:_shareScrollView];
        
        [_shareScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(__ScaleWidth(90));
            make.top.equalTo(titleLb.mas_bottom);
        }];
        
        [_shareScrollView setContentSize:CGSizeMake(__ScaleWidth(83.6) * shareObjects.count, __ScaleWidth(90))];
        _shareScrollView.showsHorizontalScrollIndicator = NO;
        
        for (NSInteger i = 0; i < shareObjects.count; i++) {
            SLShareObjs *shareObject = shareObjects[i];
            CGFloat itemW = __ScaleWidth(83.6);
            UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*itemW, __ScaleWidth(20), itemW, __ScaleWidth(70))];
            shareBtn.tag = shareObject.shareType;
            [shareBtn setImage:CImage(shareObject.iconName) forState:BtnNormal];
            [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:BtnTouchUpInside];
            shareBtn.imageEdgeInsets = UIEdgeInsetsMake(-__ScaleWidth(15), 0, __ScaleWidth(15), 0);
            [_shareScrollView addSubview:shareBtn];
            
            UILabel *textLb = [[UILabel alloc]init];
            textLb.text = shareObject.name;
            textLb.font = SLPFFont(12);
            textLb.textColor = sl_textSubColors;
            textLb.textAlignment = NSTextAlignmentCenter;
            [shareBtn addSubview:textLb];
            [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-__ScaleWidth(5));
                make.height.mas_equalTo(__ScaleWidth(17));
            }];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tap];
        
//        取消
        WS(weakSelf);
        UIButton *cancelBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_contentView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.shareScrollView.mas_bottom).offset(__ScaleWidth(15));
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
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
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
    if (_shareTo) {
        _shareTo(sender.tag);
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

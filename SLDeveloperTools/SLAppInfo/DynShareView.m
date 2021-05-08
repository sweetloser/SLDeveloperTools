//
//  ShareView.m
//  BXlive
//
//  Created by bxlive on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "DynShareView.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>

@interface DynShareView ()

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) NSArray *shareObjects;

@property (strong, nonatomic) UIScrollView *shareScrollView;

@end

@implementation DynShareView

- (instancetype)initWithShareObjects:(NSArray *)shareObjects {
    _shareObjects = shareObjects;
    
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        [self addSubview:maskView];

        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, __kHeight, __kWidth, 154 + __kBottomAddHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        _contentView = contentView;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.path = bezierPath.CGPath;
        _contentView.layer.mask = shapeLayer;
        
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 44)];
        titleLb.text = @"请选择分享平台";
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.textColor = CHHCOLOR_D(0x373737);
        titleLb.font = CBFont(17);
        [contentView addSubview:titleLb];
        
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
            DynShareObject * shareObject = shareObjects[i];
            
            UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(15 + (50 + 23) * i, 44, 50, 90)];
            shareBtn.tag = i;
            [shareBtn setImage:CImage(shareObject.iconName) forState:BtnNormal];
            [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:BtnTouchUpInside];
            shareBtn.imageEdgeInsets = UIEdgeInsetsMake(-16, 0, 16, 0);
            [_shareScrollView addSubview:shareBtn];
            
            
            UILabel *textLb = [[UILabel alloc]init];
            textLb.text = shareObject.name;
            textLb.font = CFont(12);
            textLb.textColor = CHHCOLOR_D(0x373737);
            textLb.textAlignment = NSTextAlignmentCenter;
            [shareBtn addSubview:textLb];
            [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(30);
            }];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tap];
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
    DynShareObject *shareObject = _shareObjects[sender.tag];
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

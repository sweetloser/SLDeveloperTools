//
//  SharePopView.m
//  BXlive
//
//  Created by bxlive on 2019/3/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import "SharePopView.h"
#import "../SLWidget/SLShareTools/ShareObject.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "SLAppInfoMacro.h"
#import <UMShare/UMShare.h>
#import <Masonry/Masonry.h>

@interface SharePopView()
@property (nonatomic, strong) UIView           *container;
@property (nonatomic, strong) UIButton         *cancel;
@end

@implementation SharePopView

-  (instancetype)initWithFrame:(CGRect)frame topIconsNameArray:(nonnull NSArray *)topIconsNameArray  bottomIconsNameArray:(nonnull NSArray *)bottomIconsNameArray{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
//        底部的半透明遮罩
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];;
        [self addSubview:maskView];
        [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)]];
        
//        真正的内容视图
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, topIconsNameArray.count>0?302:182 + __kBottomAddHeight)];
        _container.backgroundColor = [UIColor sl_colorWithHex:0xF4F8F8];
        [self addSubview:_container];
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        
        CGFloat itemWidth = 68;

        if (topIconsNameArray.count) {
            UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 90)];
            topScrollView.contentSize = CGSizeMake(itemWidth * topIconsNameArray.count, 80);
            topScrollView.showsHorizontalScrollIndicator = NO;
            topScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
            [_container addSubview:topScrollView];
            
            for (NSInteger i = 0; i < topIconsNameArray.count; i++) {
                ShareObject *dict = topIconsNameArray[i];
                ShareItem *item = [[ShareItem alloc] initWithFrame:CGRectMake(20 + itemWidth*i, 0, 48, 90)];
                item.icon.image = [UIImage imageNamed:dict.iconName];
                item.label.text = dict.name;
                item.type = dict.normalType;
                [item.clickBtn addTarget:self action:@selector(onShareItemTap:) forControlEvents:UIControlEventTouchUpInside];
                [topScrollView addSubview:item];
            }
            
            UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, 132, SCREEN_WIDTH, 0.5f)];
            splitLine.backgroundColor = [UIColor sl_colorWithHex:0xD0D5D5];
            [_container addSubview:splitLine];
        }
        
        UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topIconsNameArray.count>0?140:18, SCREEN_WIDTH, 90)];
        bottomScrollView.contentSize = CGSizeMake(itemWidth * bottomIconsNameArray.count, 80);
        bottomScrollView.showsHorizontalScrollIndicator = NO;
        bottomScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
        [_container addSubview:bottomScrollView];
    
        for (NSInteger i = 0; i < bottomIconsNameArray.count; i++) {
            ShareObject *dict = bottomIconsNameArray[i];
            ShareItem *item = [[ShareItem alloc] initWithFrame:CGRectMake(20 + itemWidth*i, 0, 48, 90)];
            item.icon.image = [UIImage imageNamed:dict.iconName];
            item.label.text = dict.name;
            item.type = dict.normalType;
            [item.clickBtn addTarget:self action:@selector(onActionItemTap:) forControlEvents:UIControlEventTouchUpInside];
            [item startAnimation:i*0.03f];
            [bottomScrollView addSubview:item];
        }
        
        _cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, topIconsNameArray.count > 0?252:132, SCREEN_WIDTH, 50 + __kBottomAddHeight)];
        _cancel.imageEdgeInsets = UIEdgeInsetsMake(-__kBottomAddHeight / 2, 0, __kBottomAddHeight / 2, 0);
        [_cancel setImage:CImage(@"icon_guanbi") forState:BtnNormal];
        [_cancel addTarget:self action:@selector(cancelAction) forControlEvents:BtnTouchUpInside];
        _cancel.backgroundColor = [UIColor whiteColor];
        [_container addSubview:_cancel];
    }
    return self;
}

- (void)onShareItemTap:(UIButton *)sender {
    ShareItem *item = (ShareItem *)[sender superview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharePopViewIndex:)]) {
        [self.delegate sharePopViewIndex:item.type];
    }
    [self dismiss];
}
- (void)onActionItemTap:(UIButton *)sender {
    ShareItem *item = (ShareItem *)[sender superview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharePopViewIndex:)]) {
        [self.delegate sharePopViewIndex:item.type];
        
    }
    [self dismiss];
}

- (void)cancelAction {
    [self dismiss];
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end

#pragma Item view

@implementation ShareItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@""];
        _icon.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_icon];
        
        _label = [[UILabel alloc] init];
        _label.text = @"";
        _label.textColor = [UIColor sl_colorWithHex:0x4A4F4F];
        _label.font = CFont(13);
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_clickBtn];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(48);
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(10);
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.icon.mas_bottom).offset(10);
        }];
        
        [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

-(void)startAnimation:(NSTimeInterval)delayTime {
    CGRect originalFrame = self.frame;
    self.frame = CGRectMake(CGRectGetMinX(originalFrame), 35, originalFrame.size.width, originalFrame.size.height);
    [UIView animateWithDuration:0.9f
                          delay:delayTime
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.frame = originalFrame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

@end

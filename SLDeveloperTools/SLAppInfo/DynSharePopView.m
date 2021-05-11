//
//  SharePopView.m
//  BXlive
//
//  Created by bxlive on 2019/3/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import "DynSharePopView.h"
#import <UMShare/UMShare.h>
#import <YYCategories/YYCategories.h>
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoMacro.h"
#import <Masonry/Masonry.h>
@interface DynSharePopView()
@property (nonatomic, strong) UIView           *container;
@property (nonatomic, strong) UIButton         *cancel;
@property (strong, nonatomic) UIScrollView *shareScrollView;
@end

@implementation DynSharePopView

-  (instancetype)initWithFrame:(CGRect)frame topIconsNameArray:(nonnull NSArray *)topIconsNameArray  bottomIconsNameArray:(nonnull NSArray *)bottomIconsNameArray{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;

        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];;
        [self addSubview:maskView];
        [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)]];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, topIconsNameArray.count>0?217:182 + __kBottomAddHeight)];
        _container.backgroundColor = UIColorHex(F4F8F8);
        [self addSubview:_container];
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        

        
        UILabel *sharelabel = [[UILabel alloc]initWithFrame:CGRectMake(_container.frame.size.width / 2 - 30, 25, 60, 20)];
        sharelabel.text = @"分享到";
        sharelabel.textColor = UIColorHex(#8C8C8C);
        sharelabel.font = [UIFont systemFontOfSize:16];
        [_container addSubview:sharelabel];
        
        UILabel *segLeftlable = [[UILabel alloc]initWithFrame:CGRectMake(sharelabel.frame.origin.x - 40, 35, 30, 1)];
        segLeftlable.backgroundColor = UIColorHex(#EAEAEA);
        [_container addSubview:segLeftlable];
        
        UILabel *segRightlable = [[UILabel alloc]initWithFrame:CGRectMake(sharelabel.frame.origin.x + sharelabel.frame.size.width + 10, 35, 30, 1)];
          segRightlable.backgroundColor = UIColorHex(#EAEAEA);
          [_container addSubview:segRightlable];
        
        _shareScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        [_container addSubview:_shareScrollView];
        
        [_shareScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(__ScaleWidth(90));
            make.top.equalTo(sharelabel.mas_bottom);
        }];
        
        [_shareScrollView setContentSize:CGSizeMake(__ScaleWidth(90) * topIconsNameArray.count, __ScaleWidth(90))];
        _shareScrollView.showsHorizontalScrollIndicator = NO;

        if (topIconsNameArray.count) {
//            UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 90)];
//            topScrollView.contentSize = CGSizeMake(itemWidth * topIconsNameArray.count, 80);
//            topScrollView.showsHorizontalScrollIndicator = NO;
//            topScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
//            [_container addSubview:topScrollView];
            
            for (NSInteger i = 0; i < topIconsNameArray.count; i++) {
                DynShareObject *dict = topIconsNameArray[i];
                DynShareItem *item = [[DynShareItem alloc] initWithFrame:CGRectMake(__ScaleWidth(36)* (i+1) + __ScaleWidth(48)*i, 0, __ScaleWidth(48), 90)];
                item.icon.image = [UIImage imageNamed:dict.iconName];
                item.label.text = dict.name;
                item.type = dict.normalType;
                [item.clickBtn addTarget:self action:@selector(onShareItemTap:) forControlEvents:UIControlEventTouchUpInside];
                [_shareScrollView addSubview:item];
            }
            
//            UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, 132, SCREEN_WIDTH, 0.5f)];
//            splitLine.backgroundColor = UIColorHex(D0D5D5);
//            [_container addSubview:splitLine];
        }
        
        
        _cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, topIconsNameArray.count > 0?180:132, SCREEN_WIDTH, 20 + __kBottomAddHeight)];
      
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:UIColorHex(#FF2D52) forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancel addTarget:self action:@selector(cancelAction) forControlEvents:BtnTouchUpInside];
//        _cancel.backgroundColor = [UIColor whiteColor];
        [_container addSubview:_cancel];
    }
    return self;
}

- (void)onShareItemTap:(UIButton *)sender {
    DynShareItem *item = (DynShareItem *)[sender superview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharePopViewIndex:)]) {
        [self.delegate sharePopViewIndex:item.type];
    }
    [self dismiss];
}
- (void)onActionItemTap:(UIButton *)sender {
    DynShareItem *item = (DynShareItem *)[sender superview];
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

@implementation DynShareItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@""];
        _icon.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_icon];
        
        _label = [[UILabel alloc] init];
        _label.text = @"";
        _label.textColor = UIColorHex(4A4F4F);
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

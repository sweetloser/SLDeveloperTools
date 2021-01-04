//
//  BXFooterView.m
//  BXlive
//
//  Created by bxlive on 2018/10/18.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXFooterView.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "../SLMacro/SLMacro.h"
@interface BXFooterView ()


@property (weak, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *noMoreDataLb;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (assign, nonatomic) UIEdgeInsets scrollViewOriginalInset;

@end

@implementation BXFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        
        UIImageView *logoView = [[UIImageView alloc] init];
        logoView.image = [UIImage imageNamed:@"refresh_center"];
        [self addSubview:logoView];
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.center.mas_equalTo(0);
        }];
        _logoView = logoView;
        
        UIView *circleView = [[UIView alloc]init];
        [logoView addSubview:circleView];
        [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        CAShapeLayer *shapeLayer = [self creatCircleShapeLayerWithBounds:CGRectMake(0, 0, 25, 25) startAngle:M_PI / 4 endAngle:M_PI * 2 clockwise:YES];
        [circleView.layer addSublayer:shapeLayer];
        _shapeLayer = shapeLayer;
        
        UILabel *noMoreDataLb = [[UILabel alloc]init];
        noMoreDataLb.font = [UIFont systemFontOfSize:12];
        noMoreDataLb.text = @"没有了哦";
        noMoreDataLb.textColor = CHH_RGBCOLOR(155, 155, 155, 1.0);
        noMoreDataLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:noMoreDataLb];
        [noMoreDataLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(logoView.mas_bottom).offset(2);
        }];
        _noMoreDataLb = noMoreDataLb;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    // 旧的父控件移除监听
    [self removeObservers];

    if (newSuperview) { // 新的父控件
        _scrollView = (UIScrollView *)newSuperview;
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        _scrollViewOriginalInset = _scrollView.mj_inset;
    }
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
}

- (CAShapeLayer *)creatCircleShapeLayerWithBounds:(CGRect)bounds startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    UIBezierPath *path       = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds)) radius:CGRectGetMidX(bounds) startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor     = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor   = sl_normalColors.CGColor;
    shapeLayer.lineWidth     = 1.8;
    shapeLayer.path          = path.CGPath;
    shapeLayer.frame         = bounds;
    return shapeLayer;
}
#pragma - mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGSize oldSize = [change[@"old"] CGSizeValue];
    CGSize nowSize = [change[@"new"] CGSizeValue];
    if (oldSize.height != nowSize.height) {
        if (_contentSizeDidChange) {
            _contentSizeDidChange();
        }
    }
}

@end

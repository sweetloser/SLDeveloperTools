//
//  BXRefreshFooter.m
//  BXlive
//
//  Created by bxlive on 2018/9/21.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXRefreshFooter.h"
#import "../SLCategory/UIColor+Kit.h"
#import "../SLMacro/SLMacro.h"
@interface BXRefreshFooter ()

@property (strong, nonatomic) UIImageView *logoView;
@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) UILabel *noMoreDataLb;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation BXRefreshFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Const
CGRect kABounds = {0,0,25,25};

#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare {
     [super prepare];

     CAShapeLayer *shapeLayer = [self creatCircleShapeLayerWithBounds:kABounds startAngle:M_PI / 4 endAngle:M_PI * 2 clockwise:YES];
     [self.circleView.layer addSublayer:shapeLayer];
     [self.logoView addSubview:self.circleView];
     [self addSubview:self.logoView];
    _shapeLayer = shapeLayer;
    
    _noMoreDataLb = [[UILabel alloc]init];
    _noMoreDataLb.font = [UIFont systemFontOfSize:12];
    _noMoreDataLb.text = @"没有了哦";
    _noMoreDataLb.textColor = CHH_RGBCOLOR(155, 155, 155, 1.0);
    _noMoreDataLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_noMoreDataLb];
    _noMoreDataLb.hidden = YES;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    self.logoView.center = CGPointMake(self.mj_w/2.0, self.mj_h/2.0);// -3是为了logoView在中心点往下一点的位置，方便观看
    self.logoView.bounds = kABounds;
    self.circleView.frame = self.logoView.bounds;
    _noMoreDataLb.frame = CGRectMake(0, self.logoView.mj_y + self.logoView.mj_h + 2, self.mj_w, 20);
}

#pragma mark - setter & getter

- (UIImageView *)logoView{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
        _logoView.image = [UIImage imageNamed:@"refresh_center"];
    }
    return _logoView;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc]init];
    }
    return _circleView;
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

-(CABasicAnimation *)creatTransformAnimation{
    CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation"]; //指定对transform.rotation属性做动画
    animation.duration            = 1.5f; //设定动画持续时间
    animation.byValue             = @(M_PI*2); //设定旋转角度，单位是弧度
    animation.fillMode            = kCAFillModeForwards;//设定动画结束后，不恢复初始状态之设置一
    animation.repeatCount         = 1000;//设定动画执行次数
    animation.removedOnCompletion = NO;//设定动画结束后，不恢复初始状态之设置二
    return animation;
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    // 根据状态做事情
    _noMoreDataLb.hidden = YES;
    if (state == MJRefreshStateIdle) {
        [self.circleView.layer removeAllAnimations];
    } else if (state == MJRefreshStatePulling) {
        [self.circleView.layer addAnimation:[self creatTransformAnimation] forKey:nil];
    } else if (state == MJRefreshStateRefreshing) {
        
    } else if (state == MJRefreshStateNoMoreData) {
        [self.circleView.layer removeAllAnimations];
        _noMoreDataLb.hidden = NO;
    }
}

@end

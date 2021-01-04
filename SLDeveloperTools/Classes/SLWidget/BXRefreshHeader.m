//
//  BXRefreshHeader.m
//  BXlive
//
//  Created by bxlive on 2018/9/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXRefreshHeader.h"
#import "../SLCategory/UIColor+Kit.h"
#import "../SLMacro/SLMacro.h"
@interface BXRefreshHeader ()





@property (assign, nonatomic) BOOL hasRefreshed;
@property (copy, nonatomic) NSString *refresh_text;

@end

@implementation BXRefreshHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Const
CGRect kBounds = {0,0,25,25};
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.mj_h = 60;
    
    _shapeLayer = [self creatCircleShapeLayerWithBounds:kBounds startAngle:M_PI / 4 endAngle:M_PI * 2 clockwise:YES];
    [self.circleView.layer addSublayer:_shapeLayer];
    [self.logoView addSubview:self.circleView];
    [self.logoView.layer addSublayer:self.circleLayer];
    [self addSubview:self.logoView];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.font = [UIFont systemFontOfSize:12];
    _titleLb.textColor = CHH_RGBCOLOR(155, 155, 155, 1.0);
    _titleLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLb];
    
    self.hasRefreshed = NO;//初始化的时候，肯定是没有刷新过的
    _refresh_text = [self getrefreshText];
    _titleLb.text = _refresh_text;
    
}

- (NSString *)getrefreshText {
//    NSArray *refresh_texts = [BXAppInfo appInfo].refresh_texts;
//    if (refresh_texts.count) {
//        NSInteger index = arc4random_uniform((uint32_t)refresh_texts.count);
//        return refresh_texts[index];
//    } else {
        return @"";
//    }
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.logoView.center = CGPointMake(self.mj_w/2.0, self.mj_h/2.0 + 10);// +10是为了logoView在中心点往下一点的位置，方便观看
    self.logoView.bounds = kBounds;
    self.circleView.frame = self.logoView.bounds;
    
    _titleLb.frame = CGRectMake(0, self.logoView.mj_y - 24, self.mj_w, 20);
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
        _circleView.hidden = YES; //刷新时候的图片，开始的时候不需要显示出来
    }
    return _circleView;
}

- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [self creatCircleShapeLayerWithBounds:kBounds startAngle:-M_PI / 2 endAngle:M_PI * 2 - M_PI / 2 clockwise:YES];
    }
    return _circleLayer;
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
    CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration            = 1.5f;
    animation.byValue             = @(M_PI*2);
    animation.fillMode            = kCAFillModeForwards;
    animation.repeatCount         = 1000;
    animation.removedOnCompletion = NO;
    return animation;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.circleLayer.hidden = NO;
            [CATransaction commit];
            self.circleView.hidden = YES;
            _refresh_text = [self getrefreshText];
            break;
        case MJRefreshStatePulling:
            break;
        case MJRefreshStateRefreshing:
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.circleLayer.hidden = YES;
            [CATransaction commit];
            
            self.circleView.hidden = NO;
            [self.circleView.layer addAnimation:[self creatTransformAnimation] forKey:nil];
            
            self.hasRefreshed = YES;//刷新过了
            break;
        default:
            break;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {//监听拖拽比例（控件被拖出来的比例）
    if (self.hasRefreshed) {//刷新返回的时候，strokeEnd = 0.0
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.circleLayer.strokeEnd = 0.0;
        [CATransaction commit];
        self.hasRefreshed = NO;//重置状态为未刷新
    }else{
        self.circleLayer.strokeEnd = pullingPercent;
    }
    
    if (pullingPercent > 0 && ![_titleLb.text isEqualToString:_refresh_text]) {
        _titleLb.text = _refresh_text;
    }
}

- (void)endRefreshing {
    [self.circleView.layer removeAllAnimations];
    [super endRefreshing];
}

@end

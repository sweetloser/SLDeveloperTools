//
//  SLHomePageVedioPlayProgressView.m
//  BXlive
//
//  Created by sweetloser on 2020/6/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLHomePageVedioPlayProgressView.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
@interface SLHomePageVedioPlayProgressView ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@property(strong,nonatomic)CAShapeLayer *underLayer;

@end

@implementation SLHomePageVedioPlayProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SLClearColor;
       
        CGFloat lineW =1;
        
        UIBezierPath *underPath = [UIBezierPath bezierPath];
        [underPath moveToPoint:CGPointMake(0, self.height-lineW/2)];

        [underPath addLineToPoint:CGPointMake(self.width/2 - 23, self.height-lineW/2)];

        [underPath addArcWithCenter:CGPointMake(self.width/2, 25) radius:27 startAngle:1.31*M_PI endAngle:1.79*M_PI clockwise:YES];

        [underPath addLineToPoint:CGPointMake(self.width, self.height-lineW/2)];
        
//        underPath.lineCapStyle = kCGLineCapRound;
//        underPath.lineJoinStyle = kCGLineJoinRound;
//
        _underLayer = [[CAShapeLayer alloc] init];
        _underLayer.frame = self.bounds;
        _underLayer.path = underPath.CGPath;
        _underLayer.lineWidth = lineW;
        _underLayer.strokeColor = [UIColor sl_colorWithHex:0x000000 alpha:0.2].CGColor;
        _underLayer.fillColor = SLClearColor.CGColor;
        [self.layer addSublayer:_underLayer];
        _underLayer.strokeEnd = 1.0;
        
        
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.path = underPath.CGPath;
        _shapeLayer.lineWidth = lineW;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_shapeLayer];
        _shapeLayer.fillColor = SLClearColor.CGColor;
        _shapeLayer.strokeEnd = 0.0;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    if (progress < 0) {
        progress = 0;
    } else if (progress > 1) {
        progress = 1.0;
    }
    _progress = progress;
    
    if (progress) {
        _shapeLayer.strokeEnd = _progress;
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _shapeLayer.strokeEnd = _progress;
        [CATransaction commit];
    }
}


@end

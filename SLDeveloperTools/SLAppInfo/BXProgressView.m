//
//  BXProgressView.m
//  BXlive
//
//  Created by bxlive on 2019/2/24.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXProgressView.h"
#import "../SLCategory/SLCategory.h"

@interface BXProgressView ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation BXProgressView

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
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.2];
       
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineCapStyle = kCGLineJoinRound;
        
        [path moveToPoint:CGPointMake(0, self.bounds.size.height / 2)];
        [path addLineToPoint:CGPointMake(self.frame.size.width , self.bounds.size.height / 2)];
        
//        [path addLineToPoint:CGPointMake(self.frame.size.width / 2.0 - 25, self.bounds.size.height / 2)];
//        [path addQuadCurveToPoint:CGPointMake(self.frame.size.width / 2.0 + 25, self.bounds.size.height / 2) controlPoint:CGPointMake(self.frame.size.width / 2.0, -25)];
//        [path addLineToPoint:CGPointMake(self.frame.size.width / 2.0 + 25, self.bounds.size.height / 2)];

        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.path = path.CGPath;
        _shapeLayer.lineWidth = self.height;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;

        [self.layer addSublayer:_shapeLayer];

        _shapeLayer.strokeEnd = 0.0;
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    float x = rect.origin.x;
    float y = rect.origin.y;
    float w = rect.size.width;
    float h = rect.size.height;
    // 一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 画笔线的颜色
    CGContextSetRGBStrokeColor(context,1,0,0,0);
    // 线的宽度
    CGContextSetLineWidth(context, 1.0);
    // 填充颜色
    UIColor *fullColor = [UIColor whiteColor];
    CGContextSetFillColorWithColor(context, fullColor.CGColor);
    // 绘制路径
    CGContextMoveToPoint(context,x,y);
    CGContextAddLineToPoint(context,x,h);
    CGContextAddLineToPoint(context,w,h);
    CGContextAddLineToPoint(context,w,y);
    CGContextAddArcToPoint(context,w/2.0,30,x,y,w*2);
    CGContextAddLineToPoint(context,x,y);
    // CGContextStrokePath(context);
    // 绘制路径加填充
    CGContextDrawPath(context, kCGPathFillStroke);


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

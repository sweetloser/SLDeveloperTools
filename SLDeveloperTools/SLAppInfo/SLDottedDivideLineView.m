//
//  SLDottedDivideLineView.m
//  BXlive
//
//  Created by sweetloser on 2020/6/16.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLDottedDivideLineView.h"
#import <SLDeveloperTools/SLDeveloperTools.h>

@interface SLDottedDivideLineView ()

@property(nonatomic,assign)CGFloat shortl;

@property(nonatomic,strong)UIColor *color;

@end

@implementation SLDottedDivideLineView

- (instancetype)initWithFrame:(CGRect)frame shortLineLength:(CGFloat)shortL color:(UIColor *)color{
    self = [super initWithFrame:frame];
    if (self) {
        self.shortl = shortL;
        self.color = color;
        [self setNeedsDisplay];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充色设置成
    CGFloat lengths[] = {self.shortl};
    CGContextSetLineDash(context, 0, lengths,1);
    CGContextSetLineWidth(context,self.width);
    
    CGContextFillRect(context,self.bounds);//把整个空间用刚设置的颜色填充
    //上面是准备工作，下面开始画线了
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);//设置线的颜色
    CGContextMoveToPoint(context,0,0);//画线的起始点位置
    CGContextAddLineToPoint(context,0,self.frame.size.height);//画第一条线的终点位置
    
    CGContextStrokePath(context);//把线在界面上绘制出来
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

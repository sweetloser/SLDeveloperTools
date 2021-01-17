//
//  BXCustomCalloutView.m
//  Category_demo2D
//
//  Created by xiaoming han on 13-5-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BXCustomCalloutView.h"
#import <QuartzCore/QuartzCore.h>
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>

#define kArrorHeight    10

@implementation BXCustomCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = WhiteBgTitleColor;
        _titleLb.font = CFont(14);
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(16);
        }];
        
        _subTitleLb = [[UILabel alloc]init];
        _subTitleLb.textColor = CHHCOLOR_D(0xA8AFAF);
        _subTitleLb.font = CFont(12);
        [self addSubview:_subTitleLb];
        [_subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.titleLb);
            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(5);
            make.height.mas_equalTo(14);
        }];
    }
    return self;
}

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = .5;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

@end

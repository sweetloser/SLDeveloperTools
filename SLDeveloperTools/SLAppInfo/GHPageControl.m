//
//  GHPageControl.m
//  BXlive
//
//  Created by mac on 2020/8/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "GHPageControl.h"
#import "../SLCategory/SLCategory.h"

#define dotW 4
#define magrin 10
@implementation GHPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (UIImageView *)imageViewForSubview:(UIView *)view currPage:(int)currPage{
    UIImageView *dot = nil;
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
           
            [view addSubview:dot];
        }
    }else {
        dot = (UIImageView *)view;
    }
    
    return dot;
}

-(void)updateDots{
    for (int i=0;i<self.subviews.count;i++) {
        
        UIView *subview = self.subviews[i];
        
        UIView *dot = subview;

        //计算圆点间距
        CGFloat marginX = dotW + magrin;

        //计算整个pageControll的宽度
        CGFloat newW = (self.subviews.count - 1 ) * marginX;

        //设置新frame
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);

        //设置居中
        CGPoint center = self.center;
        center.x = self.superview.center.x;
        self.center = center;
        
//        if ([subview isKindOfClass:[UIImageView class]]) {
            
//            dot = (UIImageView *)subview;
        dot.height = 5;
        if (i == self.currentPage){
            dot.width = 10;
//            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, 14, dotW)];
//            self.backgroundColor = [UIColor redColor];
//                dot.image = activeImage;
        }else{
//            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
            dot.width = 5;
            
//                dot.image = inactiveImage;
            
        }
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = 2.5;
    }
}
- (void)setCurrentPage:(NSInteger)currentPage{
    
    [super setCurrentPage:currentPage];
    
    [self updateDots];
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    //计算圆点间距
//    CGFloat marginX = dotW + magrin;
//
//    //计算整个pageControll的宽度
//    CGFloat newW = (self.subviews.count - 1 ) * marginX;
//
//    //设置新frame
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
//
//    //设置居中
//    CGPoint center = self.center;
//    center.x = self.superview.center.x;
//    self.center = center;
//
//    //遍历subview,设置圆点frame
//    for (int i=0; i<[self.subviews count]; i++) {
//        UIImageView* dot = [self.subviews objectAtIndex:i];
//        [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
//    }
//}

@end

//
//  SLDetailPageControl.m
//  BXlive
//
//  Created by sweetloser on 2020/6/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLDetailPageControl.h"
#import <YYCategories/YYCategories.h>

@implementation SLDetailPageControl

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
        
//        if ([subview isKindOfClass:[UIImageView class]]) {
            
//            dot = (UIImageView *)subview;
        if (i == self.currentPage){
            dot.width = 10;
//            self.backgroundColor = [UIColor redColor];
//                dot.image = activeImage;
        }else{
            dot.width = 5;
            
//                dot.image = inactiveImage;
            
        }
        dot.height = 5;
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = 2.5;
    }
}
- (void)setCurrentPage:(NSInteger)currentPage{
    
    [super setCurrentPage:currentPage];
    
    [self updateDots];
}

@end

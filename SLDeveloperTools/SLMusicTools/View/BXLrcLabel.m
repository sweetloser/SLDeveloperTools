//
//  BXLrcLabel.m
//  BXlive
//
//  Created by bxlive on 2019/6/13.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXLrcLabel.h"

@implementation BXLrcLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_color) {
        // 设置颜色
        [_color set];
        
        CGRect fillRect = CGRectMake(0, 0, rect.size.width * self.progress, rect.size.height);
        
        //    UIRectFill(fillRect);
        
        UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
    }
}

@end

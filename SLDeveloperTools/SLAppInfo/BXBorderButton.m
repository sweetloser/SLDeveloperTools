//
//  BXBorderButton.m
//  BXlive
//
//  Created by bxlive on 2019/8/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXBorderButton.h"
#import <SLDeveloperTools/SLDeveloperTools.h>


@interface BXBorderButton ()

@property (nonatomic, strong) CAShapeLayer* shapeLayer;

@end

@implementation BXBorderButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_shapeLayer) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.path = bezierPath.CGPath;
        _shapeLayer.frame = self.bounds;
        _shapeLayer.lineWidth = 1;
        _shapeLayer.strokeColor = SubTitleColor.CGColor;
        _shapeLayer.lineDashPattern = @[@4, @4];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_shapeLayer];
        
        _shapeLayer.hidden = _isNoDisplay;
    }
}

- (void)setIsNoDisplay:(BOOL)isNoDisplay {
    _isNoDisplay = isNoDisplay;
    
    _shapeLayer.hidden = _isNoDisplay;
}

@end

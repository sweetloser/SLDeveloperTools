//
//  BXGradientButton.m
//  BXlive
//
//  Created by bxlive on 2019/3/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXGradientButton.h"
#import "../SLMacro/SLMacro.h"

@interface BXGradientButton ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation BXGradientButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if ([super init]) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(1.0, 0.5);
        _gradientLayer.endPoint = CGPointMake(0, 0.5);
        _gradientLayer.colors = @[(__bridge id)sl_normalColors.CGColor, (__bridge id)sl_normalColors.CGColor];
        _gradientLayer.locations = @[@(0), @(1.0f)];
        [self.layer addSublayer:_gradientLayer];
        
        
        [self setTitleColor:TextBrightestColor forState:BtnNormal];
        [self setTitleColor:ButtonGrayTitleColor forState:BtnSelected];
        self.layer.cornerRadius = 16;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _gradientLayer.hidden = selected;
    [CATransaction commit];
    if (selected) {
        self.backgroundColor = ButtonGrayColor;
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end

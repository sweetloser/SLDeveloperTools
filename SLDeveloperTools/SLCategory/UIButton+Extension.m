//
//  UIButton+Extension.m
//  BXlive
//
//  Created by sweetloser on 2020/5/24.
//  Copyright © 2020 cat. All rights reserved.
//

#import "UIButton+Extension.h"
#import "../SLMacro/SLMacro.h"
@implementation UIButton (Extension)

-(void)sl_setTitleColor:(nullable UIColor *)color{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:sl_normalColors forState:UIControlStateHighlighted];
}
-(void)sl_setTitleNormalColor:(nullable UIColor *)normalColor selectedColor:(UIColor *)selectedColor heightLightColor:(UIColor *)heightLightColor{
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    
    [self setTitleColor:heightLightColor forState:UIControlStateHighlighted];
    
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
}

@end

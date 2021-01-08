//
//  UILabel+Extension.m
//  BXlive
//
//  Created by sweetloser on 2020/5/5.
//  Copyright © 2020 cat. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+(UILabel *)createLabelWithFrame:(CGRect)rect{
    return [[UILabel alloc] initWithFrame:rect];
}
+(UILabel *)createLabelWithFrame:(CGRect)rect BackgroundColor:(UIColor *)backgroundColor{
    UILabel *label = [UILabel createLabelWithFrame:rect];
    label.backgroundColor = backgroundColor;
    return label;
}
+(UILabel *)createLabelWithFrame:(CGRect)rect BackgroundColor:(UIColor *)backgroundColor Text:(NSString *)text{
    UILabel *label = [UILabel createLabelWithFrame:rect BackgroundColor:backgroundColor];
    [label setText:text];
    return label;
}

+(UILabel *)createLabelWithFrame:(CGRect)rect BackgroundColor:(UIColor *)backgroundColor Text:(NSString *)text Font:(UIFont *)font{
    UILabel *label = [UILabel createLabelWithFrame:rect BackgroundColor:backgroundColor Text:text];
    label.font = font;
    return label;
}

+(UILabel *)createLabelWithFrame:(CGRect)rect BackgroundColor:(UIColor *)backgroundColor Text:(NSString *)text Font:(UIFont *)font TextColor:(UIColor *)textColor{
    UILabel *label = [UILabel createLabelWithFrame:rect BackgroundColor:backgroundColor Text:text Font:font];
    [label setTextColor:textColor];
    return label;
}

@end

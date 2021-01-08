//
//  UILabel+Extension.h
//  BXlive
//
//  Created by sweetloser on 2020/5/5.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Extension)
+(UILabel *)createLabelWithFrame:(CGRect)rect;
+(UILabel *)createLabelWithFrame:(CGRect)rect BackgroundColor:(UIColor *)backgroundColor;
+(UILabel *)createLabelWithFrame:(CGRect)rect BackgroundColor:(UIColor *)backgroundColor Text:(NSString *)text;
+(UILabel *)createLabelWithFrame:(CGRect)rect BackgroundColor:(UIColor *)backgroundColor Text:(NSString *)text Font:(UIFont *)font;
+(UILabel *)createLabelWithFrame:(CGRect)rect BackgroundColor:(UIColor *)backgroundColor Text:(NSString *)text Font:(UIFont *)font TextColor:(UIColor *)textColor;
@end

NS_ASSUME_NONNULL_END

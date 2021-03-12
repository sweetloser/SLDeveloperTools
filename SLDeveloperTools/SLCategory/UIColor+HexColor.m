//
//  UIColor+HexColor.h
//  ZKGX
//
//  Created by 王洋 on 2019/6/15.
//  Copyright © 2019 王洋. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    if (hexString.length) {
        NSMutableString *mHexColor = [NSMutableString stringWithString:hexString];
        if ([hexString hasPrefix:@"#"])
        {
            [mHexColor replaceCharactersInRange:[hexString rangeOfString:@"#" ] withString:@"0x"];
        }
        long colorLong = strtoul([mHexColor cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
        // 通过位与方法获取三色值
        int R = (colorLong & 0xFF0000) >> 16;
        int G = (colorLong & 0x00FF00) >> 8;
        int B = colorLong & 0x0000FF;
        
        return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    }
    return nil;
}

+ (UIColor *)colorAlphaWithHexString:(NSString *)hexString
{
    if (hexString.length) {
        NSString *realHexString = [hexString hasPrefix:@"#"] ? [hexString substringFromIndex:1] : hexString;
        unsigned long colorLong = strtoul([realHexString cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
        
        // 通过位与方法获取三色值
        unsigned int B = colorLong & 0xff;
        unsigned int G = (colorLong = colorLong >> 8) & 0xff;
        unsigned int R = (colorLong = colorLong >> 8) & 0xff;
        unsigned int A = (colorLong = colorLong >> 8) & 0xff;
        
        return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A/255.0];
    }
    return nil;
}

/// 适配暗黑模式颜色   传入的UIColor对象
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor DarkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return lightColor;
            } else {
                return darkColor;
            }
        }];
    } else {
        return lightColor ? lightColor : (darkColor ? darkColor : [UIColor clearColor]);
    }
}

/// 适配暗黑模式颜色   颜色传入的是16进制字符串
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)colorWithLightColorStr:(NSString *)lightColor DarkColor:(NSString *)darkColor{
    return [UIColor colorWithLightColor:[UIColor colorWithHexString:lightColor] DarkColor:[UIColor colorWithHexString:darkColor]];
}

@end

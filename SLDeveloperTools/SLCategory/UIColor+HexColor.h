//
//  UIColor+HexColor.h
//  ZKGX
//
//  Created by 王洋 on 2019/6/15.
//  Copyright © 2019 王洋. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]


#define UIColorLightAndDarkHex(_lighthex_,_darkhex_)  [UIColor colorWithLightColorStr:((__bridge NSString *)CFSTR(#_lighthex_)) DarkColor:((__bridge NSString *)CFSTR(#_darkhex_))]

@interface UIColor (HexColor)
/**
 *  16进制和RGB的转换
 *
 *  @param hexString 16进制
 *
 *  @return 转换后的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorAlphaWithHexString:(NSString *)hexString;


/// 适配暗黑模式颜色   传入的UIColor对象
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor DarkColor:(UIColor *)darkColor;

/// 适配暗黑模式颜色   颜色传入的是16进制字符串
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)colorWithLightColorStr:(NSString *)lightColor DarkColor:(NSString *)darkColor;

@end

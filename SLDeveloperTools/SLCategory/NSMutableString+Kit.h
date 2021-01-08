//
//  NSMutableString+Kit.h
//  BXlive
//
//  Created by bxlive on 16/7/19.
//  Copyright © 2016年 lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Kit)
+(NSMutableAttributedString *)settext:(NSString *)text;
/**
 *  设置文字不同颜色
 *
 *  @param str      要设置的字符串
 *  @param rangeStr 要改变颜色的字符串
 *  @param color    要设置的颜色
 *
 *  @return 返回字符串
 */
+ (NSMutableAttributedString *)setStringColorWith:(NSString *)str rangeOfString:(NSString *)rangeStr color:(UIColor *)color font:(UIFont *)font;



+(NSMutableAttributedString *)getCoinString:(NSString *)coin detailText:(NSString *)detailText fontSize:(UIFont *)fontSize color:(UIColor *)color otherFontSize:(UIFont *)otherFontSize isLine:(BOOL)isLine;


@end

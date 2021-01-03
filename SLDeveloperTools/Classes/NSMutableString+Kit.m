//
//  NSMutableString+Kit.m
//  BXlive
//
//  Created by bxlive on 16/7/19.
//  Copyright © 2016年 lei. All rights reserved.
//

#import "NSMutableString+Kit.h"

@implementation NSMutableString (Kit)
+(NSMutableAttributedString *)settext:(NSString *)text{
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    NSRange range = NSMakeRange(0, [text rangeOfString:@" "].location);
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    
    return AttributedStr;
}

+ (NSMutableAttributedString *)setStringColorWith:(NSString *)str rangeOfString:(NSString *)rangeStr color:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:str];
    [strA addAttribute:NSForegroundColorAttributeName value:color range:[str rangeOfString:rangeStr]];
    [strA addAttribute:NSFontAttributeName value:font range:[str rangeOfString:rangeStr]];
    return strA;
}


+(NSMutableAttributedString *)getCoinString:(NSString *)coin detailText:(NSString *)detailText fontSize:(UIFont *)fontSize color:(UIColor *)color otherFontSize:(UIFont *)otherFontSize isLine:(BOOL)isLine{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@%@%@",coin,isLine==YES?@"\n":@"",detailText] attributes: @{NSFontAttributeName: fontSize,NSForegroundColorAttributeName:color}];
    
    [attribute addAttributes:@{NSFontAttributeName: otherFontSize} range:[[attribute string] rangeOfString:detailText]];
    
    return attribute;
    
}



@end

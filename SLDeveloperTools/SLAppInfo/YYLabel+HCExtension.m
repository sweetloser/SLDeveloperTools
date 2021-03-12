//
//  YYLabel+Extension.m
//  XTMall
//
//  Created by LayChan on 2020/5/16.
//  Copyright © 2020 LayChan. All rights reserved.
//

#import "YYLabel+HCExtension.h"
#import <YYText/YYText.h>
#import <YYCategories/YYCategories.h>

@implementation YYLabel (HCExtension)

+ (NSMutableAttributedString *)xt_attributeText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font {
    NSString *str = text;
    if (str == nil) {
        str = @"";
    }
    
    NSMutableAttributedString *tString = [[NSMutableAttributedString alloc] initWithString:str];
    tString.yy_color = color;
    tString.yy_font = font;
    
    return tString;
}

+ (NSMutableAttributedString *)xt_attributeText:(NSString *)text textColor:(UIColor *)color textVerticalAlignment:(YYTextVerticalAlignment)tAlignment font:(UIFont *)font image:(UIImage *)image imageSize:(CGSize)size textIsLeft:(BOOL)isLeft {
    NSString *str = text;
    if (str == nil) {
        str = @"";
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *tString = [[NSMutableAttributedString alloc] initWithString:str];
    tString.yy_color = color;
    tString.yy_font = font;
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:size alignToFont:font alignment:tAlignment];
    
    if (isLeft) {
        [attributedText appendAttributedString:tString];
        [attributedText appendAttributedString:attachText];
    } else {
        [attributedText appendAttributedString:attachText];
        [attributedText appendAttributedString:tString];
    }
    
    return attributedText;
}

+ (NSAttributedString *) hc_getGoodsNameAttributedStringWith:(NSString *) tagString nameString: (NSString *) nameString {
    NSMutableAttributedString *goodsNameAttr = [[NSMutableAttributedString alloc] init];

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", tagString]];
    attr.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];;
    attr.yy_color = [UIColor colorWithHexString:@"#FFFFFF"];
    attr.yy_lineSpacing = 5;
    
    YYTextBorder *border = [YYTextBorder borderWithFillColor:[UIColor colorWithHexString:@"#FF2D52"] cornerRadius:3.0];
    attr.yy_textBackgroundBorder = border;
    
    NSMutableAttributedString *tempAttr = [[NSMutableAttributedString alloc] initWithString:@" "];
    tempAttr.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];;
    
    NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", nameString]];
    nameAttr.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];;
    nameAttr.yy_color = [UIColor colorWithHexString:@"#000000"];
    nameAttr.yy_lineSpacing = 5;
    
    [goodsNameAttr appendAttributedString:tempAttr];
    [goodsNameAttr appendAttributedString:attr];
    [goodsNameAttr appendAttributedString:tempAttr];
    [goodsNameAttr appendAttributedString:nameAttr];
    
    return goodsNameAttr;
}

+ (NSAttributedString *) hc_getGoodsPriceAttributedStringWith:(NSString *) leftString rightString: (NSString *) rightString {
    NSMutableAttributedString *goodsPriceAttr = [[NSMutableAttributedString alloc] init];

    NSMutableAttributedString *leftAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", leftString]];
    leftAttr.yy_font =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    leftAttr.yy_color = [UIColor colorWithHexString:@"#FF2D52"];
    
    NSMutableAttributedString *rightAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", rightString]];
    rightAttr.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    rightAttr.yy_color = [UIColor colorWithHexString:@"#FF2D52"];
    
    [goodsPriceAttr appendAttributedString:leftAttr];
    [goodsPriceAttr appendAttributedString:rightAttr];
    
    return goodsPriceAttr;
}


@end

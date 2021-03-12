//
//  YYLabel+Extension.m
//  XTMall
//
//  Created by LayChan on 2020/5/16.
//  Copyright © 2020 LayChan. All rights reserved.
//

#import "YYLabel+Extension.h"
#import <YYText/YYText.h>

@implementation YYLabel (Extension)

+ (NSMutableAttributedString *)lc_attributeText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font {
    NSString *str = text;
    if (str == nil) {
        str = @"";
    }
    
    NSMutableAttributedString *tString = [[NSMutableAttributedString alloc] initWithString:str];
    tString.yy_color = color;
    tString.yy_font = font;
    
    return tString;
}

+ (NSMutableAttributedString *)lc_attributeText:(NSString *)text textColor:(UIColor *)color textVerticalAlignment:(YYTextVerticalAlignment)tAlignment font:(UIFont *)font image:(UIImage *)image imageSize:(CGSize)size textIsLeft:(BOOL)isLeft {
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

+ (NSMutableAttributedString *)lc_attributeTextAttachView:(UIView *)view text:(NSString *)text textColor:(UIColor *)color textVerticalAlignment:(YYTextVerticalAlignment)tAlignment font:(UIFont *)font viewSize:(CGSize)size textIsLeft:(BOOL)isLeft {
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *tString = [[NSMutableAttributedString alloc] initWithString:text];
    tString.yy_color = color;
    tString.yy_font = font;
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:view contentMode:UIViewContentModeScaleAspectFit attachmentSize:size alignToFont:font alignment:tAlignment];
    
    if (isLeft) {
        [attributedText appendAttributedString:tString];
        [attributedText appendAttributedString:attachText];
    } else {
        [attributedText appendAttributedString:attachText];
        [attributedText appendAttributedString:tString];
    }
    
    return attributedText;
}

@end

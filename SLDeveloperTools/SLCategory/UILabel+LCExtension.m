//
//  UILabel+LCExtension.m
//  BXlive
//
//  Created by Lay Chan on 2020/11/3.
//  Copyright © 2020 cat. All rights reserved.
//

#import "UILabel+LCExtension.h"

@implementation UILabel (LCExtension)

+ (CGSize)lc_labelSizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size lineSpacing:(CGFloat)lineSpacing {
    NSString *str = text;
    if (str == nil) {
        str = @"";
    }
    
    NSMutableParagraphStyle *paraph = [[NSMutableParagraphStyle alloc] init];
    paraph.lineSpacing = lineSpacing;
    
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paraph};
    CGRect labelRect = [str boundingRectWithSize:size options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    
    return labelRect.size;
}

+ (NSMutableAttributedString *)lc_attributedStringWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing {
    NSString *str = text;
    if (str == nil) {
        str = @"";
    }
    
    NSMutableParagraphStyle *paraph = [[NSMutableParagraphStyle alloc] init];
    paraph.lineSpacing = lineSpacing;

    NSDictionary *attributes = @{NSParagraphStyleAttributeName :paraph,
                                 NSForegroundColorAttributeName: textColor,
                                 NSFontAttributeName           :font};
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrString addAttributes:attributes range:NSMakeRange(0, [str length])];
    
    return attrString;
}

- (void)topAlignment {
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    self.numberOfLines = 0;//为了添加\n必须为0
    NSInteger newLinesToPad = (self.frame.size.height - rect.size.height)/size.height;

    for (NSInteger i = 0; i < newLinesToPad; i ++) {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

@end

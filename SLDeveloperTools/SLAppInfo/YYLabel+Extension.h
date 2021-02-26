//
//  YYLabel+Extension.h
//  XTMall
//
//  Created by LayChan on 2020/5/16.
//  Copyright © 2020 LayChan. All rights reserved.
//

#import "YYLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYLabel (Extension)

+ (NSMutableAttributedString *)lc_attributeText: (NSString *)text textColor: (UIColor *)color font: (UIFont *)font;

+ (NSMutableAttributedString *)lc_attributeText:(NSString *)text textColor: (UIColor *)color textVerticalAlignment: (YYTextVerticalAlignment)tAlignment font: (UIFont *)font image: (UIImage *)image imageSize: (CGSize)size textIsLeft: (BOOL)isLeft;

+ (NSMutableAttributedString *)lc_attributeTextAttachView:(UIView *)view text:(NSString *)text textColor: (UIColor *)color textVerticalAlignment: (YYTextVerticalAlignment)tAlignment font: (UIFont *)font viewSize: (CGSize)size textIsLeft: (BOOL)isLeft;

@end

NS_ASSUME_NONNULL_END

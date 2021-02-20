//
//  YYLabel+Extension.h
//  XTMall
//
//  Created by LayChan on 2020/5/16.
//  Copyright © 2020 LayChan. All rights reserved.
//

#import "YYLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYLabel (HCExtension)

+ (NSMutableAttributedString *)xt_attributeText: (NSString *)text textColor: (UIColor *)color font: (UIFont *)font;

+ (NSMutableAttributedString *)xt_attributeText:(NSString *)text textColor:(UIColor *)color textVerticalAlignment:(YYTextVerticalAlignment)tAlignment font:(UIFont *)font image:(UIImage *)image imageSize:(CGSize)size textIsLeft:(BOOL)isLeft;

+ (NSAttributedString *) hc_getGoodsNameAttributedStringWith:(NSString *) tagString nameString: (NSString *) nameString;

+ (NSAttributedString *) hc_getGoodsPriceAttributedStringWith:(NSString *) leftString rightString: (NSString *) rightString;

@end

NS_ASSUME_NONNULL_END

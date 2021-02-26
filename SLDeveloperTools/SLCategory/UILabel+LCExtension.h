//
//  UILabel+LCExtension.h
//  BXlive
//
//  Created by Lay Chan on 2020/11/3.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (LCExtension)

+ (CGSize)lc_labelSizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size lineSpacing:(CGFloat)lineSpacing;

+ (NSMutableAttributedString *)lc_attributedStringWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing;

- (void)topAlignment;

@end

NS_ASSUME_NONNULL_END

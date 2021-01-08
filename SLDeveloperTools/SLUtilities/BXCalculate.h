//
//  BXCalculate.h
//  BXlive
//
//  Created by bxlive on 2019/5/31.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXCalculate : NSObject

/** 根据内容计算宽度 */
+(CGFloat)calculateRowWidth:(NSString *)string Font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END

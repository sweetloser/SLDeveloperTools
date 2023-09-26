//
//  BXCalculate.m
//  BXlive
//
//  Created by bxlive on 2019/5/31.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXCalculate.h"

@implementation BXCalculate

#pragma mark - 根据内容计算宽度
+(CGFloat)calculateRowWidth:(NSString *)string Font:(UIFont *)font {
    NSDictionary *dic = @{NSFontAttributeName:font};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

@end

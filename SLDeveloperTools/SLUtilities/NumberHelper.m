//
//  NumberHelper.m
//  BXlive
//
//  Created by bxlive on 2018/4/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "NumberHelper.h"

@implementation NumberHelper

+ (NSString *)changeTimesWithNumber:(NSInteger)number {
    NSString *str = nil;
    CGFloat f = number * 1.0 / 10000;
    if (f >= 1) {
        str = [NSString stringWithFormat:@"%.2f万",f];
    } else {
        str = [NSString stringWithFormat:@"%ld",(long)number];
    }
    return str;
}

@end

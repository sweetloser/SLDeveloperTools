//
//  NumberHelper.h
//  BXlive
//
//  Created by bxlive on 2018/4/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberHelper : NSObject

//转变次数，比如点赞次数、观看次数
+ (NSString *)changeTimesWithNumber:(NSInteger)number;

@end

//
//  JsonHelper.h
//  信云课堂
//
//  Created by lifuyong on 14-10-8.
//  Copyright (c) 2014年 besttone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonHelper : NSObject

+ (NSString *)jsonStringWithObject:(id)object;
+ (id)jsonObjectFromJsonString:(NSString *)jsonString;

@end

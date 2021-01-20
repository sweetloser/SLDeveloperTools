//
//  JsonHelper.m
//  信云课堂
//
//  Created by lifuyong on 14-10-8.
//  Copyright (c) 2014年 besttone. All rights reserved.
//

#import "JsonHelper.h"

@implementation JsonHelper

+ (NSString *)jsonStringWithObject:(id)object
{
    if (!object) {
        return @"";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (id)jsonObjectFromJsonString:(NSString *)jsonString
{
    if (!jsonString) {
        return nil;
    }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonObject;
}

@end

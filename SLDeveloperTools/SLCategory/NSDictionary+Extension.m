//
//  NSDictionary+Extension.m
//  BXlive
//
//  Created by sweetloser on 2020/5/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

-(NSString *)dictionaryToJsonString{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"%@",error.localizedFailureReason);
        return @"";
    }
    return [NSString stringWithCString:jsonData.bytes encoding:NSUTF8StringEncoding];
}

@end

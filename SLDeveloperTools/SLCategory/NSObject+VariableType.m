//
//  NSObject+VariableType.m
//  BXlive
//
//  Created by bxlive on 2018/10/11.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "NSObject+VariableType.h"

@implementation NSObject (VariableType)

- (BOOL)isString {
    BOOL type = NO;
    if ([self isKindOfClass:[NSString class]]) {
        type = YES;
    }
    return type;
}

- (BOOL)isNumber {
    BOOL type = NO;
    if ([self isKindOfClass:[NSNumber class]]) {
        type = YES;
    }
    return type;
}

- (BOOL)isArray {
    BOOL type = NO;
    if ([self isKindOfClass:[NSArray class]]) {
        type = YES;
    }
    return type;
}

- (BOOL)isDictionary {
    BOOL type = NO;
    if ([self isKindOfClass:[NSDictionary class]]) {
        type = YES;
    }
    return type;
}

@end

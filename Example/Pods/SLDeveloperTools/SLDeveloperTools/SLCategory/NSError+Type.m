//
//  NSError+Type.m
//  BXlive
//
//  Created by bxlive on 2018/10/17.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "NSError+Type.h"
#import <objc/runtime.h>
@implementation NSError (Type)

- (void)setIsNetWorkConnectionAvailable:(BOOL)isNetWorkConnectionAvailable {
    objc_setAssociatedObject(self, @selector(isNetWorkConnectionAvailable), @(isNetWorkConnectionAvailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isNetWorkConnectionAvailable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

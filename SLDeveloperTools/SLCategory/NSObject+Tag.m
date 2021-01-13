//
//  NSObject+Tag.m
//  BXlive
//
//  Created by bxlive on 2019/5/10.
//  Copyright © 2019 cat. All rights reserved.
//

#import "NSObject+Tag.h"
#import <objc/runtime.h>

@implementation NSObject (Tag)

- (void)setDs_Tag:(NSInteger)ds_Tag {
    objc_setAssociatedObject(self, @selector(ds_Tag), @(ds_Tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)ds_Tag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end

//
//  HHLoginManager.m
//  BXlive
//
//  Created by bxlive on 2018/4/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "HHLoginManager.h"

@implementation HHLoginManager

+ (HHLoginManager *)shareLoginManager {
    static dispatch_once_t onceToken;
    static HHLoginManager *_loginManager;
    dispatch_once(&onceToken, ^{
        _loginManager = [[HHLoginManager alloc]init];
    });
    return _loginManager;
}

+ (BOOL)isCanPushToLogin {
    BOOL isCan = YES;
    if ([HHLoginManager shareLoginManager].count) {
        isCan = NO;
    }
    return isCan;
}

- (instancetype)init {
    if ([super init]) {
        _count = 0;
    }
    return self;
}

- (void)setCount:(NSInteger)count {
    if (count < 0) {
        count = 0;
    }
    _count = count;
}

@end

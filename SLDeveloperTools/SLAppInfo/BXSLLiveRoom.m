//
//  BXSLLiveRoom.m
//  BXlive
//
//  Created by bxlive on 2018/4/17.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXSLLiveRoom.h"

@interface BXSLLiveRoom ()

@property (strong, nonatomic) NSMutableArray *advertisements;    //广告
@property (strong, nonatomic) NSMutableArray *messages;          //消息流

@end

@implementation BXSLLiveRoom

- (instancetype)init {
    if ([super init]) {
        _advertisements = [NSMutableArray array];
        _messages = [NSMutableArray array];
    }
    return self;
}

@end

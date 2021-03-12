//
//  BXHeadline.m
//  BXlive
//
//  Created by bxlive on 2019/5/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXHeadline.h"

@implementation BXHeadline

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    
    _headlineId = jsonDic[@"id"];
}

@end

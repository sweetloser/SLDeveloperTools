//
//  BXGift.m
//  BXlive
//
//  Created by bxlive on 2018/4/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXGift.h"
#import "NSObject+VariableType.h"

@implementation BXGift

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    _giftId = [NSString stringWithFormat:@"%@",jsonDic[@"id"]];
    NSDictionary *dict = jsonDic[@"show_params"];
    if (dict && [dict isDictionary]) {
        _layout =dict[@"layout"];
        _duration =dict[@"duration"];
    }
    
}

@end

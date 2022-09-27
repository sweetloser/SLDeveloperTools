//
//  HHCountrySection.m
//  BXlive
//
//  Created by bxlive on 2018/9/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "HHCountrySection.h"
#import "HHCountry.h"

@implementation HHCountrySection

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSArray *listArray = jsonDic[@"list"];
    for (NSDictionary *dic in listArray) {
        HHCountry *country = [[HHCountry alloc]init];
        [country updateWithJsonDic:dic];
        [tempArray addObject:country];
    }
    _countrys = [NSArray arrayWithArray:tempArray];
    
}

@end

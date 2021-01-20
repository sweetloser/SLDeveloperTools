//
//  BXDynEntryModel.m
//  BXlive
//
//  Created by mac on 2020/7/29.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynEntryModel.h"

@implementation BXDynEntryModel
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"entryID":@"id"};
}
-(void)updateWithJsonDic:(NSDictionary *)jsonDic{
   [super updateWithJsonDic:jsonDic];
    _entryID = jsonDic[@"id"];
}
@end

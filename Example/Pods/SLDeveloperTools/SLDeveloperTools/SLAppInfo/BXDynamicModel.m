//
//  BXDynamicModel.m
//  BXlive
//
//  Created by mac on 2020/7/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynamicModel.h"

@implementation BXDynamicModel
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"dynID":@"id",@"issueType":@"type"};
}
- (instancetype)init {
    if ([super init]) {
//        _friends = [NSMutableArray array];
//        _topics = [NSMutableArray array];
//        _rewardUsers = [NSMutableArray array];
//        _commentlist = [NSMutableArray array];
        _msgdetailmodel = [[BXDynMsgDetailModel alloc]init];
    }
    return self;
}

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    _dynID = jsonDic[@"id"];
    _issueType = jsonDic[@"type"];
    _msgdetailmodel = [[BXDynMsgDetailModel alloc]init];
    [_msgdetailmodel updateWithJsonDic:jsonDic[@"msgdetail"]];
}


-(CGFloat)getRate{
    return 1;;
}
@end

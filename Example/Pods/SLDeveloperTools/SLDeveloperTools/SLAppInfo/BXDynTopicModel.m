//
//  BXDynTopicModel.m
//  BXlive
//
//  Created by mac on 2020/7/28.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTopicModel.h"
#import "../SLCategory/SLCategory.h"
@implementation BXDynTopicModel
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"xinTopic":@"newTopic"};
}
-(void)updateWithJsonDic:(NSDictionary *)jsonDic{
    [super updateWithJsonDic:jsonDic];

    NSDictionary *dic = jsonDic[@"userMsg"];
    if (dic && [dic isDictionary]) {
        _user_id = dic[@"user_id"];
        _avatar = dic[@"avatar"];
        _gender = dic[@"gender"];
        _nickname = dic[@"nickname"];
    }
}
@end

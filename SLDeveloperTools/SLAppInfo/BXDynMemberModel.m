//
//  BXDynMemberModel.m
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynMemberModel.h"
#import "../SLCategory/SLCategory.h"

@implementation BXDynMemberModel
-(instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}
//+(NSDictionary *)replacedKeyFromPropertyName{
//    return @{@"dynID":@"id"};
//}
-(void)updateWithJsonDic:(NSDictionary *)jsonDic{
    [super updateWithJsonDic:jsonDic];
    
    NSDictionary *dic = jsonDic[@"umsg"];
    if (dic && [dic isDictionary]) {
        _user_id = dic[@"user_id"];
        _avatar = dic[@"avatar"];
        _nickname = dic[@"nickname"];
        _gender = dic[@"gender"];
        if (dic[@"difftime"]&& ![dic[@"difftime"] isEqualToString:@""] ) {
            _difftime = dic[@"difftime"];
        }
    }
    

}
@end

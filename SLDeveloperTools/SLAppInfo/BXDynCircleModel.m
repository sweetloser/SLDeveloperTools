//
//  DynCircleModel.m
//  BXlive
//
//  Created by mac on 2020/7/28.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleModel.h"
#import "../SLCategory/SLCategory.h"
@implementation BXDynCircleModel
- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    
    NSDictionary *dic = jsonDic[@"userMsg"];
    if (dic && [dic isDictionary]) {
        _user_id = dic[@"user_id"];
        _avatar = dic[@"avatar"];
        _gender = dic[@"gender"];
        _nickname = dic[@"nickname"];
    }
    
    NSDictionary *detaildic = jsonDic[@"userdetail"];
    if (detaildic && [detaildic isDictionary]) {
        _user_id = detaildic[@"user_id"];
        _avatar = detaildic[@"avatar"];
        _gender = detaildic[@"gender"];
        _nickname = detaildic[@"nickname"];
    }
    
}
@end

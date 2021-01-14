//
//  DynAiTeFriendModel.m
//  BXlive
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DynAiTeFriendModel.h"
#import <SLDeveloperTools/SLDeveloperTools.h>

@implementation DynAiTeFriendModel
- (instancetype)init {
    if ([super init]) {
    }
    return self;
}
- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
//    _user_id = jsonDic[@"user_id"];
//    _nickname = jsonDic[@"nickname"];
//    _avatar = jsonDic[@"avatar"];
//    if (_timedeiff && [_timedeiff isDictionary]) {
//        _day = _timedeiff[@"day"];
//        _hour = _timedeiff[@"hour"];
//        _min = _timedeiff[@"min"];
//        _sec = _timedeiff[@"sec"];
//    }
    if (_userdetail && [_userdetail isDictionary]) {
        _user_id = _userdetail[@"user_id"];
        _nickname = _userdetail[@"nickname"];
        _avatar = _userdetail[@"avatar"];
        _gender = _userdetail[@"gender"];
    }
    
    if (_usermsg && [_usermsg isDictionary]) {
        _user_id = _usermsg[@"user_id"];
        _nickname = _usermsg[@"nickname"];
        _avatar = _usermsg[@"avatar"];
        _gender = _usermsg[@"gender"];
    }
    
}
@end

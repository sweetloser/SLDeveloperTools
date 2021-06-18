//
//  SLAmwayListModel.m
//  BXlive
//
//  Created by sweetloser on 2020/11/5.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLAmwayListModel.h"
#import <MJExtension/MJExtension.h>

@implementation SLAmwayPublicUser

@end

@implementation SLAmwayListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"list_id":@"id"};

}
-(void)ChangeUsermsg{
    if (_usermsg) {
        _user = [[SLAmwayPublicUser alloc]init];
        _user.user_id = _usermsg.user_id;
        _user.nickname = _usermsg.nickname;
        _user.follow_num = _usermsg.follow_num;
        _user.avatar = _usermsg.avatar;

    }
}
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"privatemsg": @"BXLiveUser",
             @"title":@"SLAmwayTopicModel",
             @"imgs_detail":@"SLAmwayDetailImgsDetailInfo",
    };
}

@end

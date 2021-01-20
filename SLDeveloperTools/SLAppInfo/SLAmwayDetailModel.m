//
//  SLAmwayDetailModel.m
//  BXlive
//
//  Created by sweetloser on 2020/11/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLAmwayDetailModel.h"

@implementation SLAmwayDetailUserModel


@end

@implementation SLAmwayDetailShowGoodsInfo

@end

@implementation SLAmwayDetailImgsDetailInfo

@end

@implementation SLAmwayDetailModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"msg_id":@"id"};
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"showgoods":@"SLAmwayDetailShowGoodsInfo",
             @"imgs_detail":@"SLAmwayDetailImgsDetailInfo",
             @"title":@"SLAmwayTopicModel",
             @"privatemsg":@"BXLiveUser",
    };
}

@end

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

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"privatemsg": @"BXLiveUser",
             @"title":@"SLAmwayTopicModel",
             @"imgs_detail":@"SLAmwayDetailImgsDetailInfo",
    };
}

@end

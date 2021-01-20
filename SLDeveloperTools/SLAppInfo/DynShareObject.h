//
//  ShareObject.h
//  BXlive
//
//  Created by bxlive on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DynShareObjectTypeOfWechatSession = 0,
    DynShareObjectTypeOfWechatTimeLine =1,
    DynShareObjectTypeOfQQ,
    DynShareObjectTypeOfQzone,
    DynShareObjectTypeOfLike,
    DynShareObjectTypeOfCollection,
    DynShareObjectTypeOfDownload,
    DynShareObjectTypeOfFollow,
    DynShareObjectTypeOfUnLike,
    DynShareObjectTypeOfReport,
    DynShareObjectTypeOfDelete,
} DynShareObjectType;

@interface DynShareObject : NSObject

@property (assign, nonatomic) DynShareObjectType type;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *iconName;

@property (assign, nonatomic) DynShareObjectType normalType;



+ (instancetype)sharelikeNum:(NSString *)likeNum is_zan:(NSString *)is_zan is_collect:(NSString *)is_collect is_follow:(NSString *)is_follow type:(NSInteger )type;


@end

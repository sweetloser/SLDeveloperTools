//
//  ShareObject.h
//  BXlive
//
//  Created by bxlive on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ShareObjectTypeOfWechatSession = 0,
    ShareObjectTypeOfWechatTimeLine =1,
    ShareObjectTypeOfQQ,
    ShareObjectTypeOfQzone,
#ifdef ChongYouURL
    ShareObjectTypeOfFacebook,
#endif
    ShareObjectTypeOfLike,
    ShareObjectTypeOfCollection,
    ShareObjectTypeOfDownload,
    ShareObjectTypeOfFollow,
    ShareObjectTypeOfUnLike,
    ShareObjectTypeOfReport,
    ShareObjectTypeOfDelete,
} ShareObjectType;

@interface ShareObject : NSObject

@property (assign, nonatomic) ShareObjectType type;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *iconName;

@property (assign, nonatomic) ShareObjectType normalType;



+ (instancetype)sharelikeNum:(NSString *)likeNum is_zan:(NSString *)is_zan is_collect:(NSString *)is_collect is_follow:(NSString *)is_follow type:(NSInteger )type;


@end

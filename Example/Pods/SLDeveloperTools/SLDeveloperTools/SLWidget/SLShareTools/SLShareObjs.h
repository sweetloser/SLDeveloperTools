//
//  SLShareObjs.h
//  BXlive
//
//  Created by sweetloser on 2020/8/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SLShareObjsTypeOfSave = 0,            //保存
    SLShareObjsTypeOfWechatSession = 1,       //微信
    SLShareObjsTypeOfWechatTimeLine = 2,     //朋友圈
    SLShareObjsTypeOfQQ = 4,                  //QQ
    SLShareObjsTypeOfQzone = 5,               //QQ空间
    SLShareObjsTypeOfLike,
    SLShareObjsTypeOfCollection,
    SLShareObjsTypeOfDownload,
    SLShareObjsTypeOfFollow,
    SLShareObjsTypeOfUnLike,
    SLShareObjsTypeOfReport,
    SLShareObjsTypeOfDelete,
} SLShareObjsType;


@interface SLShareObjs : NSObject

@property(nonatomic, copy)NSString *iconName;           // 分享图标
    
@property(nonatomic, copy)NSString *name;          //分享按钮下方的标题

@property(nonatomic, assign)SLShareObjsType shareType;       //分享类型

@end

NS_ASSUME_NONNULL_END

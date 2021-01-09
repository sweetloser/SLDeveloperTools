//
//  DynCircleModel.h
//  BXlive
//
//  Created by mac on 2020/7/28.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynCircleModel : BaseObject
@property (copy, nonatomic) NSString *uid;            //发布者id
@property (copy, nonatomic) NSString *circle_id;            //圈子id
@property (copy, nonatomic) NSString *circle_name;            //圈子名称
@property (copy, nonatomic) NSString *circle_describe;            //圈子描述
@property (copy, nonatomic) NSString *circle_cover_img;            //圈子封面
@property (copy, nonatomic) NSString *circle_background_img;            //圈子背景
@property (copy, nonatomic) NSString *status;            //是否可用
@property (copy, nonatomic) NSString *follow;            //关注人数
@property (copy, nonatomic) NSString *circilenums;
@property (copy, nonatomic) NSString *ctime;            //建立时间
@property (copy, nonatomic) NSString *utime;
@property (copy, nonatomic) NSString *dismiss;
@property (copy, nonatomic) NSString *dismiss_time;
@property (copy, nonatomic) NSString *myfollow;
@property (copy, nonatomic) NSString *ismy;
@property (copy, nonatomic) NSString *mycirclepower;
@property (copy, nonatomic) NSString *founded;
@property (copy, nonatomic) NSString *is_recom;

@property (copy, nonatomic) NSDictionary *userMsg;            //用户信息
@property (copy, nonatomic) NSDictionary *userdetail;            //用户信息
@property (copy, nonatomic) NSString *gender;            //性别
@property (copy, nonatomic) NSString *user_id;            //用户id
@property (copy, nonatomic) NSString *nickname;            //用户昵称
@property (copy, nonatomic) NSString *avatar;            //用户头像

@property (assign, nonatomic) BOOL isHiddenTop;            //用户头像
@end

NS_ASSUME_NONNULL_END

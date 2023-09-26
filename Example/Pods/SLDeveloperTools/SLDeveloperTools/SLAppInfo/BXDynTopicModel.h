//
//  BXDynTopicModel.h
//  BXlive
//
//  Created by mac on 2020/7/28.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynTopicModel : BaseObject
@property(nonatomic, strong)NSMutableArray *hotTopic;
@property(nonatomic, strong)NSString *topic_id;
@property(nonatomic, strong)NSString *uid;
@property(nonatomic, strong)NSString *img;
@property(nonatomic, strong)NSString *topic_name;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)NSString *is_recom;
@property(nonatomic, strong)NSString *hot;
@property(nonatomic, strong)NSString *ctime;
@property(nonatomic, strong)NSString *myfollowed;
@property(nonatomic, strong)NSString *dynamic;

@property (copy, nonatomic) NSDictionary *usermsg;            //用户信息
@property (copy, nonatomic) NSString *gender;            //性别
@property (copy, nonatomic) NSString *user_id;            //用户id
@property (copy, nonatomic) NSString *nickname;            //用户昵称
@property (copy, nonatomic) NSString *avatar;            //用户头像

@property(nonatomic, strong)NSMutableArray *xinTopic;
//@property(nonatomic, strong)NSString *new_topic_id;
//@property(nonatomic, strong)NSString *new_uid;
//@property(nonatomic, strong)NSString *new_topic_name;
//@property(nonatomic, strong)NSString *new_status;
//@property(nonatomic, strong)NSString *new_is_recom;
//@property(nonatomic, strong)NSString *new_hot;
//@property(nonatomic, strong)NSString *new_ctime;

@property(nonatomic, strong)NSMutableArray *recommendTopic;
@property(nonatomic, strong)NSString *recommend_topic_id;
@property(nonatomic, strong)NSString *recommend_uid;
@property(nonatomic, strong)NSString *recommend_topic_name;
@property(nonatomic, strong)NSString *recommend_status;
@property(nonatomic, strong)NSString *recommend_is_recom;
@property(nonatomic, strong)NSString *recommend_hot;
@property(nonatomic, strong)NSString *recommend_ctime;
@property(nonatomic, strong)NSString *is_local_img;
@end

NS_ASSUME_NONNULL_END

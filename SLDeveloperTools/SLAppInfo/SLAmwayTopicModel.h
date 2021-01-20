//
//  SLAmwayTopicModel.h
//  BXlive
//
//  Created by sweetloser on 2020/11/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLAmwayTopicModel : BaseObject
@property(nonatomic,copy)NSString *topic_dis;
@property(nonatomic,copy)NSNumber *uid;
@property(nonatomic,copy)NSString *topic_name;
@property(nonatomic,copy)NSNumber *topic_id;
@property(nonatomic,copy)NSNumber *tag_id;
@property(nonatomic,copy)NSNumber *hot; //热度
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSNumber *is_recom;
@property(nonatomic,copy)NSNumber *ctime;
@property(nonatomic,copy)NSNumber *sort;
@property(nonatomic,copy)NSNumber *status;
@property(nonatomic,copy)NSNumber *is_hot;

//{
//topic_dis : fsdf,
//uid : 0,
//topic_name : 后台话题测试02,
//topic_id : 34,
//tag_id : 5,
//hot : 0,
//img : https://static.cnibx.cn/upload/common/images/20201104/20201104063438160448607857068.png,
//is_recom : 0,
//ctime : 1604486089,
//sort : 2,
//status : 1,
//is_hot : 0
//}

@end

NS_ASSUME_NONNULL_END

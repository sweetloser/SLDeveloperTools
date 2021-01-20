//
//  SLAmwayListModel.h
//  BXlive
//
//  Created by sweetloser on 2020/11/5.
//  Copyright © 2020 cat. All rights reserved.
//

#import <SLDeveloperTools/SLDeveloperTools.h>
#import "BXMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLAmwayPublicUser : BaseObject

@property(nonatomic,strong)NSNumber *user_id;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *follow_num;
@property(nonatomic,strong)NSString *avatar;

@end
/*
 address : ,
 privateid : ,
 location : (null),(null),
 title : ,
 create_time : 1605859247,
 imgs_detail : [
],
 picture : [
],
 extend_talk : 5,
 video : http://1254828333.vod2.myqcloud.com/f3261f69vodcq1254828333/dfad372c5285890810150355886/q6jaxWhLa3EA.mp4,
 systemplus : [
],
 render_type : 7,
 type : 2,
 comment_num : 0,
 id : 105,
 dynamic_title : ,
 user : {
 user_id : 10004140,
 nickname : 烬,
 follow_num : 17,
 avatar : https://static.cnibx.cn/bingxin/user/10004140/avatar/66e2533cc5a49a1ecc7fef0f76040ab5eb152d58.png
},
 uid : 10004140,
 livemsg : {
},
 is_recommend : 0,
 mylive : 0,
 privatemsg : [
],
 smallpicture : [
],
 cover_url : http://1254828333.vod2.myqcloud.com/f3261f69vodcq1254828333/dfad372c5285890810150355886/5285890810150355887.jpg,
 content : ,
 like_num : 0
}
 */

@interface SLAmwayListModel : BaseObject

@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *privateid;
@property(nonatomic,strong)NSArray *privatemsg;
@property(nonatomic,strong)NSString *location;
@property(nonatomic,strong)NSArray *title;
@property(nonatomic,strong)NSNumber *create_time;
@property(nonatomic,strong)NSArray *imgs_detail;
@property(nonatomic,strong)NSArray *picture;
@property(nonatomic,strong)NSNumber *extend_talk;
@property(nonatomic,strong)NSString *video;
@property(nonatomic,strong)NSArray *systemplus;
@property(nonatomic,strong)NSNumber *render_type;
@property(nonatomic,strong)NSNumber *type;
@property(nonatomic,strong)NSNumber *comment_num;
@property(nonatomic,strong)NSNumber *list_id;
@property(nonatomic,strong)NSString *dynamic_title;
@property(nonatomic,strong)SLAmwayPublicUser *user;
@property(nonatomic,strong)NSNumber *uid;
@property(nonatomic,strong)NSNumber *is_recommend;
@property(nonatomic,strong)NSString *cover_url;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSNumber *like_num;
@property(nonatomic,strong)NSNumber *is_follow;
@property(nonatomic,strong)NSNumber *mylive;
@property(nonatomic,strong)BXMusicModel *voice_msg;
@end

NS_ASSUME_NONNULL_END

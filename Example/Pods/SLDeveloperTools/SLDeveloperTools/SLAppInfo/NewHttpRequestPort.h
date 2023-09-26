//
//  NewHttpRequestPort.h
//  BXlive
//
//  Created by bxlive on 2017/11/30.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLMacro.h"

@interface NewHttpRequestPort : NSObject

DEFINE_SINGLETON_FOR_HEADER(NewHttpRequestPort)

/**
 获取用户上传至腾讯云存储服务的授权签名
 @param success 成功
 @param failure 失败
 */
-(void)UploadByQcloud:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 视频点赞
 @param success 成功
 @param failure 失败
 */
-(void)Filmsupport:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 关注他人
 @param success 成功
 @param failure 失败
 */
-(void)Followfollow:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 缓存统计
 @param success 成功
 @param failure 失败
 */
-(void)FilmDownFilm:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 获取举报
 @param success 成功
 @param failure 失败
 */
-(void)FeedbackreportList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;
/**
 举报
 @param success 成功
 @param failure 失败
 */
-(void)Feedbackreport:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 视频删除
 @param success 成功
 @param failure 失败
 */
-(void)FilmdelOwnFilm:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 获取个人消息列表
 @param success 成功
 @param failure 失败
 */
-(void)MessageGetList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 清空消息列表
 @param success 成功
 @param failure 失败
 */
-(void)MessageClearUnread:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 获取分享内容
 @param success 成功
 @param failure 失败
 */
-(void)shareGetParams:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 上传分享结果
 @param success 成功
 @param failure 失败
 */
-(void)shareShareResult:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;
/**
 意见反馈
 @param success 成功
 @param failure 失败
 */
-(void)FeedbackViewBack:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 邀请好友
 @param success 成功
 @param failure 失败
 */
-(void)InviteGetList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 第三方登录
 @param success 成功
 @param failure 失败
 */
-(void)AccountLoginByThird:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;


-(void)SLVipRechargeappleCreate:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 apple 支付
 @param success 成功
 @param failure 失败
 */
-(void)RechargeappleCreate:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 apple 充值列表
 @param success 成功
 @param failure 失败
 */
-(void)RechargeGetOrders:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 pk 好友列表
 @param success 成功
 @param failure 失败
 */
-(void)PkfriendsList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;
/**
 选中产品下单
 @param success 成功
 @param failure 失败
 */
-(void)UserselectProduct:(NSString *)orderId type:(NSString *)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 pk - 参数选项
 @param success 成功
 @param failure 失败
 */
-(void)PkdefaultPkOption:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;



/**
 获取话题界面
 @param success 成功
 @param failure 失败
 */
-(void)TopicGetTopic:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 关注页面_好友列表
 @param success 成功
 @param failure 失败
 */
-(void)FollowCurrentFollow:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 关注界面_推荐关注
 @param success 成功
 @param failure 失败
 */
-(void)getFollowRecommendList:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;
/**
 关注界面_关注
 @param success 成功
 @param failure 失败
 */
-(void)FollowNewPublish:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;


/**
 关注界面_好友
 @param success 成功
 @param failure 失败
 */
-(void)FriendsnewPublish:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 视频添加好友，好友列表
 @param success 成功
 @param failure 失败
 */
-(void)FriendsGetFriends:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;



/**
 视频添加好友，好友搜索
 @param success 成功
 @param failure 失败
 */
-(void)FriendsSearch:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 获取个人收藏
 @param success 成功
 @param failure 失败
 */
-(void)CollectionOwnList:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 获取历史l观看
 @param success 成功
 @param failure 失败
 */
-(void)FilmPlayHistory:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;


/**
 阅读消息
 @param success 成功
 @param failure 失败
 */
-(void)MessageRead:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 获取未读消息总数
 @param success 成功
 @param failure 失败
 */
-(void)MessageGetUnreadTotal:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 搜索榜单
 @param success 成功
 @param failure 失败
 */
-(void)SearchRankList:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//视频打赏礼物资源(新版)
-(void)VideoGetRewardGift:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//打赏发布者
-(void)VideoGiveReward:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//520甜蜜大作战
-(void)Activityentry:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//相册列表
-(void)UserAlbumGetList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//保存相册
-(void)UserAlbumSave:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//删除相册
-(void)UserAlbumDelete:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//主播印象列表数据
-(void)RoomImpression:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//保存对主播的印象
-(void)RoomSaveImpression:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//主播端活跃用户
-(void)RoomGetLiveActiveUser:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//连麦管理列表
-(void)RoomGetLinkMicList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//连麦申请列表
-(void)RoomGetLinkReplyList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//口令菜单
-(void)RedPacketWordMenu:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//口令列表
-(void)RedPacketWordList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//消费明细
-(void)MilletConsumerDetails:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;


//创建充值订单
-(void)RechargeCreate:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;
//统一下单
-(void)ThirdOrderUnifiedorder:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

//vip 购买
-(void)Vipbuy:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**购买成功
 @param success 成功
 @param failure 失败
 */
-(void)RechargeIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;



@end

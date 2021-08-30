//
//  NewHttpRequestPort.m
//  BXlive
//
//  Created by bxlive on 2017/11/30.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "NewHttpRequestPort.h"
#import "NewHttpManager.h"
#import "../SLMacro/SLMacro.h"
@implementation NewHttpRequestPort
DEFINE_SINGLETON_FOR_CLASS(NewHttpRequestPort)

/**
 获取用户上传至腾讯云存储服务的授权签名
 @param success 成功
 @param failure 失败
 */
-(void)UploadByQcloud:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Common.getQcludSign" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 视频点赞
 @param success 成功
 @param failure 失败
 */
-(void)Filmsupport:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Video.support" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 关注他人
 @param success 成功
 @param failure 失败
 */
-(void)Followfollow:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Follow.follow" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 缓存统计
 @param success 成功
 @param failure 失败
 */
-(void)FilmDownFilm:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Video.download" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 获取举报
 @param success 成功
 @param failure 失败
 */
-(void)FeedbackreportList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Feedback.reportList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 举报
 @param success 成功
 @param failure 失败
 */
-(void)Feedbackreport:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Feedback.complaint" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 视频删除
 @param success 成功
 @param failure 失败
 */
-(void)FilmdelOwnFilm:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Video.delOwnFilm" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 获取个人消息列表
 @param success 成功
 @param failure 失败
 */
-(void)MessageGetList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Message.getList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 清空消息列表
 @param success 成功
 @param failure 失败
 */
-(void)MessageClearUnread:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Message.clearUnread" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 获取分享内容
 @param success 成功
 @param failure 失败
 */
-(void)shareGetParams:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    NSLog(@"a");
    [[NewHttpManager sharedNetManager] POST:@"s=Share.getParams" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 上传分享结果
 @param success 成功
 @param failure 失败
 */
-(void)shareShareResult:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Share.shareResult" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 意见反馈
 @param success 成功
 @param failure 失败
 */
-(void)FeedbackViewBack:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Feedback.viewBack" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 邀请好友
 @param success 成功
 @param failure 失败
 */
-(void)InviteGetList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Invite.getList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 第三方登录
 @param success 成功
 @param failure 失败
 */
-(void)AccountLoginByThird:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Account.loginByThird" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//apple 支付   会员订单
-(void)SLVipRechargeappleCreate:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Vip.appleCreate" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 apple 支付
 @param success 成功
 @param failure 失败
 */
-(void)RechargeappleCreate:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Recharge.appleCreate" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 apple 充值列表
 @param success 成功
 @param failure 失败
 */
-(void)RechargeGetOrders:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Recharge.getOrders" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 pk 好友列表
 @param success 成功
 @param failure 失败
 */
-(void)PkfriendsList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Pk.friendsList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 选中产品下单
 @param success 成功
 @param failure 失败
 */
-(void)UserselectProduct:(NSString *)orderId type:(NSString *)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    NSDictionary *dict = @{@"id":[self stringNoNil:orderId],@"type":[self stringNoNil:type]};
    [[NewHttpManager sharedNetManager] POST:@"s=User.selectProduct" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 pk - 参数选项
 @param success 成功
 @param failure 失败
 */
-(void)PkdefaultPkOption:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Pk.defaultPkOption" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 获取话题界面
 @param success 成功
 @param failure 失败
 */
-(void)TopicGetTopic:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Topic.getTopic" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 关注页面_好友列表
 @param success 成功
 @param failure 失败
 */
-(void)FollowCurrentFollow:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Follow.currentFollow" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 关注界面_推荐关注
 @param success 成功
 @param failure 失败
 */
-(void)getFollowRecommendList:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Follow.recommend" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 关注界面_关注
 @param success 成功
 @param failure 失败
 */
-(void)FollowNewPublish:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Follow.dynamics" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 关注界面_好友
 @param success 成功
 @param failure 失败
 */
-(void)FriendsnewPublish:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.dynamics" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 视频添加好友，好友列表
 @param success 成功
 @param failure 失败
 */
-(void)FriendsGetFriends:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.getFriends" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 视频添加好友，好友搜索
 @param success 成功
 @param failure 失败
 */
-(void)FriendsSearch:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.search" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 获取个人收藏
 @param success 成功
 @param failure 失败
 */
-(void)CollectionOwnList:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Collection.ownList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 获取历史l观看
 @param success 成功
 @param failure 失败
 */
-(void)FilmPlayHistory:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Video.playHistory" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 阅读消息
 @param success 成功
 @param failure 失败
 */
-(void)MessageRead:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Message.read" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 获取未读消息总数
 @param success 成功
 @param failure 失败
 */
-(void)MessageGetUnreadTotal:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Message.getUnreadTotal" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 搜索榜单
 @param success 成功
 @param failure 失败
 */
-(void)SearchRankList:(NSDictionary *)dict  Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Search.rankList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//视频打赏礼物资源(新版)
-(void)VideoGetRewardGift:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Video.getRewardGift" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//打赏发布者
-(void)VideoGiveReward:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Video.giveReward" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
//520甜蜜大作战
-(void)Activityentry:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Activity.entry" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
//相册列表
-(void)UserAlbumGetList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=UserAlbum.getList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//保存相册
-(void)UserAlbumSave:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=UserAlbum.save" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//删除相册
-(void)UserAlbumDelete:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=UserAlbum.delete" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
//主播印象列表数据
-(void)RoomImpression:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Room.impression&api_v=v2" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//保存对主播的印象
-(void)RoomSaveImpression:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Room.saveImpression&api_v=v2" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//主播端活跃用户
-(void)RoomGetLiveActiveUser:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Room.getLiveActiveUser" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//连麦管理列表
-(void)RoomGetLinkMicList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Room.getLinkMicList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//连麦申请列表
-(void)RoomGetLinkReplyList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Room.getLinkReplyList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//口令菜单
-(void)RedPacketWordMenu:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=RedPacket.wordMenu" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//口令列表
-(void)RedPacketWordList:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=RedPacket.wordList" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//消费明细
-(void)MilletConsumerDetails:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Millet.consumerDetails" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//创建充值订单
-(void)RechargeCreate:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Recharge.create" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//统一下单
-(void)ThirdOrderUnifiedorder:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=ThirdOrder.unifiedorder" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
//vip 购买
-(void)Vipbuy:(NSDictionary *)dict Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Vip.buy" parameters:dict success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**购买成功
 @param success 成功
 @param failure 失败
 */
-(void)RechargeIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    
    [[NewHttpManager sharedNetManager] POST:@"s=Recharge.index" parameters:@{@"os":@"android"} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}



- (NSString *)stringNoNil:(NSString *)str {
    if (str) {
        return str;
    } else {
        return @"";
    }
}

@end

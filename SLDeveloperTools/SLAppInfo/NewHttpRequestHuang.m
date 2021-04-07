//
//  NewHttpRequestHuang.m
//  BXlive
//
//  Created by huang on 2017/12/21.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "NewHttpRequestHuang.h"
#import "NewHttpManager.h"
@implementation NewHttpRequestHuang
DEFINE_SINGLETON_FOR_CLASS(NewHttpRequestHuang)

/**
 * 收藏
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmCollectionWithPage:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.Collection" parameters:@{@"p":p} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 最新作品
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmNewFilmWithPage:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.NewFilm" parameters:@{@"p":p} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 小电影收藏
 * id : 小电影 ID
 @param success 成功
 @param failure 失败
 */
-(void)appFilmSubCollectionWithMovieId:(NSString *)movieId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.SubCollection" parameters:@{@"id":movieId} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 小电影评论列表
 * id:  小电影id
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmCommentWithMovieID:(NSString *)movieID Page:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.Comment" parameters:@{@"id":movieID,@"p":p} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 小电影评论
 * id:  小电影id
 * content: 内容
 * parent_id:  评论的id
 @param success 成功
 @param failure 失败
 */
-(void)appFilmSubCommentWithMovieID:(NSString *)movieID Province:(NSString *)province City:(NSString *)city content:(NSString *)content parentID:(NSString *)parentID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.SubComment" parameters:@{@"id":movieID,@"province":province,@"city":city,@"content":content,@"parent_id":parentID} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 我的小电影
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmOwnFilmWithPage:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.OwnFilm" parameters:@{@"p":p} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 他人的小电影
 * userId: 他人的 id
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmOthersFilmWithUserId:(NSString *)userId Page:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.OthersFilm" parameters:@{@"user_id":userId,@"p":p} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 删除我的小电影
 * id:影片的ID
 @param success 成功
 @param failure 失败
 */
-(void)appFilmDelFilmWithID:(NSString *)movieID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.DelFilm" parameters:@{@"id":movieID} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 评论点赞
 * id : 评论ID
 @param success 成功
 @param failure 失败
 */
-(void)appFilmZanCommentWithCommentId:(NSString *)commentId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.ZanComment" parameters:@{@"id":commentId} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 统计播放次数
 * id : 小电影 ID
 @param success 成功
 @param failure 失败
 */
-(void)appFilmPlaySumWithMovieId:(NSString *)movieId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.PlaySum" parameters:@{@"id":movieId} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 小电影频道列表
 * p : 分页
 * channel : 分类频道
 * type : 0推荐 1收费
 @param success 成功
 @param failure 失败
 */
-(void)appFilmChannelListWithPage:(NSString *)page Channel:(NSString *)channel Type:(NSString *)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=App.Video.ChannelLists" parameters:@{@"p":page,@"channel":channel,@"type":type} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/**
 * 用户基础信息
 @param success 成功
 @param failure 失败
 */
-(void)userGetUserInfoWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=User.getUserInfo" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取地区列表
 @param success 成功
 @param failure 失败
 */
-(void)CommonGetRegionTreeWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Common.getRegionTree" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 保存用户资料
 * nickname 昵称
 * gender 性别
 * birthday 出生日期
 * province_id 省ID
 * city_id 市ID
 * district_id 区ID
 * sign 签名
 * fields 要保存的字段名字（例如修改昵称传 nickname）
 @param success 成功
 @param failure 失败
 */
-(void)userSaveInfoWithNickName:(NSString *)nickname Gender:(NSString *)gender Birthday:(NSString *)birthday Province_id:(NSString *)province_id City_id:(NSString *)city_id District_id:(NSString *)district_id Sign:(NSString *)sign Fields:(NSString *)fields Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=User.saveInfo" parameters:@{@"nickname":nickname,@"gender":gender,@"birthday":birthday,@"province_id":province_id,@"city_id":city_id,@"district_id":district_id,@"sign":sign,@"fields":fields} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 保存用户头像
 * avatar : 头像地址
 @param success 成功
 @param failure 失败
 */
-(void)UserSaveAvatarWithAvatar:(NSString *)avatar Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=User.saveAvatar" parameters:@{@"avatar":avatar} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 保存用户封面
 * cover : 封面地址
 @param success 成功
 @param failure 失败
 */
-(void)UserSaveCoverWithCover:(NSString *)cover Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=User.saveCover" parameters:@{@"cover":cover} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 收藏列表
 * p : 分页
 @param success 成功
 @param failure 失败
 */
-(void)CollectionCollectionListWithPage:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Collection.collectionList" parameters:@{@"p":p} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 删除缓存列表
 * params : 目标数组
 @param success 成功
 @param failure 失败
 */
-(void)FilmClearDownRecordWithParams:(NSString *)params Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Video.clearDownRecord" parameters:@{@"params":params} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)CommssionIndexWithSuccess:(void (^)(id))success Failure:(void (^)(NSError *))failure{
    [[NewHttpManager sharedNetManager] DomainNamePOST:@"giftdistribute/with_draw/index" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)CommssionLogsWithOffset:(NSString *)offset Trade_type:(NSString *)trade_type length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] DomainNamePOST:@"giftdistribute/with_draw/logs" parameters:@{@"offset":offset,@"trade_type":trade_type,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 * 获取收益首页数据
 @param success 成功
 @param failure 失败
 */
-(void)MilletIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Millet.index" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 收益记录
 * offset: 默认列表
 * trade_type: live直播收益 film视频收益 other其他收益
 @param success 成功
 @param failure 失败
 */
-(void)MilletLogsWithOffset:(NSString *)offset Trade_type:(NSString *)trade_type length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Millet.logs" parameters:@{@"offset":offset,@"trade_type":trade_type,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 切换设置状态
 * name : 设置项名称
 * value : 设置值
 @param success 成功
 @param failure 失败
 */
-(void)UserSwitchStatusWithName:(NSString *)name Value:(NSString *)value Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=User.switchStatus" parameters:@{@"name":name,@"value":value} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取会员中心
 @param success 成功
 @param failure 失败
 */
-(void)VipIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Vip.index" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 开通VIP
 * id : vip的id
 @param success 成功
 @param failure 失败
 */
-(void)VipByWithvipId:(NSString *)vipId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Vip.buu" parameters:@{@"id":vipId} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * VIP购买记录
 * offset : 默认列表
 @param success 成功
 @param failure 失败
 */
-(void)VipOrderWithOffset:(NSString *)offset Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Vip.order" parameters:@{@"offset":offset} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取黑名单列表
 * offset : 默认列表
 @param success 成功
 @param failure 失败
 */
-(void)BlacklistIndexWithOffset:(NSString *)offset Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Blacklist.index" parameters:@{@"offset":offset} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 移除黑名单
 @param success 成功
 @param failure 失败
 */
-(void)BlacklistDeleteWithUserId:(NSString *)userId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Blacklist.delete" parameters:@{@"user_id":userId} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 @param success 成功
 @param failure 失败
 */
-(void)RechargeIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    //上线改
    [[NewHttpManager sharedNetManager] POST:@"s=Recharge.index" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
//签名版
-(void)RechargeSignIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    //
    [[NewHttpManager sharedNetManager] POST:@"s=Recharge.index_sign" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 邀请好友
 * anchor : id
 @param success 成功
 @param failure 失败
 */
-(void)InviteGenerateWithAnchor:(NSString *)anchor Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Invite.generate" parameters:@{@"anchor":anchor} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取子评论列表
 * id:父评论id
 @param success 成功
 @param failure 失败
 */
-(void)CommentGetSubCommentListWithCommentID:(NSString *)commentID last_id:(NSString *)last_id Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Comment.getSubCommentList" parameters:@{@"id":commentID,@"last_id":last_id} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 座驾列表
 @param success 成功
 @param failure 失败
 */
-(void)PropsGetPropsListWithPage:(NSString *)page Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Props.getPropsList" parameters:@{@"p":page} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 购买座驾
 * id
 @param success 成功
 @param failure 失败
 */
-(void)PropsPayPropsListWithItemID:(NSString *)itemID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Props.payProps" parameters:@{@"id":itemID} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 我的座驾
 @param success 成功
 @param failure 失败
 */
-(void)PropsGetUserPropsListWithuser_id:(NSString *)user_id
                                Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    if (IsNilString(user_id)) {
        user_id = @"";
    }
    [[NewHttpManager sharedNetManager] POST:@"s=Props.getUserProps" parameters:@{@"user_id": user_id} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 使用座驾
 * id
 @param success 成功
 @param failure 失败
 */
-(void)PropsUsePropsListWithItemID:(NSString *)itemID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Props.useProps" parameters:@{@"id":itemID} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 直播首页轮播图
 @param success 成功
 @param failure 失败
 */
-(void)SliderGetSliderWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Slider.getSlider" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 直播首页轮播图和新闻头条
 @param success 成功
 @param failure 失败
 */
-(void)SliderGetSliderArtWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Slider.getSliderArt&api_v=v2" parameters:@{@"api_v":@"v2"} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取电影预告信息
 @param success 成功
 @param failure 失败
 */
-(void)FilmTrailerGetNoticeWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=FilmTrailer.getNotice" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取电影预告时间轴
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)FilmTrailerGetTimeLineWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=FilmTrailer.getTimeLine" parameters:@{@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取他人已发视频
 * user_id: 用户id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)FilmOtherPublishFilmWithUserID:(NSString *)userID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Video.otherPublishFilm" parameters:@{@"user_id":userID,@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取用户动态
 * user_id: 用户id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)UserGetUserDynamicWithUserID:(NSString *)userID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=User.getUserDynamic" parameters:@{@"user_id":userID,@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取个人作品
 * user_id: 用户id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)PersonalGetUserVideoWithUserID:(NSString *)userID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Personal.getUserVideo" parameters:@{@"user_id":userID,@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 点赞过的视频
 * user_id: 用户id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)PersonalGetLikeListWithUserID:(NSString *)userID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Personal.getLikeList" parameters:@{@"user_id":userID,@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 音乐广告轮播图
 @param success 成功
 @param failure 失败
 */
-(void)MusicSliderAdWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure
{
    [[NewHttpManager sharedNetManager] POST:@"s=Music.sliderAd" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 推荐音乐
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)MusicRecommendWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Music.recommend" parameters:@{@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 音乐分类菜单
 @param success 成功
 @param failure 失败
 */
-(void)MusicCategoryListWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Music.categoryList" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 音乐分类菜单下具体作品
 * category_id: 音乐类别id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)MusicMusicsByCategoryListWithCategoryId:(NSString *)categoryId Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Music.musicsByCategory" parameters:@{@"category_id":categoryId,@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 音乐主页列表数据
 @param success 成功
 @param failure 失败
 */
-(void)MusicHomeWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Music.home" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 音乐搜索
 * offset: 默认列表
 * length: 每页多少条
 * words
 @param success 成功
 @param failure 失败
 */
-(void)MusicSearchWithWords:(NSString *)words Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Music.search" parameters:@{@"words":words,@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 回复消息
 * id: 消息id
 * type: 消息类型
 * content: 回复内容
 @param success 成功
 @param failure 失败
 */
-(void)MessageReplyMsgWithMessageID:(NSString *)messageID type:(NSString *)type content:(NSString *)content Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Message.replyMsg" parameters:@{@"id":messageID,@"type":type,@"content":content} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 一级评论
 * video_id: 视频id
 * last_id: 最后一条评论id，默认为0
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)CommentCommentListWithVideoID:(NSString *)video_id topCommentId:(NSString *)topCommentId LastID:(NSString *)lastID Offset:(NSString *)offset length:(NSString *)length Success:(void (^)(id))success Failure:(void (^)(NSError *))failure{
    if (!topCommentId) {
        topCommentId = @"";
    }
    [[NewHttpManager sharedNetManager] POST:@"s=Comment.commentList" parameters:@{@"video_id":video_id,@"selected_id":topCommentId,@"last_id":lastID,@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取子评论
 *
 * video_id: 视频id
 * comment_id: 父评论id
 * last_id: 最后一条评论id，默认为0
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)CommentSubCommentListWithVideoID:(NSString *)video_id CommentID:(NSString *)commentID topCommentId:(NSString *)topCommentId LastID:(NSString *)lastID Offset:(NSString *)offset length:(NSString *)length Success:(void (^)(id))success Failure:(void (^)(NSError *))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Comment.subCommentList" parameters:@{@"video_id":video_id,@"comment_id":commentID,@"top_comment_id":topCommentId,@"last_id":lastID,@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 删除评论
 * id : 评论id
 @param success 成功
 @param failure 失败
 */
-(void)CommentDeleteWithCommentID:(NSString *)comment Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Comment.delete" parameters:@{@"comment_id":comment} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 评论点赞
 * comment_id : 评论id
 @param success 成功
 @param failure 失败
 */
-(void)CommentLikeWithCommentID:(NSString *)commentID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Comment.like" parameters:@{@"comment_id":commentID} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 发表评论
 * video_id : 视频id
 * content :  内容
 * reply_id : 父评论id
 * friends : @好友
 @param success 成功
 @param failure 失败
 */
-(void)CommentCommentWithVideoID:(NSString *)videoID Comment:(NSString *)comment ReplyID:(NSString *)replyID Friends:(NSString *)friends Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Comment.comment" parameters:@{@"video_id":videoID,@"content":comment,@"reply_id":replyID,@"friends":friends} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 直播K歌列表
 @param success 成功
 @param failure 失败
 */
-(void)RoomMusicHomeWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Room.musicHome" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 上报使用的音乐
 @param success 成功
 @param failure 失败
 */
-(void)MusicReportUseMusicWithMusicID:(NSString *)musicID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Music.reportUseMusic" parameters:@{@"music_id":musicID} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 已使用过的音乐
 @param success 成功
 @param failure 失败
 */
-(void)MusicUseMusicListWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Music.useMusicList" parameters:@{@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 直播列表获取二级导航栏
 * id 一级导航栏频道id
 * nav_type 一级导航栏类型
 @param success 成功
 @param failure 失败
 */
-(void)RoomGetNavTreeWithChannelId:(NSString *)channelId NavType:(NSString *)nav_type Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Room.getNavTree&api_v=v2&version=new" parameters:@{@"id":channelId,@"nav_type":nav_type} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取好友列表
 @param success 成功
 @param failure 失败
 */
- (void)FriendsGetFriendsListWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.getFriendsList" parameters:@{@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 发现好友(推荐)
 @param success 成功
 @param failure 失败
 */
- (void)FriendsRecommendWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.recommend" parameters:@{@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)FriendSearchWithkeyword:(NSString *)keyword
                        offset:(NSString *)offset
                        length:(NSString *)length
                       Success:(void (^)(id))success
                       Failure:(void (^)(NSError *))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=User.searchUser" parameters:@{@"keyword":keyword,@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 上传通讯录
 * data: 本地通讯录Json字符串
 @param success 成功
 @param failure 失败
 */
- (void)FriendsAddbooksWithData:(NSString *)data Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.addbooks" parameters:@{@"data":data} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 获取通讯录好友
 @param success 成功
 @param failure 失败
 */
- (void)FriendsBookslistWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.bookslist" parameters:@{@"offset":offset,@"length":length} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 移除推荐
 * addBook_id: 通讯录id
 @param success 成功
 @param failure 失败
 */
- (void)FriendsUnrecommendWithAddBookID:(NSString *)addBook_id Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.unrecommend" parameters:@{@"id":addBook_id} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 好友口令
 * friend : 要生成口令的id
 @param success 成功
 @param failure 失败
 */
- (void)FriendsGetfriendcodeWithFriend:(NSString *)friendID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.getfriendcode" parameters:@{@"friend":friendID} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 解析口令
 * codestr: 口令
 @param success 成功
 @param failure 失败
 */
- (void)FriendsFriendcodetoWithCodesStr:(NSString *)codestr Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.friendcodeto" parameters:@{@"codestr":codestr} success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 * 码
 @param success 成功
 @param failure 失败
 */
- (void)FriendsGenerateWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Friends.generate" parameters:nil success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

@end

//
//  NewHttpRequestHuang.h
//  BXlive
//
//  Created by huang on 2017/12/21.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLMacro.h"

@interface NewHttpRequestHuang : NSObject

DEFINE_SINGLETON_FOR_HEADER(NewHttpRequestHuang)

/**
 * 收藏列表
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmCollectionWithPage:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 最新作品
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmNewFilmWithPage:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 小电影收藏
 * id : 小电影 ID
 @param success 成功
 @param failure 失败
 */
-(void)appFilmSubCollectionWithMovieId:(NSString *)movieId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 小电影评论列表
 * id:  小电影id
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmCommentWithMovieID:(NSString *)movieID Page:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 小电影评论
 * id:  小电影id
 * content: 内容
 * parent_id:  评论的id
 @param success 成功
 @param failure 失败
 */
-(void)appFilmSubCommentWithMovieID:(NSString *)movieID Province:(NSString *)province City:(NSString *)city content:(NSString *)content parentID:(NSString *)parentID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 我的小电影
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmOwnFilmWithPage:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 他人的小电影
 * userId: 他人的 id
 * p: 页数
 @param success 成功
 @param failure 失败
 */
-(void)appFilmOthersFilmWithUserId:(NSString *)userId Page:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 删除我的小电影
 * id:影片的ID
 @param success 成功
 @param failure 失败
 */
-(void)appFilmDelFilmWithID:(NSString *)movieID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 评论点赞
 * id : 评论ID
 @param success 成功
 @param failure 失败
 */
-(void)appFilmZanCommentWithCommentId:(NSString *)commentId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 统计播放次数
 * id : 小电影 ID
 @param success 成功
 @param failure 失败
 */
-(void)appFilmPlaySumWithMovieId:(NSString *)movieId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 小电影频道列表
 * p : 分页
 * channel : 分类频道
 * type : 0推荐 1收费
 @param success 成功
 @param failure 失败
 */
-(void)appFilmChannelListWithPage:(NSString *)page Channel:(NSString *)channel Type:(NSString *)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;


/**
 * 用户基础信息
 @param success 成功
 @param failure 失败
 */
-(void)userGetUserInfoWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取地区列表
 @param success 成功
 @param failure 失败
 */
-(void)CommonGetRegionTreeWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

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
-(void)userSaveInfoWithNickName:(NSString *)nickname Gender:(NSString *)gender Birthday:(NSString *)birthday Province_id:(NSString *)province_id City_id:(NSString *)city_id District_id:(NSString *)district_id Sign:(NSString *)sign Fields:(NSString *)fields Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 保存用户头像
 * avatar : 头像地址
 @param success 成功
 @param failure 失败
 */
-(void)UserSaveAvatarWithAvatar:(NSString *)avatar Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 保存用户封面
 * cover : 封面地址
 @param success 成功
 @param failure 失败
 */
-(void)UserSaveCoverWithCover:(NSString *)cover Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 删除缓存列表
 * params : 目标数组
 @param success 成功
 @param failure 失败
 */
-(void)FilmClearDownRecordWithParams:(NSString *)params Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 收藏列表
 * p : 分页数
 @param success 成功
 @param failure 失败
 */
-(void)CollectionCollectionListWithPage:(NSString *)p Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;


-(void)CommssionIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

-(void)CommssionLogsWithOffset:(NSString *)offset Trade_type:(NSString *)trade_type length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取收益首页数据
 @param success 成功
 @param failure 失败
 */
-(void)MilletIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 收益记录
 * offset: 默认列表
 * trade_type: live直播收益 film视频收益 other其他收益
 * length: 一页多少条数据
 @param success 成功
 @param failure 失败
 */
-(void)MilletLogsWithOffset:(NSString *)offset Trade_type:(NSString *)trade_type length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 切换设置状态
 * name : 设置项名称
 * value : 设置值
 @param success 成功
 @param failure 失败
 */
-(void)UserSwitchStatusWithName:(NSString *)name Value:(NSString *)value Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取会员中心
 @param success 成功
 @param failure 失败
 */
-(void)VipIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 开通VIP
 * id : vip的id
 @param success 成功
 @param failure 失败
 */
-(void)VipByWithvipId:(NSString *)vipId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * VIP购买记录
 * offset : 默认列表
 @param success 成功
 @param failure 失败
 */
-(void)VipOrderWithOffset:(NSString *)offset Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取黑名单列表
 * offset : 默认列表
 @param success 成功
 @param failure 失败
 */
-(void)BlacklistIndexWithOffset:(NSString *)offset Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 移除黑名单
 @param success 成功
 @param failure 失败
 */
-(void)BlacklistDeleteWithUserId:(NSString *)userId Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 @param success 成功
 @param failure 失败
 */
-(void)RechargeIndexWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 邀请好友
 * anchor : id
 @param success 成功
 @param failure 失败
 */
-(void)InviteGenerateWithAnchor:(NSString *)anchor Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取子评论列表
 * id:父评论id
 @param success 成功
 @param failure 失败
 */
-(void)CommentGetSubCommentListWithCommentID:(NSString *)commentID last_id:(NSString *)last_id Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 座驾列表
 @param success 成功
 @param failure 失败
 */
-(void)PropsGetPropsListWithPage:(NSString *)page Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 购买座驾
 * id
 @param success 成功
 @param failure 失败
 */
-(void)PropsPayPropsListWithItemID:(NSString *)itemID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 我的座驾
 @param success 成功
 @param failure 失败
 */
-(void)PropsGetUserPropsListWithuser_id:(NSString *)user_id
                                Success:(void(^)(id responseObject))success
                                Failure:(void(^)(NSError *error))failure;

/**
 * 使用座驾
 * id
 @param success 成功
 @param failure 失败
 */
-(void)PropsUsePropsListWithItemID:(NSString *)itemID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 直播首页轮播图
 @param success 成功
 @param failure 失败
 */
-(void)SliderGetSliderWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 直播首页轮播图和新闻头条
 @param success 成功
 @param failure 失败
 */
-(void)SliderGetSliderArtWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取电影预告信息
 @param success 成功
 @param failure 失败
 */
-(void)FilmTrailerGetNoticeWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取电影预告时间轴
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)FilmTrailerGetTimeLineWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取他人已发视频
 * user_id: 用户id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)FilmOtherPublishFilmWithUserID:(NSString *)userID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取用户动态
 * user_id: 用户id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)UserGetUserDynamicWithUserID:(NSString *)userID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取个人作品
 * user_id: 用户id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)PersonalGetUserVideoWithUserID:(NSString *)userID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 点赞过的视频
 * user_id: 用户id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)PersonalGetLikeListWithUserID:(NSString *)userID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 音乐广告轮播图
 @param success 成功
 @param failure 失败
 */
-(void)MusicSliderAdWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 推荐音乐
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)MusicRecommendWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 音乐分类菜单
 @param success 成功
 @param failure 失败
 */
-(void)MusicCategoryListWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 音乐分类菜单下具体作品
 * category_id: 音乐类别id
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)MusicMusicsByCategoryListWithCategoryId:(NSString *)categoryId Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 音乐主页列表数据
 @param success 成功
 @param failure 失败
 */
-(void)MusicHomeWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 音乐搜索
 * offset: 默认列表
 * length: 每页多少条
 * words
 @param success 成功
 @param failure 失败
 */
-(void)MusicSearchWithWords:(NSString *)words Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 回复消息
 * id: 消息id
 * type: 消息类型
 * content: 回复内容
 @param success 成功
 @param failure 失败
 */
-(void)MessageReplyMsgWithMessageID:(NSString *)messageID type:(NSString *)type content:(NSString *)content Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 一级评论
 * video_id: 视频id
 * last_id: 最后一条评论id，默认为0
 * offset: 默认列表
 * length: 每页多少条
 @param success 成功
 @param failure 失败
 */
-(void)CommentCommentListWithVideoID:(NSString *)video_id topCommentId:(NSString *)topCommentId LastID:(NSString *)lastID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

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
-(void)CommentSubCommentListWithVideoID:(NSString *)video_id CommentID:(NSString *)commentID topCommentId:(NSString *)topCommentId LastID:(NSString *)lastID Offset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 删除评论
 * id : 评论id
 @param success 成功
 @param failure 失败
 */
-(void)CommentDeleteWithCommentID:(NSString *)comment Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 评论点赞
 * comment_id : 评论id
 @param success 成功
 @param failure 失败
 */
-(void)CommentLikeWithCommentID:(NSString *)commentID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 发表评论
 * video_id : 视频id
 * content :  内容
 * reply_id : 父评论id
 * friends : @好友
 @param success 成功
 @param failure 失败
 */
-(void)CommentCommentWithVideoID:(NSString *)videoID Comment:(NSString *)comment ReplyID:(NSString *)replyID Friends:(NSString *)friends Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 直播K歌列表
 @param success 成功
 @param failure 失败
 */
-(void)RoomMusicHomeWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 上报使用的音乐
 @param success 成功
 @param failure 失败
 */
-(void)MusicReportUseMusicWithMusicID:(NSString *)musicID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 已使用过的音乐
 @param success 成功
 @param failure 失败
 */
-(void)MusicUseMusicListWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 直播列表获取二级导航栏
 * id 一级导航栏频道id
 * nav_type 一级导航栏类型
 @param success 成功
 @param failure 失败
 */
-(void)RoomGetNavTreeWithChannelId:(NSString *)channelId NavType:(NSString *)nav_type Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取好友列表
 @param success 成功
 @param failure 失败
 */
- (void)FriendsGetFriendsListWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 发现好友(推荐)
 @param success 成功
 @param failure 失败
 */
- (void)FriendsRecommendWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 上传通讯录
 * data: 本地通讯录Json字符串
 @param success 成功
 @param failure 失败
 */
- (void)FriendsAddbooksWithData:(NSString *)data Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 获取通讯录好友
 @param success 成功
 @param failure 失败
 */
- (void)FriendsBookslistWithOffset:(NSString *)offset length:(NSString *)length Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;



/// 搜索好友
/// @param keyword 关键字
/// @param offset 下标
/// @param length 长度
/// @param success 成功
/// @param failure 失败
-(void)FriendSearchWithkeyword:(NSString *)keyword
                        offset:(NSString *)offset
                        length:(NSString *)length
                       Success:(void(^)(id responseObject))success
                       Failure:(void(^)(NSError *error))failure;

/**
 * 移除推荐
 * addBook_id: 通讯录id
 @param success 成功
 @param failure 失败
 */
- (void)FriendsUnrecommendWithAddBookID:(NSString *)addBook_id Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 好友口令
 * friend : 要生成口令的id
 @param success 成功
 @param failure 失败
 */
- (void)FriendsGetfriendcodeWithFriend:(NSString *)friendID Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 解析口令
 * codestr: 口令
 @param success 成功
 @param failure 失败
 */
- (void)FriendsFriendcodetoWithCodesStr:(NSString *)codestr Success:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

/**
 * 码
 @param success 成功
 @param failure 失败
 */
- (void)FriendsGenerateWithSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError *error))failure;

@end

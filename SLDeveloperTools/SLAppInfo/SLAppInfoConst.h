//
//  SLAppInfoConst.h
//  Pods
//
//  Created by sweetloser on 2021/1/5.
//

#ifndef SLAppInfoConst_h
#define SLAppInfoConst_h

static NSString *const kDefaultPhoneArea = @"DefaultPhoneArea";
static NSString *const kDefaultPhoneCode = @"DefaultPhoneCode";

static NSString *const sl_HttpResponseCodeError = @"sl_HttpResponseCodeError";                        //http请求 code 不为 0
static NSString *const sl_UploadFileResponseCodeError = @"sl_UploadFileResponseCodeError";                        //上传文件请求 code 不为 0
static NSString *const kDidShareNotification = @"DidShareNotification";                               //分享完成


static NSString *const BXDynMsgDetailModel2PersonHome = @"BXDynMsgDetailModel2PersonHome";             //点击昵称跳转个人主页
static NSString *const BXDynMsgDetailModel2TopicCategory = @"BXDynMsgDetailModel2TopicCategory";             //点击话题跳转话题页面

static NSString *const BXGo2Login = @"BXGo2Login";                                                    //登录


static NSString *const BXAttenShareVideo2 = @"BXAttenShareVideo2";

static NSString *const SHOP_LIVE_KEFU = @"SHOP_LIVE_KEFU";

static NSString *const BXLoadURL = @"BXLoadURL";                                                    //

static NSString *const TM_BXLoadURL = @"TM_BXLoadURL";                                                    //

static NSString *const BXEnterRoomWithRooms = @"BXEnterRoomWithRooms";                            //进入直播间

static NSString *const BXGo2BXVideoPlayVC = @"BXGo2BXVideoPlayVC";                            //进入视频播放页面

static NSString *const kStartLocationNotification = @"StartLocationNotification";                   //开始定位

static NSString *const BXGoToGoodsDetail = @"BXGoToGoodsDetail";                   //跳转商品详情页

static NSString *const kDidGetLocationNotification = @"DidGetLocationNotification";                   //获取到了定位信息

static NSString *const kDidCollectNotification = @"DidCollectNotification";                           //收藏或取消收藏

static NSString *const kDidCommentNotification = @"DidCommentNotification";                           //评论或删除评论

static NSString *const kSendChangeStatusNotification = @"SendChangeStatusNotification";               //更改看板关注状态

static NSString *const kDidZanNotification = @"DidZanNotification";                                   //赞或取消赞

static NSString *const kDidSeeNotification = @"DidSeeNotification";                                   //观看或不观看

static NSString *const kDeleteNotification = @"DeleteNotification";                                   //删除

static NSString *const TMSeedCommentStatus = @"TMSeedCommentStatus";

static NSString *const kHomepageType = @"HomepageType";
static NSString *const kUserPhoneNumber = @"UserPhoneNumber";
//static NSString *const kDefaultPhoneCode = @"DefaultPhoneCode";
//static NSString *const kDefaultPhoneArea = @"DefaultPhoneArea";

static NSString *const kEndShowAdvertisementNotification = @"EndShowAdvertisementNotification";
static NSString *const kHomepageTypeNotification = @"HomepageTypeNotification";
static NSString *const kNeedGetHomepageDataNotification = @"NeedGetHomepageDataNotification";
static NSString *const NeedGetMyDyanmicDataNotification = @"NeedGetMyDyanmicDataNotification";
static NSString *const NeedGetMyPersonalDataNotification = @"NeedGetMyPersonalDataNotification";
static NSString *const kDidPlayNotification = @"DidPlayNotification";                                 //播放视频（统计播放次数）
//static NSString *const kDidZanNotification = @"DidZanNotification";                                   //赞或取消赞
//static NSString *const kDidCollectNotification = @"DidCollectNotification";                           //收藏或取消收藏
//static NSString *const kDidSeeNotification = @"DidSeeNotification";                                   //观看或不观看

//static NSString *const kSendChangeStatusNotification = @"SendChangeStatusNotification";               //更改看板关注状态
static NSString *const kUnLikeNotification = @"UnLikeNotification";                                   //不感兴趣
static NSString *const kNeedSearchNotification = @"NeedSearchNotification";                           //需要搜索
static NSString *const kVideoPlayStateNotification = @"VideoPlayStateNotificatio";                    //视频播放状态
static NSString *const kVideoRewardUsersChangedNotification = @"VideoRewardUsersChangedNotification"; //视频播放状态

static NSString *const kDidLoginNotification = @"DidLoginNotification";                               //已经登录
static NSString *const kDidLogoutNotification = @"DidLogoutNotification";                             //已经退出登录

//static NSString *const sl_HttpResponseCodeError = @"sl_HttpResponseCodeError";                        //http请求 code 不为 0
//static NSString *const sl_UploadFileResponseCodeError = @"sl_UploadFileResponseCodeError";                        //上传文件请求 code 不为 0

static NSString *const kDidGetAccessTokenNotification = @"DidGetAccessTokenNotification";             //获取到AccessToken

static NSString *const kAppShowAllData = @"AppShowAllData";                                            //app不隐藏部分数据

//static NSString *const kDidGetLocationNotification = @"DidGetLocationNotification";                 //获取到了定位信息
static NSString *const kDidGetGameChannelNotification = @"DidGetGameChannelNotification";             //获取到游戏频道
static NSString *const kDisplayIncomeNotification = @"DisplayIncomeNotification";                     //显示收益
static NSString *const kQueryGuardCoverNotification = @"QueryGuardCoverNotification";                 //查询守护着头像
//static NSString *const kDidCommentNotification = @"DidCommentNotification";                           //评论或删除评论

static NSString *const kDidUpdateGiftResourcesNotification = @"DidUpdateGiftResourcesNotification";   //更新礼物资源包成功

static NSString *const kUploadProgressChangeNotification = @"UploadProgressChangeNotification";       //上传视频进度变化
static NSString *const kUploadTencentCloudFailNotification = @"UploadTencentCloudFailNotification";   //上传视频腾讯云失败
static NSString *const kUploadServerFailNotification = @"UploadServerFailNotification";               //上传视频通知服务器失败
static NSString *const kUploadMovieSuccessNotification = @"UploadMovieSuccessNotification";           //上传视频成功
static NSString *const kRemoveMovieSuccessNotification = @"RemoveMovieSuccessNotification";           //删除视频成功

static NSString *const kFollow_push_1 = @"follow_push_1";                                             //开启关注提醒的用户
static NSString *const kRoundPetchNotification = @"RoundPetchNotification";           //pk匹配
static NSString *const kClosePetchViewNotification = @"ClosePetchViewNotification";           //pk匹配

static NSString *const kCloseVoiceLiveNotification = @"kCloseVoiceLiveNotification";           //pk匹配

static NSString *const kMessageStatusNotification = @"MessageStatusNotification";           //pk匹配

static NSString *const kLinkMicStatusNotification = @"LinkMicStatusNotification";

static NSString *const kChangePersonCenterNotification = @"kChangePersonCenterNotification";                                   //更改个人中心数据


static NSString *const kDidReplyDeleteCommentNotification = @"DidReplyDeleteCommentNotification";  //回复/删除评论

static NSString *const kDidNewsPlayPauseNotification = @"DidNewsPlayPauseNotification";  //头条1播放/0暂停

//sl 新增
static NSString *const slAddLiveGoodsListNotification = @"AddLiveGoodsListNotification";  //添加
static NSString *const slDeleteLiveGoodsListNotification = @"DeleteLiveGoodsListNotification";  //删除
static NSString *const slBeTopLiveGoodsListNotification = @"BeTopLiveGoodsListNotification";  //置顶
static NSString *const slSayLiveGoodsListNotification = @"SayLiveGoodsListNotification";  //讲解
static NSString *const slUnSayLiveGoodsListNotification = @"UnSayLiveGoodsListNotification";  //讲解
static NSString *const slSalePointLiveGoodsListNotification = @"SalePointLiveGoodsListNotification";  //设置卖点
static NSString *const slSayLiveGoodsShowSmallWindowNotification = @"SayLiveGoodsShowSmallWindowNotification";  //讲解显示浮窗
static NSString *const slUnSayLiveGoodsHiddenSmallWindowNotification = @"UnSayLiveGoodsHiddenSmallWindowNotification";  //取消讲解隐藏浮窗

//观众端
static NSString *const slPlayAddLiveGoodsListNotification = @"PlayAddLiveGoodsListNotification";  //添加
static NSString *const slPlayDeleteLiveGoodsListNotification = @"PlayDeleteLiveGoodsListNotification";  //删除
static NSString *const slPlaySayLiveGoodsListNotification = @"PlaySayLiveGoodsListNotification";
static NSString *const slPlayUnSayLiveGoodsListNotification = @"PlayUnSayLiveGoodsListNotification";
static NSString *const slPlayBeTopLiveGoodsListNotification = @"PlayBeTopLiveGoodsListNotification";
static NSString *const slPlaySalePointLiveGoodsListNotification = @"SalePointLiveGoodsListNotification";
static NSString *const slPlaySayLiveGoodsShowSmallWindowNotification = @"PlaySayLiveGoodsShowSmallWindowNotification";  //讲解显示浮窗
static NSString *const slPlayUnSayLiveGoodsHiddenSmallWindowNotification = @"PlayUnSayLiveGoodsHiddenSmallWindowNotification";  //取消讲解隐藏浮窗

static NSString *const sl_GoodsDetailDealloc = @"sl_GoodsDetailDealloc";    //商品详情页面销毁了
static NSString *const sl_showSmallPlayWindow = @"sl_showSmallPlayWindow";
static NSString *const kDidOpenTeenNotification = @"DidOpenTeenNotification";                               //开启青少年
static NSString *const kDidCloseTeenNotification = @"DidCloseTeenNotification";                               //开启青少年

//SL 新增
// 拓幻美颜 授权key
static NSString *const BX_TH_KEY = @"f81aab6d38234a3a8746db931f1776c7";

//拓幻短视频 配置 信息
static NSString *const BX_TH_SHORT_VIDEO_CONFIG = @"ShortVideoParameterConfiguration";
//美白
static NSString *const TH_ColorLevelShort = @"TH_ColorLevelShort";

//磨皮
static NSString *const TH_BlurLevelShort = @"TH_BlurLevelShort";

//大眼
static NSString *const TH_EnlargingLevelShort = @"TH_EnlargingLevelShort";

//瘦脸
static NSString *const TH_ThinningLevelShort = @"TH_ThinningLevelShort";

//红润
static NSString *const TH_RedLevelShort = @"TH_RedLevelShort";

//下巴
static NSString *const TH_ChinLevelShort = @"TH_ChinLevelShort";

//额头
static NSString *const TH_ForeheadLevelShort = @"TH_ForeheadLevelShort";

//鼻子
static NSString *const TH_NoseLevelShort = @"TH_NoseLevelShort";

//消息阅读状态
static NSString *const ReadMessageStatus = @"ReadMessageStatus";

static NSString *const DynamdicLikeStatusNotification = @"DynamdicLikeStatusNotification";               //更改喜欢状态
static NSString *const DynamdicCommentStatusNotification = @"DynamdicCommentStatusNotification";
static NSString *const DynamdicCommenAddtNumberNotification = @"DynamdicCommentAddNumberNotification";
static NSString *const DynamdicCommenSubtNumberNotification = @"DynamdicCommentSubNumberNotification";
static NSString *const DynamdicExpressCommentStatusNotification = @"DynamdicExpressCommentStatusNotification";
static NSString *const DynamdicCircleFollowStatusNotification = @"DynamdicCircleFollowStatusNotification";
static NSString *const DynamdicCircleChangeModelNotification = @"DynamdicCircleChangeModelNotification";


static NSString *const DynamicHomePageNew = @"DynamicHomePageNew";
static NSString *const DynamicHomeHeaderPageNew = @"DynamicHomeHeaderPageNew";
static NSString *const DynamicHomePageNear = @"DynamicHomePageNear";
static NSString *const DynamicHomeHeaderPageNear = @"DynamicHomeHeaderPageNear";
static NSString *const DynamicHomePageCircle = @"DynamicHomePageCircle";
static NSString *const DynamicHomePageSound = @"DynamicHomePageSound";
static NSString *const DynamicAttention = @"DynamicAttention";

static NSString *const SLLastLoginMethodKey = @"lastloginmethod";

static NSString *const SLLastLoginAvatarKey = @"lastloginavatar";

static NSString *const SLLastLoginMethodOneKey = @"onekey";
static NSString *const SLLastLoginMethodWechat = @"wechat";
static NSString *const SLLastLoginMethodApple = @"apple";
static NSString *const SLLastLoginMethodQQ = @"qq";
static NSString *const SLLastLoginMethodFB = @"FB";
static NSString *const SLLastLoginMethodPassword = @"password";
static NSString *const SLLastLoginMethodCode = @"code";


static NSString *const SLLastBindMethodKey = @"lastbindmethod";
static NSString *const SLLastBindMethodCode = @"bindcode";
static NSString *const SLLastBindMethodOneKey = @"bindonekey";


//B2B2C TM
static NSString *const TMShopOrderPriceStatus = @"TMShopOrderPriceStatus";
static NSString *const TMShopOrderDelete = @"TMShopOrderDelete";

static NSString *const TMSeedLikeStatus = @"TMSeedLikeStatus";

static NSString *const SLCollectedGoodsNotification = @"SLCollectedGoodsNotification";
static NSString *const SLUnCollectedGoodsNotification = @"SLUnCollectedGoodsNotification";
static NSString *const SLAddGoodsToWindowNotification = @"SLAddGoodsToWindowNotification";
static NSString *const SLDeleteGoodsAtWindowNotification = @"SLDeleteGoodsAtWindowNotification";

static NSString *const SLUpdateGoodsAtWindowNotification = @"SLUpdateGoodsAtWindowNotification";

#pragma mark - 种草
//static NSString *const SLAmwayUploadVideoSuccessNotification = @"SLAmwayUploadVideoSuccessNotification";           //上传视频成功

//static NSString *const SLAmwayUploadVideoFailNotification = @"SLAmwayUploadVideoFailNotificationa";        //上传视频失败
//static NSString *const SLAmwayUploadVideoPublicFailNotification = @"SLAmwayUploadVideoPublicFailNotification";               //上传视频成功，但是发布视频失败

static NSString *const SLAmwayDidLikeNotification = @"SLAmwayDidLikeNotification";             //赞
static NSString *const SLAmwayDidUnLikeNotification = @"SLAmwayDidUnLikeNotification";             //取消赞

static NSString *const SLAmwayDidDeleteNotification = @"SLAmwayDidDeleteNotification";  //删除种草

static NSString *const SLAmwayAttenShareVideo = @"SLAmwayAttenShareVideo";


//商城首页数据缓存
static NSString *const SLMallDataCacheKey = @"SLMallDataCacheKey";


//个人中心订单
static NSString *const TMAPPlyAnhcorNotification = @"TMAPPlyAnhcorNotification";

static NSString *const TMNameAuthenticationNotification = @"TMNameAuthenticationNotification";

static NSString *const TMApplySmallShopNotification = @"TMApplySmallShopNotification";

static NSString *const TMMyInviteNotification = @"TMMyInviteNotification";

static NSString *const TMPersonStoreNotification = @"TMPersonStoreNotification";

static NSString *const TMPersonMyTeamNotification = @"TMPersonMyTeamNotification";

static NSString *const TMGoToLinkNotification = @"TMGoToLinkNotification";

static NSString *const TMConverNotification = @"TMConverNotification";




#endif /* SLAppInfoConst_h */

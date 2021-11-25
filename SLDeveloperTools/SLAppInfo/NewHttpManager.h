//
//  NewHttpManager.h
//  BXlive
//
//  Created by bxlive on 2017/11/30.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NetManagerShares [NewHttpManager sharedNetManager]
NS_ASSUME_NONNULL_BEGIN



typedef void (^Success)(id responseObject);     // 成功Block
typedef void (^Failure)(NSError *error);        // 失败Blcok



@interface NewHttpManager : NSObject

//@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

/**
 *  封装的POST请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)POSTNoNotice:(NSString *)URLString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure;
-(void)AmwayPost:(NSString *)urlString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure;

- (void)APIPOST:(NSString *)URLString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure;

-(void)NOSPOST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
- (void)POST:(NSString *)URLString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure;

- (void)DomainNamePOST:(NSString *)URLString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure;

- (void)MakeFriendPOST:(NSString *)URLString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure;

- (void)UploadFilePOST:(NSString *)URLString parameters:(NSDictionary * __nullable)parameters FileArray:(NSArray *)FileArray IsShowProgress:(BOOL)isShow success:(Success)success failure:(Failure)failure;

/**
 封装POST图片上传(多张图片)
 
 @param operations   请求的参数
 @param imageArray   存放图片的数组
 @param urlString    请求的链接
 @param isShow       是否显示进度
 @param successBlock 发送成功的回调
 @param failureBlock 发送失败的回调
 */
- (void)uploadImageWithOperations:(NSDictionary * __nullable)operations withImageArray:(NSArray *)imageArray withUrlString:(NSString *)urlString IsShowProgress:(BOOL)isShow withSuccessBlock:(Success)successBlock withFailurBlock:(Failure)failureBlock;

-(void)downVideoUrl:(NSString *)videoUrl userId:(NSString *)userId;



/**
 *  单例
 */
+ (instancetype)sharedNetManager;

/**
 *  判断网络
 */
+ (BOOL)isNetWorkConnectionAvailable;



+ (void)collectionAddWithTargetId:(NSString *)targetId
                             type:(NSString *)type
                          success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          failure:(void(^)(NSError *error))failure;

//位置详情
+ (void)locationDetailWithLocationId:(NSString *)locationId
                                 lat:(NSString *)lat
                                 lng:(NSString *)lng
                                  success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                  failure:(void(^)(NSError *error))failure;

//位置下视频
+ (void)videosByLocationWithLocationId:(NSString *)locationId
                                offset:(NSString *)offset
                               success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                               failure:(void(^)(NSError *error))failure;

+ (void)followWithUserId:(NSString *)userId
                 success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 failure:(void(^)(NSError *error))failure;

#pragma - mark 视频
//发布视频
+ (void)publishFilmWithLng:(NSString *)lng
                       lat:(NSString *)lat
                       uid:(NSString *)uid
                  goods_id:(NSString *)goods_id
                is_synchro:(NSString *)is_synchro
              locationName:(NSString *)locationName
                   musicId:(NSString *)musicId
               regionLevel:(NSString *)regionLevel
                   visible:(NSString *)visible
                  describe:(NSString *)describe
                   videoId:(NSString *)videoId
                  videoUrl:(NSString *)videoUrl
                  coverUrl:(NSString *)coverUrl
                     topic:(NSString *)topic
                   friends:(NSString *)friends
                  duration:(NSString *)duration
                  filmSize:(NSString *)filmSize
                   success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   failure:(void(^)(NSError *error))failure; 


//发布动态视频
+ (void)publishFilmWithLng:(NSString *)lng
                       lat:(NSString *)lat
                       uid:(NSString *)uid
                  goods_id:(NSString *)goods_id
              locationName:(NSString *)locationName
                   musicId:(NSString *)musicId
               regionLevel:(NSString *)regionLevel
                   visible:(NSString *)visible
                  describe:(NSString *)describe
                   videoId:(NSString *)videoId
                  videoUrl:(NSString *)videoUrl
                  coverUrl:(NSString *)coverUrl
                     topic:(NSString *)topic
                   friends:(NSString *)friends
                  duration:(NSString *)duration
                  filmSize:(NSString *)filmSize
                   success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   failure:(void(^)(NSError *error))failure;


//搜索  type: all(综合),film(视频),live(直播),user(用户)
+ (void)globalSearchWithType:(NSString *)type
                     keyword:(NSString *)keyword
                      offset:(NSString *)offset
                     success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure;

#pragma - mark 搜索
//热搜、发现
+ (void)searchIndexSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   failure:(void(^)(NSError *error))failure;

//验证宝箱
+ (void)inspectionTreasureChestWithVideoId:(NSString *)videoId
                                   success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                   failure:(void(^)(NSError *error))failure;

//开启宝箱
+ (void)openRewardWithVideoId:(NSString *)videoId
                      diggNum:(NSString *)diggNum
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure ;


#pragma - mark 记录
//播放记录
+ (void)behaviorWatchWithData:(NSString *)data
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure;

+(void)videoGetRewardRank:(NSString *)videoId offset:(NSString *)offset success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  failure:(void(^)(NSError *error))failure;

//守护礼物列表
+ (void)getGuardGiftSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;

//我的贡献榜
+ (void)getContrRankWithInterval:(NSString *)interval
                          userID:(NSString *)user_id
                         offset:(NSString *)offset
                        success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        failure:(void(^)(NSError *error))failure;

//用户英雄榜
+ (void)getHeroesRankWithInterval:(NSString *)interval
                           offset:(NSString *)offset
                          success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          failure:(void(^)(NSError *error))failure;

//主播魅力榜
+ (void)getCharmRankWithInterval:(NSString *)interval
                          offset:(NSString *)offset
                         success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         failure:(void(^)(NSError *error))failure;

//守护列表
+ (void)guardListWithUserId:(NSString *)userId
                 success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 failure:(void(^)(NSError *error))failure;

//背包
+ (void)getPropsGetUserPropsByPackSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;

//礼物列表
+ (void)getLiveGiftSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;

//礼物资源列表
+ (void)onlineGiftsWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       failure:(void(^)(NSError *error))failure;

//获取直播频道
+ (void)liveChannelWithParentId:(NSString *)parentId
                    success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                    failure:(void(^)(NSError *error))failure;

//歌词报错
+ (void)musicLrcReportWithMusicId:(NSString *)musicId
                          success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          failure:(void(^)(NSError *error))failure;

//云信-获取用户信息
+ (void)yunXinGetUser:(NSString *)userId Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;

//移出黑名单
+ (void)blacklistDeleteWithUserId:(NSString *)userId
                       success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       failure:(void(^)(NSError *error))failure;

//加入黑名单
+ (void)blacklistAddWithUserId:(NSString *)userId
                       success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       failure:(void(^)(NSError *error))failure;

//粉丝列表
+ (void)fansListWithUserId:(NSString *)userId
                      offset:(NSString *)offset
                 success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 failure:(void(^)(NSError *error))failure;

//关注列表
+ (void)followListWithUserId:(NSString *)userId
                      offset:(NSString *)offset
                      length:(NSString *)length
                     success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure;

//附近列表
+ (void)nearByLiveListWithOffset:(NSString *)offset
                          length:(NSString *)length
                          gender:(NSString *)gender
                             age:(NSString *)age
                        city_lng:(NSString *)city_lng
                        city_lat:(NSString *)city_lat
                            city:(NSString *)city
                         success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         failure:(void(^)(NSError *error))failure;

//直播分类列表
+ (void)liveclassificationListWithOffset:(NSString *)offset
                                  length:(NSString *)length
                               navType:(NSString *)navType
                               success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                               failure:(void(^)(NSError *error))failure;

//热门列表
+ (void)hotLiveListWithOffset:(NSString *)offset
                       length:(NSString *)length
                    success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                    failure:(void(^)(NSError *error))failure;

//直播头条
+ (void)getArticleListWithOffset:(NSString *)offset
                         success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         failure:(void(^)(NSError *error))failure;

//消息主菜单
+ (void)indexNewWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                    failure:(void(^)(NSError *error))failure;

//最新列表
+ (void)newLiveListWithOffset:(NSString *)offset
                       length:(NSString *)length
                    success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                    failure:(void(^)(NSError *error))failure;

//实名认证
+ (void)verificationWithName:(NSString *)name
                    card_num:(NSString *)card_num
                 idcard_type:(NSString *)idcard_type
                 hand_idcard:(NSString *)hand_idcard
                front_idcard:(NSString *)front_idcard
                 back_idcard:(NSString *)back_idcard
                   is_anchor:(NSString *)is_anchor
                     success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure;

//下次修改昵称时间
+ (void)nextRenickTimeWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            failure:(void(^)(NSError *error))failure;

/// 获取后台所有标签
/// @param success 成功
/// @param failure 失败
+(void)GetAllImpressionSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       failure:(void(^)(NSError *error))failure;

/// 修改用户标签
/// @param ids 标签id
/// @param success 成功
/// @param failure 失败
+(void)SaveUserIpmpressWithids:(NSString *)ids
                       success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       failure:(void(^)(NSError *error))failure;

/// 获取会员中心用户标签
/// @param success 成功
/// @param failure 失败
+(void)GetuserImpressionSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure;

//获取验证码
+ (void)sendSmsCodeWithPhone:(NSString *)phone
                       scene:(NSString *)scene
                   phoneCode:(NSString *)phoneCode
                     success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure;

//绑定第三方账号
+ (void)bindThirdWithType:(NSString *)type
                   openid:(NSString *)openid
                 nickname:(NSString *)nickname
                   avatar:(NSString *)avatar
                   gender:(NSString *)gender
                     uuid:(NSString *)uuid
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure;

//修改或设置密码
+ (void)changePwdWithPassword:(NSString *)password
                 old_password:(NSString *)old_password
             confirm_password:(NSString *)confirm_password
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure;

//绑定手机号(非第三方登录)
+ (void)bindPhoneNumWithPhone:(NSString *)phone
                         code:(NSString *)code
                    phoneCode:(NSString *)phoneCode
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure;

//获取手机区号
+ (void)getPhoneCodesSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        failure:(void(^)(NSError *error))failure;

//用户名密码登录
+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                phoneCode:(NSString *)phoneCode
                  success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  failure:(void(^)(NSError *error))failure;

//重置密码
+ (void)resetPwdWithPassword:(NSString *)password
              confirmPassword:(NSString *)confirmPassword
                         code:(NSString *)code
                        phone:(NSString *)phone
                    phoneCode:(NSString *)phoneCode
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure;

//检查直播间
+ (void)verifyRoomWithRoomId:(NSString *)roomId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;
//进入直播间
+ (void)enterRoomWithRoomId:(NSString *)roomId password:(NSString *)password success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;

//查询用户信息（弹窗用)
+ (void)liveUserPopWithRoomId:(NSString *)roomId userId:(NSString *)userId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;

//踢人
+ (void)kickingWithRoomId:(NSString *)roomId userId:(NSString *)userId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;

//禁言
+ (void)shutSpeakWithRoomId:(NSString *)roomId userId:(NSString *)userId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;

//场控
+ (void)manageSwitchWithUserId:(NSString *)userId anchorId:(NSString *)anchorId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure;

#pragma mark - tool
+(NSString *)stringNoNil:(NSString *)str;

@end

NS_ASSUME_NONNULL_END

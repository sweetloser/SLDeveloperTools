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
@end

NS_ASSUME_NONNULL_END

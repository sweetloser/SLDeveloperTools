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
@end

NS_ASSUME_NONNULL_END

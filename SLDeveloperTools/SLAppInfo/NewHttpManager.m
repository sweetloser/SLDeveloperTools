//
//  NewHttpManager.m
//  BXlive
//
//  Created by bxlive on 2017/11/30.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "NewHttpManager.h"
#import "../SLCategory/SLCategory.h"
#import "../SLUtilities/SLUtilities.h"
#import "../SLVideoWaterMaskTools/SLVideoWaterMaskTools.h"
#import "../SLNetTools/SLNetTools.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLMacro/SLMacro.h"
#import "BXAppInfo.h"
#import "SLAppInfoMacro.h"
#import "SLAppInfoConst.h"
#import "BXKTVHTTPCacheManager.h"
#import "BXSavePhotoHelper.h"
#import "BXHMovieModel.h"
#import <Bugly/Bugly.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
//#import "BXKTVHTTPCacheManager.h"
#import <UIKit/UIKit.h>
#import "BXGift.h"
#import "BXLiveUser.h"
#import "BXLiveChannel.h"
#import "BXSLLiveRoom.h"

@interface NewHttpManager()

@end

@implementation NewHttpManager

static NewHttpManager *manager = nil;
+(instancetype)sharedNetManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        
    });
    return manager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}
- (void)POSTNoNotice:(NSString *)URLString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure
{
    NSDictionary *dict = [BXAppInfo getAllParametersWithParameters:parameters];
    NSString *url = [New_Http_Base_Url stringByAppendingString:URLString];
    [self GeneralPOSTNoNotice:url parameters:dict success:success failure:failure];
}

/**
 *  封装的POST请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */

/*
code
0 成功
1 常见错误（前端无特殊需求的）
1000 没有access_token或者access_token不合法
1001 access_token过期（有刷新机制见刷新接口）
1002 后台已下线该用户（可能在其他设备登录）
1003 需要用户登录
1004 需要引导用户绑定手机号
1005 引导用户充值
10002   账号不存在
*/

- (void)POST:(NSString *)URLString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure
{
    NSDictionary *dict = [BXAppInfo getAllParametersWithParameters:parameters];
    NSString *url = [New_Http_Base_Url stringByAppendingString:URLString];
    [self GeneralPOST:url parameters:dict success:success failure:failure];
}

- (void)APIPOST:(NSString *)URLString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure{
    
    NSMutableDictionary *dict = (NSMutableDictionary *)[BXAppInfo getAllParametersWithParameters:parameters];
    [dict setValue:@"ios" forKey:@"app_type"];
    [dict setValue:@"苹果" forKey:@"app_type_name"];
    NSString *url = [SL_HTTP_BASE_API_URL stringByAppendingString:URLString];
    [self GeneralPOST:url parameters:dict success:success failure:failure];
}


-(void)AmwayPost:(NSString *)urlString parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure{
    
    NSDictionary *dict = [BXAppInfo getAllParametersWithParameters:parameters];
    [dict setValue:@"ios" forKey:@"app_type"];
    [dict setValue:@"苹果" forKey:@"app_type_name"];
    NSString *url = [SL_HTTP_BASE_AMWAY_URL stringByAppendingString:urlString];
    [self GeneralPOST:url parameters:dict success:success failure:failure];
}


- (void)GeneralPOSTNoNotice:(NSString *)url parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure
{
    [[SLHttpManager sl_sharedNetManager] sl_post:url parameters:parameters success:^(id  _Nullable responseObject) {
        NSString *code = responseObject[@"code"];
        if ([code integerValue] == 1001) {
            //access_token过期,刷新access_token
            id theResponseObject = responseObject;
            [BXAppInfo refreshTokenWithSuccess:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
                NSDictionary *dataDic  = jsonDic[@"data"];
                NSString *accessToken = dataDic[@"access_token"];
                BXAppInfo *appInfo = [BXAppInfo appInfo];
                appInfo.access_token = accessToken;
                [BXAppInfo setAppInfo:appInfo];
                success(theResponseObject);
            } failure:^(NSError *error) {
                success(theResponseObject);
            }];
        } else {
            success(responseObject);
            if ([code integerValue] == 1003 || [code integerValue] == 1002 || [code integerValue] == 1006) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:sl_HttpResponseCodeError object:nil userInfo:responseObject];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [Bugly reportExceptionWithCategory:3 name:@"接口错误" reason:@"访问接口出错" callStack:@[] extraInfo:@{@"url":url,@"parameters":parameters} terminateApp:NO];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (failure) {
            error.isNetWorkConnectionAvailable = YES;
            failure(error);
        }
    }];
}


- (void)GeneralPOST:(NSString *)url parameters:(NSDictionary * __nullable)parameters success:(Success)success failure:(Failure)failure
{
    
    [[SLHttpManager sl_sharedNetManager] sl_post:url parameters:parameters success:^(id  _Nullable responseObject) {
        
        NSLog(@"接口地址:%@ \n \n 返回数据: %@",[NSString stringWithFormat:@"\n%@\n%@",url,[self getStringWithDic:parameters]],responseObject);
        NSString *code = responseObject[@"code"];
        if ([code integerValue] == 1001) {
            //access_token过期,刷新access_token
            id theResponseObject = responseObject;
            [BXAppInfo refreshTokenWithSuccess:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
                NSDictionary *dataDic  = jsonDic[@"data"];
                NSString *accessToken = dataDic[@"access_token"];
                BXAppInfo *appInfo = [BXAppInfo appInfo];
                appInfo.access_token = accessToken;
                [BXAppInfo setAppInfo:appInfo];
                success(theResponseObject);
            } failure:^(NSError *error) {
                success(theResponseObject);
            }];
        } else {
            success(responseObject);
            if ([code integerValue] == 1003 || [code integerValue] == 1002 || [code integerValue] == 1006) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:sl_HttpResponseCodeError object:nil userInfo:responseObject];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"接口地址：%@ \n参数：%@\n返回值：%@",url,parameters,error);
        if (failure) {
            error.isNetWorkConnectionAvailable = YES;
            failure(error);
        }
    }];
}
-(void)NOSPOST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure{
    NSDictionary *dict = [BXAppInfo getAllParametersWithParameters:parameters];
    NSString *url = [New_Http_Base_domain stringByAppendingString:URLString];
    [self GeneralPOST:url parameters:dict success:success failure:failure];
}

-(void)MakeFriendPOST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure{
    NSDictionary *dict = [BXAppInfo getAllParametersWithParameters:parameters];
    NSString *url = [New_Http_Base_make_friend stringByAppendingString:URLString];
    [self GeneralPOST:url parameters:dict success:success failure:failure];
}

-(void)DomainNamePOST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure{
    NSDictionary *dict = [BXAppInfo getAllParametersWithParameters:parameters];
    NSString *url = [New_Http_Base_domain stringByAppendingString:URLString];
    [self GeneralPOST:url parameters:dict success:success failure:failure];
}

/**
 封装POST图片上传(多张图片)
 
 @param operations   请求的参数
 @param imageArray   存放图片的数组
 @param urlString    请求的链接
 @param isShow       是否显示进度
 @param successBlock 发送成功的回调
 @param failureBlock 发送失败的回调
 */
- (void)uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withUrlString:(NSString *)urlString IsShowProgress:(BOOL)isShow withSuccessBlock:(Success)successBlock withFailurBlock:(Failure)failureBlock{
    NSDictionary *dict = [BXAppInfo getAllParametersWithParameters:operations];
    NSString *url = [New_Http_Base_Url stringByAppendingString:urlString];
    
    
    [[SLHttpManager sl_sharedNetManager] sl_uploadImageWithOperations:dict withImageArray:imageArray withUrlString:url withProgress:^(NSProgress * _Nonnull progress) {
        
    } withSuccessBlock:^(id  _Nullable responseObject) {
        if([responseObject[@"code"]intValue] == 0)
        {
            if (isShow) {
                [BGProgressHUD showInfoWithMessage:@"上传成功!"];
            }
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
            
        }else if([responseObject[@"code"] integerValue]==9000||[responseObject[@"data"][@"code"] integerValue]==700){
            [[NSNotificationCenter defaultCenter] postNotificationName:sl_UploadFileResponseCodeError object:nil userInfo:responseObject];
        }else{
            [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
        }
    } withFailurBlock:^(NSError * _Nonnull error) {
        if (isShow) {
            [BGProgressHUD showInfoWithMessage:@"上传失败!"];
        }
        failureBlock(error);
    }];
}

-(void)UploadFilePOST:(NSString *)URLString parameters:(NSDictionary *)parameters FileArray:(NSArray *)FileArray IsShowProgress:(BOOL)isShow success:(Success)success failure:(Failure)failure{
    NSDictionary *dict = [BXAppInfo getAllParametersWithParameters:parameters];
    [dict setValue:@"896042ed1ec1dab0d4739e353bb29d284072c87d" forKey:@"access_token"];
    NSString *url = [SL_HTTP_BASE_AMWAY_URL stringByAppendingString:URLString];
    [self GeneralUploadPOST:url Operations:dict FileArray:FileArray IsShowProgress:isShow success:success failure:failure];
}

-(void)GeneralUploadPOST:(NSString *)urlString Operations:(NSDictionary *)operations FileArray:(NSArray *)FileArray IsShowProgress:(BOOL)isShow success:(Success)success failure:(Failure)failure{
    
    [[SLHttpManager sl_sharedNetManager] sl_UploadImageAndVideo:urlString Operations:operations FileArray:FileArray withProgress:^(NSProgress * _Nonnull progress) {
        if (isShow) {
            [BGProgressHUD showProgress:(progress.completedUnitCount / progress.totalUnitCount/1.00) status:@"正在上传"];
        }
    } success:^(id  _Nonnull responseObject) {
        if([responseObject[@"code"]intValue] == 0)
        {
            if (isShow) {
                [BGProgressHUD showInfoWithMessage:@"上传成功!"];
            }
            success(responseObject);
        }else if([responseObject[@"code"] integerValue]==9000||[responseObject[@"data"][@"code"] integerValue]==700){
            [[NSNotificationCenter defaultCenter] postNotificationName:sl_UploadFileResponseCodeError object:nil userInfo:responseObject];
        }else{
            [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        if (isShow) {
            [BGProgressHUD showInfoWithMessage:@"上传失败!"];
        }
      failure(error);
        NSLog(@"接口地址:%@ \n 参数:%@ \n 请求失败: %@",urlString,operations,error);
    }];
}

-(void)downVideoUrl:(NSString *)videoUrl userId:(nonnull NSString *)userId {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                [self download:videoUrl userId:userId];
            } else {
                [BGProgressHUD showInfoWithMessage:@"无相册权限，请在设置中打开"];
            }
        });
    }];
}

-(void)download:(NSString *)videoUrl userId:(nonnull NSString *)userId {
    
    NSURL *proxyURL =[BXKTVHTTPCacheManager getProxyURLWithOriginalURL:[NSURL URLWithString:videoUrl]];
    
    [[SLHttpManager sl_sharedNetManager] sl_downloadVideoWithURL:proxyURL progress:^(NSProgress * _Nonnull progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [BGProgressHUD showProgress:progress.fractionCompleted status:@"正在下载视频"];
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fileName = [videoUrl lastPathComponent];
        NSString *filePath = [FilePathHelper getCachesPath];
        filePath = [filePath stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [BGProgressHUD showInfoWithMessage:@"下载失败"];
            } else {
#ifdef LYGLiveURL
                [BXVideoWatcerHelp watermarkingWithVideoUrl:filePath waterImg:@"" text:@"" isShow:YES completion:^(NSString * _Nonnull videofilePath) {
                    [BXSavePhotoHelper savePhotos:videofilePath completion:^(NSError *error) {
                        [FilePathHelper removeFileAtPath:videofilePath];
                    }];
                    [FilePathHelper removeFileAtPath:[filePath path]];
                } isSystem:YES];
#else
                [BXVideoWatcerHelp watermarkingWithVideoUrl:filePath waterImg:[BXAppInfo appInfo].water_marker text:[NSString stringWithFormat:@"ID：%@",userId] isShow:YES completion:^(NSString * _Nonnull videofilePath) {
                    [BXSavePhotoHelper savePhotos:videofilePath completion:^(NSError *error) {
                        [FilePathHelper removeFileAtPath:videofilePath];
                    }];
                    [FilePathHelper removeFileAtPath:[filePath path]];
                } isSystem:YES];
#endif
                
            }
        });
    }];
}

//拼接完整的网址
- (NSString *)getStringWithDic:(NSDictionary *)params{
    //排序key
    NSArray *keyArray = [params allKeys];//获取待排序的key
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 ];
    }];//获取排序后的key
    //排序后的以key=value拼接的数组
    NSMutableArray *valueArray = [NSMutableArray array];
    for(NSString *sortSring in sortArray){
        NSString *signSring = [NSString stringWithFormat:@"%@=%@",sortSring,[params objectForKey:sortSring]];
        [valueArray addObject:signSring];
    }
    // 就是用“,”把每个排序后拼接的数组，用字符串拼接起来
    NSString *string = [valueArray componentsJoinedByString:@"&"];
    return string;
}


+ (BOOL)isNetWorkConnectionAvailable;{
    return [SLHttpManager sl_sharedNetManager].netStatus;
}

+ (void)collectionAddWithTargetId:(NSString *)targetId
                             type:(NSString *)type
                          success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"target_id":[self stringNoNil:targetId], @"type":[self stringNoNil:type]};
    [[NewHttpManager sharedNetManager] POST:@"s=Collection.add" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (NSString *)stringNoNil:(NSString *)str {
    if (str) {
        return str;
    } else {
        return @"";
    }
}

//位置详情
+ (void)locationDetailWithLocationId:(NSString *)locationId
                                 lat:(NSString *)lat
                                 lng:(NSString *)lng
                             success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                             failure:(void(^)(NSError *error))failure; {
    NSDictionary *params = @{@"location_id":[self stringNoNil:locationId], @"lat":[self stringNoNil:lat], @"lng":[self stringNoNil:lng]};
    [[NewHttpManager sharedNetManager] POST:@"s=Video.locationDetail" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//位置下视频
+ (void)videosByLocationWithLocationId:(NSString *)locationId
                                offset:(NSString *)offset
                               success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                               failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"location_id":[self stringNoNil:locationId],@"offset":[self stringNoNil:offset]};
    [[NewHttpManager sharedNetManager] POST:@"s=Video.videosByLocation" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            BXHMovieModel *model = [[BXHMovieModel alloc] init];
            [model updateWithJsonDic:dic];
            [models addObject:model];
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)followWithUserId:(NSString *)userId
                 success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"user_id":[self stringNoNil:userId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Follow.follow" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

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
                   failure:(void(^)(NSError *error))failure; {
    
    NSDictionary *params = @{@"location_name":[self stringNoNil:locationName],@"music_id":[self stringNoNil:musicId],@"region_level":[self stringNoNil:regionLevel],@"lng":[self stringNoNil:lng],@"lat":[self stringNoNil:lat],@"poi_id":[self stringNoNil:uid],@"visible":[self stringNoNil:visible],@"describe":[self stringNoNil:describe],@"video_id":[self stringNoNil:videoId],@"video_url":[self stringNoNil:videoUrl],@"cover_url":[self stringNoNil:coverUrl],@"topic":[self stringNoNil:topic],@"friends":[self stringNoNil:friends],@"duration":[self stringNoNil:duration],@"film_size":[self stringNoNil:filmSize],@"goods_id":[self stringNoNil:goods_id],@"is_synchro":is_synchro};
    
    [[NewHttpManager sharedNetManager] POST:@"s=Video.publish" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

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
                   failure:(void(^)(NSError *error))failure {
    
    NSDictionary *params = @{@"location_name":[self stringNoNil:locationName],@"music_id":[self stringNoNil:musicId],@"region_level":[self stringNoNil:regionLevel],@"lng":[self stringNoNil:lng],@"lat":[self stringNoNil:lat],@"poi_id":[self stringNoNil:uid],@"visible":[self stringNoNil:visible],@"describe":[self stringNoNil:describe],@"video_id":[self stringNoNil:videoId],@"video_url":[self stringNoNil:videoUrl],@"cover_url":[self stringNoNil:coverUrl],@"topic":[self stringNoNil:topic],@"friends":[self stringNoNil:friends],@"duration":[self stringNoNil:duration],@"film_size":[self stringNoNil:filmSize],@"goods_id":[self stringNoNil:goods_id]};
    
    [[NewHttpManager sharedNetManager] POST:@"s=Video.publish" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//搜索  type: all(综合),film(视频),live(直播),user(用户)
+ (void)globalSearchWithType:(NSString *)type
                     keyword:(NSString *)keyword
                      offset:(NSString *)offset
                     success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"type":[self stringNoNil:type], @"keyword":[self stringNoNil:keyword], @"offset":[self stringNoNil:offset]};
    [[NewHttpManager sharedNetManager] POST:@"s=Search.complex" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma - mark 搜索
//热搜、发现
+ (void)searchIndexSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=Search.index" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//验证宝箱
+ (void)inspectionTreasureChestWithVideoId:(NSString *)videoId
                                   success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                   failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"video_id":[self stringNoNil:videoId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Video.preOpenReward" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//开启宝箱
+ (void)openRewardWithVideoId:(NSString *)videoId
                      diggNum:(NSString *)diggNum
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"video_id":[self stringNoNil:videoId],@"digg_num":[self stringNoNil:diggNum]};
    [[NewHttpManager sharedNetManager] POST:@"s=Video.openReward" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma - mark 记录
//播放记录
+ (void)behaviorWatchWithData:(NSString *)data
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"data":[self stringNoNil:data]};
    [[NewHttpManager sharedNetManager] POST:@"s=Behavior.watch" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+(void)videoGetRewardRank:(NSString *)videoId offset:(NSString *)offset success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  failure:(void(^)(NSError *error))failure{
    NSDictionary *paramsDic = @{@"video_id":[self stringNoNil:videoId],@"offset":[self stringNoNil:offset]};
    [[NewHttpManager sharedNetManager] POST:@"s=Video.getRewardRank" parameters:paramsDic success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//获取守护礼物列表
+ (void)getGuardGiftSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=Gift.guardGiftList&api_v=v2" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        if (flag) {
            for (NSDictionary *dic in responseObject[@"data"][@"guardGift"]) {
                BXGift *gift = [[BXGift alloc]init];
                gift.giftType = @"1";
                [gift updateWithJsonDic:dic];
                [models addObject:gift];
            }
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//我的贡献榜
+ (void)getContrRankWithInterval:(NSString *)interval
                          userID:(NSString *)user_id
                          offset:(NSString *)offset
                         success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"interval":[self stringNoNil:interval],@"user_id":[self stringNoNil:user_id],  @"offset":[self stringNoNil:offset]};
    [[NewHttpManager sharedNetManager] POST:@"s=User.getContrRank" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSDictionary *dataDic = responseObject[@"data"];
        NSDictionary *listDic = dataDic[@"list"];
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in listDic) {
            BXLiveUser *liveUser = [[BXLiveUser alloc]init];
            [liveUser updateWithJsonDic:dic];
            [models addObject:liveUser];
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//用户英雄榜
+ (void)getHeroesRankWithInterval:(NSString *)interval
                           offset:(NSString *)offset
                          success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"interval":[self stringNoNil:interval],  @"offset":[self stringNoNil:offset]};
    [[NewHttpManager sharedNetManager] POST:@"s=Millet.getHeroesRank" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSDictionary *dataDic = responseObject[@"data"];
        NSDictionary *listDic = dataDic[@"list"];
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in listDic) {
            BXLiveUser *liveUser = [[BXLiveUser alloc]init];
            [liveUser updateWithJsonDic:dic];
            [models addObject:liveUser];
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//主播魅力榜
+ (void)getCharmRankWithInterval:(NSString *)interval
                         offset:(NSString *)offset
                         success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"interval":[self stringNoNil:interval], @"offset":[self stringNoNil:offset]};
    [[NewHttpManager sharedNetManager] POST:@"s=Millet.getCharmRank" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSDictionary *dataDic = responseObject[@"data"];
        NSDictionary *listDic = dataDic[@"list"];
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in listDic) {
            BXLiveUser *liveUser = [[BXLiveUser alloc]init];
            [liveUser updateWithJsonDic:dic];
            [models addObject:liveUser];
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//守护列表
+ (void)guardListWithUserId:(NSString *)userId
                 success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"user_id":[self stringNoNil:userId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.guardList" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//背包
+ (void)getPropsGetUserPropsByPackSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                  failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] POST:@"s=Props.getUserPackage" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        if (flag) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                BXGift *gift = [[BXGift alloc]init];
                gift.giftType = @"2";
                [gift updateWithJsonDic:dic];
                [models addObject:gift];
            }
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//礼物列表
+ (void)getLiveGiftSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=Gift.getLiveGift&api_v=v2" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        if (flag) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                BXGift *gift = [[BXGift alloc]init];
                gift.giftType = @"1";
                [gift updateWithJsonDic:dic];
                [models addObject:gift];
            }
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//礼物资源列表
+ (void)onlineGiftsWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=Gift.getGiftResources" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}



//获取直播频道
+ (void)liveChannelWithParentId:(NSString *)parentId
                        success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"parent_id":[self stringNoNil:parentId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.liveChannel" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            BXLiveChannel *liveChannel = [[BXLiveChannel alloc]init];
            [liveChannel updateWithJsonDic:dic];
            [models addObject:liveChannel];
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//歌词报错
+ (void)musicLrcReportWithMusicId:(NSString *)musicId
                          success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"music_id":[self stringNoNil:musicId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Music.lrcReport" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//云信-获取用户信息
+ (void)yunXinGetUser:(NSString *)userId Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 failure:(void(^)(NSError *error))failure{
    NSDictionary *paramsDic = @{@"user_id":[self stringNoNil:userId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Yunxin.getUser" parameters:paramsDic success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//移出黑名单
+ (void)blacklistDeleteWithUserId:(NSString *)userId
                          success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"user_id":[self stringNoNil:userId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Blacklist.delete" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//加入黑名单
+ (void)blacklistAddWithUserId:(NSString *)userId
                       success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"user_id":[self stringNoNil:userId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Blacklist.add" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//粉丝列表
+ (void)fansListWithUserId:(NSString *)userId
                      offset:(NSString *)offset
                   success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"user_id":[self stringNoNil:userId],@"offset":[self stringNoNil:offset]};
    [[NewHttpManager sharedNetManager] POST:@"s=Follow.fansList&api_v=v2" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            BXLiveUser *liveUser = [[BXLiveUser alloc]init];
            [liveUser updateWithJsonDic:dic];
            [models addObject:liveUser];
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//关注列表
+ (void)followListWithUserId:(NSString *)userId
                      offset:(NSString *)offset
                      length:(NSString *)length
                     success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"user_id":[self stringNoNil:userId],@"offset":[self stringNoNil:offset],@"length":[self stringNoNil:length]};
    [[NewHttpManager sharedNetManager] POST:@"s=Follow.followList" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            BXLiveUser *liveUser = [[BXLiveUser alloc]init];
            [liveUser updateWithJsonDic:dic];
            [models addObject:liveUser];
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//附近列表
+ (void)nearByLiveListWithOffset:(NSString *)offset
                          length:(NSString *)length
                          gender:(NSString *)gender age:(NSString *)age city_lng:(NSString *)city_lng city_lat:(NSString *)city_lat
                            city:(NSString *)city
                         success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         failure:(void(^)(NSError *error))failure {
    
//    MMKV *mkv = [MMKV defaultMMKV];
////
//    NSString *gender = [mkv getStringForKey:@"nearby_gender"];
//    if (!gender) {
//        gender = @"0";
//    }
//    NSString *age = [mkv getStringForKey:@"nearby_age"];
//    if (!age) {
//        age = @"0";
//    }
////    经度
//    NSString *city_lng = [mkv getStringForKey:@"nearby_city_lng"];
//    if (!city_lng) {
//        city_lng = @"0";
//    }
////    纬度
//    NSString *city_lat = [mkv getStringForKey:@"nearby_city_lat"];
//    if (!city_lat) {
//        city_lat = @"0";
//    }
////    城市
//    NSString *city = [mkv getStringForKey:@"nearby_city"];
//    if (!city) {
//        city = @"0";
//    }
    
    NSDictionary *params = @{@"offset":[self stringNoNil:offset],@"length":[self stringNoNil:length],@"api_v":@"v2"};
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [allParams setObject:gender forKey:@"sex"];
    [allParams setObject:age forKey:@"age"];
    [allParams setObject:city_lng forKey:@"lng"];
    [allParams setObject:city_lat forKey:@"lat"];
    [allParams setObject:city forKey:@"city"];
    
    [[NewHttpManager sharedNetManager] POST:@"s=Room.nearbyLiveList&api_v=v2" parameters:allParams success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        if (flag) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                BXSLLiveRoom *liveRoom = [[BXSLLiveRoom alloc]init];
                [liveRoom updateWithJsonDic:dic];
                [models addObject:liveRoom];
            }
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//直播分类列表
+ (void)liveclassificationListWithOffset:(NSString *)offset
                                  length:(NSString *)length
                               navType:(NSString *)navType
                               success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                               failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"offset":[self stringNoNil:offset],@"length":[self stringNoNil:length], @"nav_type":[self stringNoNil:navType],@"api_v":@"v2"};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.liveList&api_v=v2" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        if (flag) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                BXSLLiveRoom *liveRoom = [[BXSLLiveRoom alloc]init];
                [liveRoom updateWithJsonDic:dic];
                [models addObject:liveRoom];
            }
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//热门列表
+ (void)hotLiveListWithOffset:(NSString *)offset
                       length:(NSString *)length
                    success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                    failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"offset":[self stringNoNil:offset],@"length":[self stringNoNil:length],@"api_v":@"v2"};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.getHotLiveList&api_v=v2" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//直播头条
+ (void)getArticleListWithOffset:(NSString *)offset
                         success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                         failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"offset":[self stringNoNil:offset]};
    [[NewHttpManager sharedNetManager] POST:@"s=Article.getArticleList" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//消息主菜单
+ (void)indexNewWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                    failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=Message.index&api_v=v3" parameters:@{@"api_v":@"v3", @"have_shopMall": @"1"} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//最新列表
+ (void)newLiveListWithOffset:(NSString *)offset
                       length:(NSString *)length
                    success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                    failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"offset":[self stringNoNil:offset],@"length":[self stringNoNil:length],@"api_v":@"v2"};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.newLiveList&api_v=v2" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        NSMutableArray *models = [NSMutableArray array];
        if (flag) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                BXSLLiveRoom *liveRoom = [[BXSLLiveRoom alloc]init];
                [liveRoom updateWithJsonDic:dic];
                [models addObject:liveRoom];
            }
        }
        success(responseObject,flag,models);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//实名认证
+ (void)verificationWithName:(NSString *)name
                    card_num:(NSString *)card_num
                 idcard_type:(NSString *)idcard_type
                 hand_idcard:(NSString *)hand_idcard
                front_idcard:(NSString *)front_idcard
                 back_idcard:(NSString *)back_idcard
                   is_anchor:(NSString *)is_anchor
                     success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure; {
    NSDictionary *params = @{@"name":[self stringNoNil:name], @"card_num":[self stringNoNil:card_num], @"idcard_type":[self stringNoNil:idcard_type], @"hand_idcard":[self stringNoNil:hand_idcard], @"front_idcard":[self stringNoNil:front_idcard], @"back_idcard":[self stringNoNil:back_idcard], @"is_anchor":[self stringNoNil:is_anchor]};
    [[NewHttpManager sharedNetManager] POST:@"s=User.verification&api_v=v2" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//下次修改昵称时间
+ (void)nextRenickTimeWithSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=User.nextRenickTime" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
//获取后台所有标签
+(void)GetAllImpressionSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=User.getAllImpression" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+(void)SaveUserIpmpressWithids:(NSString *)ids
                       success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=User.saveUserImpression" parameters:@{@"ids":[self stringNoNil:ids]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma - mark 会员中心

+(void)GetuserImpressionSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=User.getUserImpression" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//获取验证码
+ (void)sendSmsCodeWithPhone:(NSString *)phone
                       scene:(NSString *)scene
                   phoneCode:(NSString *)phoneCode
                     success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"phone":[self stringNoNil:phone],@"scene":[self stringNoNil:scene],@"phone_code":[self stringNoNil:phoneCode]};
    [[NewHttpManager sharedNetManager] POST:@"s=Common.sendSmsCode" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//绑定第三方账号
+ (void)bindThirdWithType:(NSString *)type
                   openid:(NSString *)openid
                 nickname:(NSString *)nickname
                   avatar:(NSString *)avatar
                   gender:(NSString *)gender
                     uuid:(NSString *)uuid
                  success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"type":[self stringNoNil:type],@"openid":[self stringNoNil:openid],@"nickname":[self stringNoNil:nickname],@"avatar":[self stringNoNil:avatar],@"gender":[self stringNoNil:gender],@"uuid":[self stringNoNil:uuid]};
    [[NewHttpManager sharedNetManager] POST:@"s=User.bindThird" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//修改或设置密码
+ (void)changePwdWithPassword:(NSString *)password
                 old_password:(NSString *)old_password
             confirm_password:(NSString *)confirm_password
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"password":[self stringNoNil:password],@"old_password":[self stringNoNil:old_password],@"confirm_password":[self stringNoNil:confirm_password]};
    [[NewHttpManager sharedNetManager] POST:@"s=User.changePwd" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//绑定手机号(非第三方登录)
+ (void)bindPhoneNumWithPhone:(NSString *)phone
                         code:(NSString *)code
                    phoneCode:(NSString *)phoneCode
                      success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"code":[self stringNoNil:code],@"phone":[self stringNoNil:phone],@"phone_code":[self stringNoNil:phoneCode]};
    [[NewHttpManager sharedNetManager] POST:@"s=User.bindPhone" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//用户名密码登录
+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                phoneCode:(NSString *)phoneCode
                  success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"username":[self stringNoNil:userName],@"password":[self stringNoNil:password],@"phone_code":[self stringNoNil:phoneCode]};
    [[NewHttpManager sharedNetManager] POST:@"s=Account.login" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//重置密码
+ (void)resetPwdWithPassword:(NSString *)password
             confirmPassword:(NSString *)confirmPassword
                        code:(NSString *)code
                       phone:(NSString *)phone
                   phoneCode:(NSString *)phoneCode
                     success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"password":[self stringNoNil:password],@"confirm_password":[self stringNoNil:confirmPassword],@"code":[self stringNoNil:code],@"phone":[self stringNoNil:phone],@"phone_code":[self stringNoNil:phoneCode]};
    [[NewHttpManager sharedNetManager] POST:@"s=Account.resetPwd" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//检查直播间
+ (void)verifyRoomWithRoomId:(NSString *)roomId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"room_id":[self stringNoNil:roomId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.verifyRoom" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//进入直播间
+ (void)enterRoomWithRoomId:(NSString *)roomId password:(NSString *)password success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"room_id":[self stringNoNil:roomId],@"password":[self stringNoNil:password]};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.enterRoom" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//查询用户信息（弹窗用)
+ (void)liveUserPopWithRoomId:(NSString *)roomId userId:(NSString *)userId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"room_id":[self stringNoNil:roomId],@"user_id":[self stringNoNil:userId],@"api_v":@"v2"};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.liveUserPop&api_v=v2" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//踢人
+ (void)kickingWithRoomId:(NSString *)roomId userId:(NSString *)userId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"room_id":[self stringNoNil:roomId],@"user_id":[self stringNoNil:userId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.kicking" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//禁言
+ (void)shutSpeakWithRoomId:(NSString *)roomId userId:(NSString *)userId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"room_id":[self stringNoNil:roomId],@"user_id":[self stringNoNil:userId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.shutSpeak" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
//场控
+ (void)manageSwitchWithUserId:(NSString *)userId anchorId:(NSString *)anchorId success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"user_id":[self stringNoNil:userId], @"anchor_id":[self stringNoNil:anchorId]};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.manageSwitch" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//获取手机区号
+ (void)getPhoneCodesSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     failure:(void(^)(NSError *error))failure {
    [[NewHttpManager sharedNetManager] POST:@"s=Common.getPhoneCodes" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

@end


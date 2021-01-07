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

#import "BXAppInfo.h"
#import "SLAppInfoMacro.h"
#import "SLAppInfoConst.h"
#import "BXKTVHTTPCacheManager.h"
#import "BXSavePhotoHelper.h"

#import <Bugly/Bugly.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
//#import "BXKTVHTTPCacheManager.h"
#import <UIKit/UIKit.h>


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
                [BXVideoWatcerHelp watermarkingWithVideoUrl:filePath waterImg:[BXAppInfo appInfo].water_marker text:[NSString stringWithFormat:@"ID：%@",userId] isShow:YES completion:^(NSString * _Nonnull videofilePath) {
                    [BXSavePhotoHelper savePhotos:videofilePath completion:^(NSError *error) {
                        [FilePathHelper removeFileAtPath:videofilePath];
                    }];
                    [FilePathHelper removeFileAtPath:[filePath path]];
                } isSystem:YES];
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

@end


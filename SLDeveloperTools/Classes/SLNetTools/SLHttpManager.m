//
//  SLHttpManager.m
//  BXlive
//
//  Created by sweetloser on 2021/1/6.
//  Copyright © 2021 cat. All rights reserved.
//

#import "SLHttpManager.h"
#import <AFNetworking/AFNetworking.h>
#import "../SLCategory/SLCategory.h"
#import "../SLUtilities/SLUtilities.h"

@interface SLHttpManager()

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic,assign) AFNetworkReachabilityStatus netStatus;

@end

@implementation SLHttpManager

static SLHttpManager *manager = nil;
+(instancetype)sl_sharedNetManager{
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
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.sessionManager.requestSerializer.timeoutInterval =60;
        self.sessionManager.securityPolicy.validatesDomainName = NO;
        //添加header头信息
        
        //监控网络变化
        self.netStatus = 1;
        [self checkingNetworkResult];
    }
    return self;
}

#pragma mark - post请求
- (void)sl_post:(NSString *)url parameters:(NSDictionary * __nullable)parameters success:(SL_NetSuccess)success failure:(SL_NetFailure)failure;
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            显示网络请求时状态栏的小菊花
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
    }
    if (self.netStatus > 0) {
        
        [self.sessionManager POST:url parameters:parameters headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
//            取消 状态栏 小菊花
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (failure) {
                error.isNetWorkConnectionAvailable = YES;
                failure(error);
            }
        }];
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSURLErrorKey:@"netStatus error"}];
        error.isNetWorkConnectionAvailable = YES;
        failure(error);
    }
}

#pragma mark - 上传图片
/**
 封装POST图片上传(多张图片)
 
 @param operations   请求的参数
 @param imageArray   存放图片的数组
 @param urlString    请求的链接
 @param isShow       是否显示进度
 @param successBlock 发送成功的回调
 @param failureBlock 发送失败的回调
 */
- (void)sl_uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withUrlString:(NSString *)urlString withProgress:(SL_NetProgress)progress withSuccessBlock:(SL_NetSuccess)successBlock withFailurBlock:(SL_NetFailure)failureBlock{
    
    if (self.netStatus > 0) {
        [self.sessionManager POST:urlString parameters:operations headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            /*! 出于性能考虑,将上传图片进行压缩 */
            for (int i=0; i<imageArray.count; i++) {
                
                if ([imageArray[i] isKindOfClass:[UIImage class]]) {
                    UIImage * image = imageArray[i];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    // 设置时间格式
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *str = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",str,((arc4random() % 501) + 500)];
              
                    image = [UIImage imageCompressWithSourceImage:image MaxWidth:1024 MaxHeight:1024];
                    NSData *imgData = UIImageJPEGRepresentation(image, 0.7);
                    //拼接data
                    if (imgData != nil) {
                        [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/jpg"];
                    }
                }
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            if (progress) {
                progress(uploadProgress);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}

#pragma mark - 上传图片和视频
-(void)sl_UploadImageAndVideo:(NSString *)urlString Operations:(NSDictionary *)operations FileArray:(NSArray *)FileArray withProgress:(SL_NetProgress)progress success:(SL_NetSuccess)success failure:(SL_NetFailure)failure{
    
    if (self.netStatus > 0) {

        [self.sessionManager POST:urlString parameters:operations headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            /*! 出于性能考虑,将上传图片进行压缩 */
            for (int i=0; i<FileArray.count; i++) {
                
                //判断是否为照片
                if ([FileArray[i] isKindOfClass:[UIImage class]]) {
                    UIImage * image = FileArray[i];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    // 设置时间格式
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *str = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",str,((arc4random() % 501) + 500)];
              
                    image = [UIImage imageCompressWithSourceImage:image MaxWidth:1024 MaxHeight:1024];
                    //使用文件流上传
                    NSData *imgData = UIImageJPEGRepresentation(image, 0.7);
                    //拼接data
                    if (imgData != nil) {
                        [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/jpg"];
                    }

                } else if ([FileArray[i] isKindOfClass:[NSURL class]]) {    //判断是否为视频
                    NSData * videoData = [NSData dataWithContentsOfURL:FileArray[i]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    // 设置时间格式
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *str = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString stringWithFormat:@"%@%d.mp4",str,((arc4random() % 501) + 500)];
                    //拼接data
                    if (videoData != nil) {
                        [formData appendPartWithFileData:videoData name:@"file" fileName:fileName mimeType:@"video/mp4"];
                    }
                }
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

#pragma mark - 下载视频
-(void)sl_downloadVideoWithURL:(NSURL *)videoUrl progress:(SL_NetProgress)progress destination:(SL_destinationBlock)destination completionHandler:(SL_downLoadCompletionHandler)completionHandler{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:videoUrl];
    NSURLSessionTask *downloadTask=[self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (destination) {
            return destination(targetPath,response);
        }
        
        //默认存储路径
        NSString *fileName = [videoUrl lastPathComponent];
        NSString *filePath = [FilePathHelper getCachesPath];
        filePath = [filePath stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (completionHandler) {
            completionHandler(response,filePath,error);
        }
        
    }];
    [downloadTask resume];
}

#pragma mark - 监测网络变化
- (void)checkingNetworkResult {
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    __block typeof(self) weakSelf = self;
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.netStatus = status;
    }];
}

@end

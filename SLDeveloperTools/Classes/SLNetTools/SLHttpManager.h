//
//  SLHttpManager.h
//  BXlive
//
//  Created by sweetloser on 2021/1/6.
//  Copyright © 2021 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SL_NetProgress)(NSProgress * _Nonnull progress);        // 上传文件进度
typedef void (^SL_NetSuccess)(id _Nullable responseObject);     // 成功Block
typedef void (^SL_NetFailure)(NSError * _Nonnull error);        // 失败Blcok
typedef void (^SL_downLoadCompletionHandler)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error);        // 下载完成Block
typedef NSURL *_Nonnull(^SL_destinationBlock)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response);        // 下载文件存放路径Block

NS_ASSUME_NONNULL_BEGIN

@interface SLHttpManager : NSObject

+ (instancetype)sl_sharedNetManager;

- (void)sl_post:(NSString *)url parameters:(NSDictionary * __nullable)parameters success:(SL_NetSuccess)success failure:(SL_NetFailure)failure;

- (void)sl_uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withUrlString:(NSString *)urlString withProgress:(SL_NetProgress)progress withSuccessBlock:(SL_NetSuccess)successBlock withFailurBlock:(SL_NetFailure)failureBlock;

/**
 */
-(void)sl_UploadImageAndVideo:(NSString *)urlString Operations:(NSDictionary *)operations FileArray:(NSArray *)FileArray withProgress:(SL_NetProgress)progress success:(SL_NetSuccess)success failure:(SL_NetFailure)failure;

-(void)sl_downloadVideoWithURL:(NSURL *)videoUrl progress:(SL_NetProgress)progress destination:(SL_destinationBlock)destination completionHandler:(SL_downLoadCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END

//
//  SLUpLoadAndDownloadTools.h
//  SLDeveloperTools
//
//  Created by sweetloser on 2021/1/12.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface SLUpLoadAndDownloadTools : NSObject
#pragma mark - 上传文件 == 七牛云
+ (void)getQiNiuAccessTokenWithType:(NSString *)type
                           fileName:(NSString *)fileName
                            success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            failure:(void(^)(NSError *error))failure;

+ (void)uploadFileWithType:(NSString *)type
                  filePath:(NSString *)filePath success:(void (^)(NSDictionary *, BOOL, NSMutableArray *))success
                   failure:(void (^)(NSError *))failure;
+ (void)uploadFileWithType:(NSString *)type
                  fileName:(NSString *)fileName
                      data:(NSData *)data
                   success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   failure:(void(^)(NSError *error))failure;

#pragma mark- 下载文件
+ (NSURLSessionDownloadTask *)downloadFileWithUrlString:(NSString *)urlString
                                               filePath:(NSString *)filePath
                                                success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                                failure:(void(^)(NSError *error))failure;
#pragma mark - tool
+ (NSString *)stringNoNil:(NSString *)str;
@end

NS_ASSUME_NONNULL_END

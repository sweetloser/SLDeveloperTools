//
//  SLUpLoadAndDownloadTools.m
//  SLDeveloperTools
//
//  Created by sweetloser on 2021/1/12.
//

#import "SLUpLoadAndDownloadTools.h"
#import "NewHttpManager.h"
#import <Qiniu/QiniuSDK.h>
#import <AFNetworking/AFNetworking.h>

@implementation SLUpLoadAndDownloadTools

#pragma - mark 上传文件
+ (void)getQiNiuAccessTokenWithType:(NSString *)type
                           fileName:(NSString *)fileName
                            success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            failure:(void(^)(NSError *error))failure {
    NSDictionary *params = @{@"type":[self stringNoNil:type],@"filename":[self stringNoNil:fileName]};
    [[NewHttpManager sharedNetManager] POST:@"s=Common.getQiniuToken" parameters:params success:^(id  _Nonnull responseObject) {
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

+ (void)uploadFileWithType:(NSString *)type
                  filePath:(NSString *)filePath success:(void (^)(NSDictionary *, BOOL, NSMutableArray *))success
                   failure:(void (^)(NSError *))failure {
    NSString *fileName = [filePath lastPathComponent];
    [self getQiNiuAccessTokenWithType:type fileName:fileName success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            NSDictionary *dataDic = jsonDic[@"data"];
            NSString *key = dataDic[@"key"];
            NSString *token = dataDic[@"token"];
            NSString *base = dataDic[@"base"];
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
        
            [upManager putFile:filePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                BOOL flag = NO;
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if ([info isOK] && key) {
                    flag = YES;
                    [dic setValue:@"0" forKey:@"resultCode"];
                    NSString *filePath = [NSString stringWithFormat:@"%@/%@",base,key];
                    [dic setValue:filePath forKey:@"filePath"];
                }
                success(dic,flag,nil);
            } option:uploadOption];
        }  else {
            success(nil,NO,nil);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)uploadFileWithType:(NSString *)type
                  fileName:(NSString *)fileName
                      data:(NSData *)data
                   success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   failure:(void(^)(NSError *error))failure {
    [self getQiNiuAccessTokenWithType:type fileName:fileName success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            NSDictionary *dataDic = jsonDic[@"data"];
            NSString *key = dataDic[@"key"];
            NSString *token = dataDic[@"token"];
            NSString *base = dataDic[@"base"];
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
            [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                BOOL flag = NO;
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if ([info isOK] && key) {
                    flag = YES;
                    [dic setValue:@"0" forKey:@"resultCode"];
                    NSString *filePath = [NSString stringWithFormat:@"%@/%@",base,key];
                    [dic setValue:filePath forKey:@"filePath"];
                }
                success(dic,flag,nil);
            } option:uploadOption];
        }  else {
            success(nil,NO,nil);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark- 下载文件
+ (NSURLSessionDownloadTask *)downloadFileWithUrlString:(NSString *)urlString
                                               filePath:(NSString *)filePath
                                                success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                                failure:(void(^)(NSError *error))failure {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
//    有中文的链接，需要编码
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
//        NSLog(@"%lld----%lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        
    }  destination:^NSURL*(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *filePathURL = [NSURL fileURLWithPath:filePath];
        return filePathURL;
    } completionHandler:^(NSURLResponse *response, NSURL*filePath, NSError *error) {
        
        if (error) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath.path error:&error];
            }
            failure(error);
        }else{
            success(nil,YES,nil);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}

+ (NSString *)stringNoNil:(NSString *)str {
    if (str) {
        return str;
    } else {
        return @"";
    }
}
@end

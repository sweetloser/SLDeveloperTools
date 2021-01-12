//
//  TIDownloadZipManager.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/10.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TIDownloadZipManager.h"

//#import <SSZipArchive.h>
#import <SSZipArchive/SSZipArchive.h>

//#import "TiSDKInterface.h"
#import <TiSDK/TiSDKInterface.h>

@interface TIDownloadZipManager ()<NSURLSessionDelegate,SSZipArchiveDelegate>

@property(nonatomic,copy)void(^completeBlock)(BOOL successful);

@property(nonatomic, strong) NSURLSession *session;

@end


static TIDownloadZipManager *shareManager = NULL;
//static dispatch_once_t token;

@implementation TIDownloadZipManager

// MARK: --单例初始化方法--
+ (TIDownloadZipManager *)shareManager {
//    dispatch_once(&token, ^{
        shareManager = [[TIDownloadZipManager alloc] init];
//    });
    return shareManager;
}
+(void)releaseShareManager{
//   token = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
//   [shareManager release];
//   shareManager = nil;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session =
                [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}




- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)downloadSuccessedType:(DownloadedType)type MenuMode:(TIMenuMode *)mode completeBlock:(void(^)(BOOL successful))completeBlock{
   
    NSString *downloadURL = @"";
    NSString *cachePaths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    switch (type) {
        case TI_DOWNLOAD_TYPE_Sticker:
             downloadURL = [[TiSDK getStickerURL] stringByAppendingFormat:@"%@.zip",mode.name];
            cachePaths =  [cachePaths stringByAppendingFormat:@"/sticker"];
            
            break;
            case TI_DOWNLOAD_STATE_Gift:
             downloadURL = [[TiSDK getGiftURL] stringByAppendingFormat:@"%@.zip",mode.name];
            cachePaths =  [cachePaths stringByAppendingFormat:@"/gift"];
            
                       break;
            case TI_DOWNLOAD_STATE_Watermark:
             downloadURL = [[TiSDK getWatermarkURL] stringByAppendingFormat:@"%@.zip",mode.name];
            cachePaths =  [cachePaths stringByAppendingFormat:@"/watermark"];
            
                       break;
            case TI_DOWNLOAD_STATE_Mask:
             downloadURL = [[TiSDK getMaskURL] stringByAppendingFormat:@"%@.zip",mode.name];
            cachePaths =  [cachePaths stringByAppendingFormat:@"/mask"];
            
                       break;
            case TI_DOWNLOAD_STATE_Lvmu:
             downloadURL = [[TiSDK getGreenScreenURL] stringByAppendingFormat:@"%@.zip",mode.name];
            cachePaths =  [cachePaths stringByAppendingFormat:@"/greenscreen"];
            
                       break;
            case TI_DOWNLOAD_STATE_Interactions:
             downloadURL = [[TiSDK getInteractionURL] stringByAppendingFormat:@"%@.zip",mode.name];
            cachePaths =  [cachePaths stringByAppendingFormat:@"/interaction"];
            
                       break;
        default:
            break;
    }
  
    [[self.session downloadTaskWithURL:[NSURL URLWithString:downloadURL] completionHandler:^(NSURL *_Nullable location, NSURLResponse *_Nullable response, NSError *_Nullable error) {

        if (error) {
              NSLog(@"downloadURL  %@ -- error %@",downloadURL,error);
              dispatch_async(dispatch_get_main_queue(), ^{
                                   // UI更新代码
                     if (completeBlock) {
                         completeBlock(NO);
                     }
                     });
        } else {
            
//            [SSZipArchive unzipFileAtPath:location.path toDestination:cachePaths delegate:self];
            
            __block NSString *completePath = cachePaths;
            [SSZipArchive unzipFileAtPath:location.path toDestination:cachePaths progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                
                } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                                             // UI更新代码
                               if (path&&succeeded) {
                                   
                                        completePath =  [[completePath componentsSeparatedByString:@"/"] lastObject];
                                                completePath = [completePath stringByAppendingFormat:@"/%@",mode.name];
                                          
                                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                [defaults setObject:completePath forKey:[NSString stringWithFormat:@"%@%ld",mode.name,(long)mode.menuTag]];
                                                [defaults synchronize];
                                                
                                                   // UI更新代码
                                                   if (completeBlock) {
                                                          completeBlock(YES);
                                                       }
                                  }else{
                                            // UI更新代码
                                                if (completeBlock) {
                                                      completeBlock(NO);
                                                  }
                                  }
                               });
                    
                }];
             
            
        }
    }] resume];
     
    
//    [self setCompleteBlock:^(BOOL successful) {
//        if (successful)
//        {
//            completePath =  [[completePath componentsSeparatedByString:@"/"] lastObject];
//            completePath = [completePath stringByAppendingFormat:@"/%@",mode.name];
//
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:completePath forKey:[NSString stringWithFormat:@"%@%ld",mode.name,(long)mode.menuTag]];
//            [defaults synchronize];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//               // UI更新代码
//               if (completeBlock) {
//                      completeBlock(YES);
//                   }
//            });
//
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                          // UI更新代码
//            if (completeBlock) {
//                completeBlock(NO);
//            }
//            });
//        }
//    }];
    
}
 

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];

        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark - Unzip complete callback
//- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
//    dispatch_async(dispatch_get_main_queue(), ^{
//                           // UI更新代码
//             if (path&&unzippedPath) {
//                    self.completeBlock(YES);
//                }else{
//                    self.completeBlock(NO);
//                }
//             });
//
//
//}


@end

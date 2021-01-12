//
//  TiSDKResourceManager.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/10.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiSDKResourceManager.h"

@interface TiSDKResourceManager ()

@end

@implementation TiSDKResourceManager


static TiSDKResourceManager *shareManager = nil;
static dispatch_once_t token;

// MARK: --单例初始化方法--
+ (TiSDKResourceManager *)shareManager {
    dispatch_once(&token, ^{
        shareManager = [[TiSDKResourceManager alloc] init];
    });
    return shareManager;
}
+(void)releaseShareManager{
   token = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
//   [shareManager release];
   shareManager = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *stickerPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sticker"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:stickerPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:stickerPath withIntermediateDirectories:NO attributes:nil error:nil];
                }
          
        NSString *giftPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"gift"];
                       if (![[NSFileManager defaultManager] fileExistsAtPath:giftPath]) {
                           [[NSFileManager defaultManager] createDirectoryAtPath:giftPath withIntermediateDirectories:NO attributes:nil error:nil];
                       }
        
       NSString *watermarkPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"watermark"];
         if (![[NSFileManager defaultManager] fileExistsAtPath:watermarkPath]) {
             [[NSFileManager defaultManager] createDirectoryAtPath:watermarkPath withIntermediateDirectories:NO attributes:nil error:nil];
         }
        
        NSString *maskPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"mask"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:maskPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:maskPath withIntermediateDirectories:NO attributes:nil error:nil];
                }
        NSString *lvmuPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"greenscreen"];
                       if (![[NSFileManager defaultManager] fileExistsAtPath:lvmuPath]) {
                           [[NSFileManager defaultManager] createDirectoryAtPath:lvmuPath withIntermediateDirectories:NO attributes:nil error:nil];
                       }
        

        // 拷贝本地贴纸文件到沙盒
        NSString *localPath1 =
        [[[NSBundle mainBundle] pathForResource:@"TiSDKResource" ofType:@"bundle"] stringByAppendingPathComponent:@"sticker"];
        NSArray *dirArr1 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath1 error:NULL];
        for (NSString *pathName in dirArr1) {
            if (![[NSFileManager defaultManager] fileExistsAtPath:[localPath1 stringByAppendingPathComponent:pathName]]) {
                [[NSFileManager defaultManager] copyItemAtPath:[localPath1 stringByAppendingPathComponent:pathName] toPath:[localPath1 stringByAppendingPathComponent:pathName] error:NULL];
            }
        }
        // 拷贝本地礼物文件到沙盒
        NSString *localPath2 =
        [[[NSBundle mainBundle] pathForResource:@"TiSDKResource" ofType:@"bundle"] stringByAppendingPathComponent:@"gift"];
        NSArray *dirArr2 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath2 error:NULL];
        for (NSString *pathName in dirArr2) {
            if (![[NSFileManager defaultManager] fileExistsAtPath:[localPath2 stringByAppendingPathComponent:pathName]]) {
                [[NSFileManager defaultManager] copyItemAtPath:[localPath2 stringByAppendingPathComponent:pathName] toPath:[localPath2 stringByAppendingPathComponent:pathName] error:NULL];
            }
        }
        // 拷贝本地水印文件到沙盒
        NSString *localPath3 =
        [[[NSBundle mainBundle] pathForResource:@"TiSDKResource" ofType:@"bundle"] stringByAppendingPathComponent:@"watermark"];
        NSArray *dirArr3 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath3 error:NULL];
        for (NSString *pathName in dirArr3) {
            if (![[NSFileManager defaultManager] fileExistsAtPath:[localPath3 stringByAppendingPathComponent:pathName]]) {
                [[NSFileManager defaultManager] copyItemAtPath:[localPath3 stringByAppendingPathComponent:pathName] toPath:[localPath3 stringByAppendingPathComponent:pathName] error:NULL];
            }
        }
        // 拷贝本地面具文件到沙盒
        NSString *localPath4 =
        [[[NSBundle mainBundle] pathForResource:@"TiSDKResource" ofType:@"bundle"] stringByAppendingPathComponent:@"mask"];
        NSArray *dirArr4 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath4 error:NULL];
        for (NSString *pathName in dirArr4) {
            if (![[NSFileManager defaultManager] fileExistsAtPath:[localPath4 stringByAppendingPathComponent:pathName]]) {
                [[NSFileManager defaultManager] copyItemAtPath:[localPath4 stringByAppendingPathComponent:pathName] toPath:[localPath4 stringByAppendingPathComponent:pathName] error:NULL];
            }
        }
        // 拷贝本地绿幕文件到沙盒
               NSString *localPath5 =
               [[[NSBundle mainBundle] pathForResource:@"TiSDKResource" ofType:@"bundle"] stringByAppendingPathComponent:@"greenscreen"];
               NSArray *dirArr5 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath5 error:NULL];
               for (NSString *pathName in dirArr5) {
                   if (![[NSFileManager defaultManager] fileExistsAtPath:[localPath5 stringByAppendingPathComponent:pathName]]) {
                       [[NSFileManager defaultManager] copyItemAtPath:[localPath5 stringByAppendingPathComponent:pathName] toPath:[localPath5 stringByAppendingPathComponent:pathName] error:NULL];
                   }
               }
        
        // 拷贝本地互动贴纸文件到沙盒
                      NSString *localPath6 =
                      [[[NSBundle mainBundle] pathForResource:@"TiSDKResource" ofType:@"bundle"] stringByAppendingPathComponent:@"interaction"];
                      NSArray *dirArr6 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath6 error:NULL];
                      for (NSString *pathName in dirArr6) {
                          if (![[NSFileManager defaultManager] fileExistsAtPath:[localPath6 stringByAppendingPathComponent:pathName]]) {
                              [[NSFileManager defaultManager] copyItemAtPath:[localPath6 stringByAppendingPathComponent:pathName] toPath:[localPath6 stringByAppendingPathComponent:pathName] error:NULL];
                          }
                      }
        
        
    }
    return self;
}


@end

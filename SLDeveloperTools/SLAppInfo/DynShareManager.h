//
//  ShareManager.h
//  BXlive
//
//  Created by bxlive on 2018/4/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>

@interface DynShareManager : NSObject

+ (void)shareWithType:(NSString *)type anchor:(NSString *)anchor targetId:(NSString *)targetId roomId:(NSString *)roomId userId:(NSString *)userId currentVC:(UIViewController *)currentVC;

+ (void)shareWithShareType:(NSString *)shareType targetId:(NSString *)targetId title:(NSString *)title descr:(NSString *)descr thumb:(NSString *)thumb url:(NSString *)url share_key:(NSString *)share_key currentVC:(UIViewController *)currentVC shareCompletion:(void(^)(NSString *share_channel, NSError *error))shareCompletion;

+ (void)singleShareWithPlat:(UMSocialPlatformType)plat type:(NSString *)type  anchor:(NSString *)anchor targetId:(NSString *)targetId roomId:(NSString *)roomId userId:(NSString *)userId currentVC:(UIViewController *)currentVC;

@end

//
//  ShareManager.m
//  BXlive
//
//  Created by bxlive on 2018/4/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "DynShareManager.h"
#import "DynShareObject.h"
#import "DynShareView.h"
#import "NewHttpRequestPort.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoConst.h"

@implementation DynShareManager

+ (void)shareWithType:(NSString *)type anchor:(NSString *)anchor targetId:(NSString *)targetId roomId:(NSString *)roomId userId:(NSString *)userId currentVC:(UIViewController *)currentVC {
    [[NewHttpRequestPort sharedNewHttpRequestPort] shareGetParams:@{@"type":type,@"anchor":anchor,@"target_id":targetId,@"room_id":roomId,@"user_id":userId} Success:^(id responseObject) {
        if([responseObject[@"code"] integerValue] == 0) {
            NSDictionary *dataDic = responseObject[@"data"];
            if (dataDic && [dataDic isDictionary]) {
                [self shareWithShareType:type targetId:targetId title:dataDic[@"title"] descr:dataDic[@"descr"] thumb:dataDic[@"thumb"] url:dataDic[@"url"] share_key:dataDic[@"share_key"] currentVC:currentVC shareCompletion:nil];
            }
        }
    } Failure:^(NSError *error) {
        
    }];
}

+ (void)shareWithShareType:(NSString *)shareType targetId:(NSString *)targetId title:(NSString *)title descr:(NSString *)descr thumb:(NSString *)thumb url:(NSString *)url share_key:(NSString *)share_key currentVC:(UIViewController *)currentVC shareCompletion:(void (^)(NSString *, NSError *))shareCompletion {
    NSMutableArray *shareObjects = [NSMutableArray array];
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        DynShareObject *shareObject = [[DynShareObject alloc]init];
        shareObject.type = DynShareObjectTypeOfWechatSession;
        
        DynShareObject *otherShareObject = [[DynShareObject alloc]init];
        otherShareObject.type = DynShareObjectTypeOfWechatTimeLine;
        
        [shareObjects addObject:shareObject];
        [shareObjects addObject:otherShareObject];
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
        DynShareObject *shareObject = [[DynShareObject alloc]init];
        shareObject.type = DynShareObjectTypeOfQQ;
        
        DynShareObject *otherShareObject = [[DynShareObject alloc]init];
        otherShareObject.type = DynShareObjectTypeOfQzone;
        
        [shareObjects addObject:shareObject];
        [shareObjects addObject:otherShareObject];
    }
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Facebook]) {
        DynShareObject *shareObject = [[DynShareObject alloc]init];
        shareObject.type = DynShareObjectTypeOfFacebook;
        [shareObjects addObject:shareObject];
    }
    
    DynShareView *shareView = [[DynShareView alloc]initWithShareObjects:shareObjects];
    shareView.shareTo = ^(DynShareObjectType type) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建图片内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumb];
        //设置网页地址
        shareObject.webpageUrl = url;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        
        UMSocialPlatformType platformType = UMSocialPlatformType_QQ;
        if (type == DynShareObjectTypeOfQzone) {
            platformType = UMSocialPlatformType_Qzone;
        } else if (type == DynShareObjectTypeOfWechatSession) {
            platformType = UMSocialPlatformType_WechatSession;
        } else if (type == DynShareObjectTypeOfWechatTimeLine) {
            platformType = UMSocialPlatformType_WechatTimeLine;
        }else if (type == DynShareObjectTypeOfFacebook) {
            platformType = UMSocialPlatformType_Facebook;
        }
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentVC completion:^(id data, NSError *error) {
            NSString * platType = @"";
            if (platformType==UMSocialPlatformType_WechatSession) {
                platType = @"wx";
            }else if(platformType == UMSocialPlatformType_WechatTimeLine){
                platType = @"friends";
            }else if(platformType == UMSocialPlatformType_QQ){
                platType = @"qq";
            }else if(platformType == UMSocialPlatformType_Qzone){
                platType = @"qzone";
            }else if(platformType == UMSocialPlatformType_Facebook){
                platType = @"facebook";
            }
            
            NSString *nowId = nil;
            if (targetId && IsEquallString(shareType, @"film")) {
                nowId = targetId;
            }
            [self didShareWithError:error shareKey:share_key channel:platType type:shareType nowId:nowId];
            if (shareCompletion) {
                shareCompletion(platType, error);
            }
        }];
    };
    [shareView show];
}

+ (void)singleShareWithPlat:(UMSocialPlatformType)plat type:(NSString *)type  anchor:(NSString *)anchor targetId:(NSString *)targetId roomId:(NSString *)roomId userId:(NSString *)userId currentVC:(UIViewController *)currentVC {
    if ([NSString stringWithFormat:@"%@", targetId] == nil) {
        targetId = @"";
    }
    
    if ([type isEqualToString:@"isShop"]) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:userId descr:anchor thumImage:roomId];
        shareObject.webpageUrl = targetId;
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:plat messageObject:messageObject currentViewController:currentVC completion:^(id data, NSError *error) {
            NSString * platType;
            if (plat==UMSocialPlatformType_WechatSession) {
                platType = @"wx";
            }else if(plat == UMSocialPlatformType_WechatTimeLine) {
                platType = @"friends";
            }else if(plat == UMSocialPlatformType_QQ) {
                platType = @"qq";
            }else if(plat == UMSocialPlatformType_Qzone) {
                platType = @"qzone";
            }else if(plat == UMSocialPlatformType_Facebook) {
                platType = @"facebook";
            }
            NSString *nowId = nil;
            if (targetId && IsEquallString(type, @"film")) {
                nowId = targetId;
            }
            [self didShareWithError:error shareKey:@"" channel:platType type:type nowId:nowId];
        }];
        return;
    }
    
    [[NewHttpRequestPort sharedNewHttpRequestPort] shareGetParams:@{@"type":type,@"anchor":[NSString SLNONullorNil:anchor],@"target_id":targetId,@"room_id":[NSString SLNONullorNil:roomId],@"user_id":userId} Success:^(id responseObject) {
        if([responseObject[@"code"] integerValue] == 0) {
            NSDictionary *dataDic = responseObject[@"data"];
            if (dataDic && [dataDic isDictionary]) {
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:dataDic[@"title"] descr:dataDic[@"descr"] thumImage:dataDic[@"thumb"]];
                shareObject.webpageUrl = dataDic[@"url"];
                messageObject.shareObject = shareObject;
                
                [[UMSocialManager defaultManager] shareToPlatform:plat messageObject:messageObject currentViewController:currentVC completion:^(id data, NSError *error) {
                    NSString * platType;
                    if (plat==UMSocialPlatformType_WechatSession) {
                        platType = @"wx";
                    }else if(plat == UMSocialPlatformType_WechatTimeLine) {
                        platType = @"friends";
                    }else if(plat == UMSocialPlatformType_QQ) {
                        platType = @"qq";
                    }else if(plat == UMSocialPlatformType_Qzone) {
                        platType = @"qzone";
                    }else if(plat == UMSocialPlatformType_Sina) {
                        platType = @"weibo";
                    }
                    NSString *nowId = nil;
                    if (targetId && IsEquallString(type, @"film")) {
                        nowId = targetId;
                    }
                    [self didShareWithError:error shareKey:dataDic[@"share_key"] channel:platType type:type nowId:nowId];
                }];
            }
        }
    } Failure:^(NSError *error) {
        
    }];
}

+ (void)didShareWithError:(NSError *)error shareKey:(NSString *)shareKey channel:(NSString *)channel type:(NSString *)type nowId:(NSString *)nowId {
    if (error) {
        if (error.code == 2009) {
            [BGProgressHUD showInfoWithMessage:@"已取消分享" ];
        } else if (error.code == 2003) {
            [BGProgressHUD showInfoWithMessage:@"分享失败" ];
            [[NewHttpRequestPort sharedNewHttpRequestPort] shareShareResult:@{@"share_key":shareKey, @"status":@"2", @"share_channel":[NSString SLNONullorNil:channel]} Success:^(id responseObject) {
                
            } Failure:^(NSError *error) {
                
            }];
        }
    } else {
        [BGProgressHUD showInfoWithMessage:@"分享成功"];
        [[NewHttpRequestPort sharedNewHttpRequestPort] shareShareResult:@{@"share_key":shareKey, @"status":@"1", @"share_channel":channel} Success:^(id responseObject) {
            if (![responseObject[@"code"] integerValue]) {
                if (nowId) {
                    NSDictionary *dataDic = responseObject[@"data"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDidShareNotification object:nil userInfo:@{@"type":type, @"nowId":nowId, @"shareSum":dataDic[@"share_sum"]}];
                }
            }
        } Failure:^(NSError *error) {
            
        }];
    }
}

@end

//
//  SharePopViewManager.m
//  BXlive
//
//  Created by bxlive on 2019/3/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import "DynSharePopViewManager.h"
#import "DynShareObject.h"
#import "DynSharePopView.h"
#import "DynShareManager.h"
#import <UMShare/UMShare.h>
#import "ZZLActionSheetView.h"
#import "SLAppInfoMacro.h"

@interface DynSharePopViewManager ()<DynSharePopViewDelegate>
@property (copy, nonatomic) NSString *movieId;
@property (copy, nonatomic) NSString *user_Id;
@property (copy, nonatomic) NSString *is_zan;
@property (copy, nonatomic) NSString *likeNum;
@property (copy, nonatomic) NSString *is_collect;
@property (copy, nonatomic) NSString *is_follow;
@property (strong, nonatomic) UIViewController *vc;
@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString *share_type;
@end

@implementation DynSharePopViewManager

+ (void)shareWithVideoId:(NSString *)videoId user_Id:(NSString *)user_Id likeNum:(NSString *)likeNum is_zan:(NSString *)is_zan is_collect:(NSString *)is_collect is_follow:(NSString *)is_follow vc:(UIViewController *)vc type:(NSInteger)type share_type:(NSString *)share_type{
    DynSharePopViewManager *sharePopViewManage = [DynSharePopViewManager standardSharePopViewManager];
    sharePopViewManage.movieId = videoId;
    sharePopViewManage.user_Id = user_Id;
    sharePopViewManage.likeNum = likeNum;
    sharePopViewManage.is_zan  = is_zan;
    sharePopViewManage.is_collect = is_collect;
    sharePopViewManage.is_follow = is_follow;
    sharePopViewManage.vc = vc;
    sharePopViewManage.type = type;
    sharePopViewManage.share_type = share_type;
    [sharePopViewManage getData];
}

+ (DynSharePopViewManager *)standardSharePopViewManager {
    static dispatch_once_t onceToken;
    static DynSharePopViewManager *_sharePopViewManage = nil;
    dispatch_once(&onceToken, ^{
        _sharePopViewManage = [[DynSharePopViewManager alloc]init];
    });
    return _sharePopViewManage;
}

-(void)getData {
    NSMutableArray *topIconsNameArray = [NSMutableArray array];
    NSMutableArray *bottomIconsNameArray = [NSMutableArray array];
    
    BOOL wxIsInstall = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession];
    BOOL qqIsInstall = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ];
    
#ifdef ChongYouURL
    BOOL fbIsInstall = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Facebook];
    if (fbIsInstall) {
        DynShareObject *objct = [[DynShareObject alloc ] init];
        objct.normalType = DynShareObjectTypeOfFacebook;
        [topIconsNameArray addObject:objct];
    }
#endif
    
    if (wxIsInstall) {
        for (int i= 0; i < 2; i++) {
            DynShareObject *objct = [[DynShareObject alloc ] init];
            objct.normalType = i;
            [topIconsNameArray addObject:objct];
        }
    }
    if (qqIsInstall) {
        for (int i= 2; i < 4; i++) {
            DynShareObject *objct = [[DynShareObject alloc ] init];
            objct.normalType = i;
            [topIconsNameArray addObject:objct];
        }
    }
    
  
    DynSharePopView *pop = [[DynSharePopView alloc] initWithFrame:CGRectZero topIconsNameArray:topIconsNameArray bottomIconsNameArray:bottomIconsNameArray];
    pop.delegate = self;
    [pop show];
    
    
}

- (void)sharePopViewIndex:(NSInteger)index{
//    dynamic
    if (index == DynShareObjectTypeOfWechatSession) {
        [DynShareManager singleShareWithPlat:UMSocialPlatformType_WechatSession type:_share_type anchor:_is_follow targetId:_movieId roomId:_likeNum userId:_user_Id currentVC:_vc];
    }
    else if (index == DynShareObjectTypeOfWechatTimeLine) {
        [DynShareManager singleShareWithPlat:UMSocialPlatformType_WechatTimeLine type:_share_type anchor:_is_follow targetId:_movieId roomId:_likeNum userId:_user_Id currentVC:_vc];
    }
    else if (index == DynShareObjectTypeOfQQ) {
        [DynShareManager singleShareWithPlat:UMSocialPlatformType_QQ type:_share_type anchor:_is_follow targetId:_movieId roomId:_likeNum userId:_user_Id currentVC:_vc];
    }
    else if (index == DynShareObjectTypeOfQzone) {
        [DynShareManager singleShareWithPlat:UMSocialPlatformType_Qzone type:_share_type anchor:_is_follow targetId:_movieId roomId:_likeNum userId:_user_Id currentVC:_vc];
    }
#ifdef ChongYouURL
    else if (index == DynShareObjectTypeOfFacebook) {
        [DynShareManager singleShareWithPlat:UMSocialPlatformType_Facebook type:_share_type anchor:_is_follow targetId:_movieId roomId:_likeNum userId:_user_Id currentVC:_vc];
    }
#endif
    else{
        
    }
    
    
}

@end

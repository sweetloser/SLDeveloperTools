//
//  SharePopViewManager.h
//  BXlive
//
//  Created by bxlive on 2019/3/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynSharePopView.h"

@interface DynSharePopViewManager : NSObject

//type 0  首页
//type 1  关注
//type 2  我的上传. 个人中心

+ (void)shareWithVideoId:(NSString *)videoId user_Id:(NSString *)user_Id likeNum:(NSString *)likeNum is_zan:(NSString *)is_zan is_collect:(NSString *)is_collect is_follow:(NSString *)is_follow vc:(UIViewController *)vc type:(NSInteger)type share_type:(NSString*)share_type;

@end



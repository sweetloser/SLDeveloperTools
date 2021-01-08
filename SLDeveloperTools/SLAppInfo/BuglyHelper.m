//
//  BuglyHelper.m
//  BXlive
//
//  Created by bxlive on 16/8/22.
//  Copyright © 2016年 lei. All rights reserved.
//

#import "BuglyHelper.h"
#import <Bugly/BuglyConfig.h>
#import <Bugly/Bugly.h>
#import "BXLiveUser.h"
@implementation BuglyHelper

+(void)buglyHelper{
    //设置buglyID
    [Bugly startWithAppId:@"5bd42cf456"];
    //BuglyConfig
    BuglyConfig *ci = [[BuglyConfig alloc] init];
    //卡顿统计打开
    ci.blockMonitorEnable = YES;
    //非正常退出事件记录开关
    ci.unexpectedTerminatingDetectionEnable = YES;
    //渠道
    ci.channel = @"APP Store";
    //间隔时间
    ci.blockMonitorTimeout =10.f;
    
    BXLiveUser *liveUser = [BXLiveUser currentBXLiveUser];
    NSString *phone = liveUser.phone;
    NSString *user_id = liveUser.user_id;
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"%@--%@",user_id,phone]];
    [Bugly setTag:[user_id integerValue]];
    
    
}

@end

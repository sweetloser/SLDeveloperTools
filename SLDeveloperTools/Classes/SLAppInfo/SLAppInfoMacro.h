//
//  SLAppInfoMacro.h
//  Pods
//
//  Created by sweetloser on 2021/1/5.
//

#ifndef SLAppInfoMacro_h
#define SLAppInfoMacro_h

//秉信 测试 服务器
#define New_Http_Base_Url @"http://v1.live.libx.com.cn/api.php?"
#define New_Http_Base_Url_Without @"http://v1.live.libx.com.cn/api.php"

#define New_Http_Base_domain @"http://v1.live.libx.com.cn/"

#define New_Http_Base_make_friend @"http://v1.live.libx.com.cn/api/"

#define SL_HTTP_BASE_AMWAY_URL @"https://shop.libx.com.cn/"

#define SL_HTTP_BASE_API_URL @"https://shop.libx.com.cn/"

#define SL_HTTP_H5_URL @"http://shop.libx.com.cn/"
//比例
#define SCALE SCREEN_WIDTH / 375.0

#define ZZL(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//账号信息
//#define INIT_TOKEN               @"1a25bf6050ceed1a9303ab60a08fef0dee9d55cc"
#define INIT_TOKEN               @"2bc29158f230db6c2a7a6712e57de6e4b48116f2"

#define Version                  @"ios_100"
#define CHANNEL                  @"common"

#define leftW 33
#define leftwidth_y 143.5
#define leftwidth_n 110

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//定义拍摄短视频的最长&最短时间
#define MAX_RECORD_TIME             15.f
#define MIN_RECORD_TIME             5.f


#endif /* SLAppInfoMacro_h */

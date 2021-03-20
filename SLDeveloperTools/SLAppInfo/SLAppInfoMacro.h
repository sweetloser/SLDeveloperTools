//
//  SLAppInfoMacro.h
//  Pods
//
//  Created by sweetloser on 2021/1/5.
//

#ifndef SLAppInfoMacro_h
#define SLAppInfoMacro_h

//#define SiShiLiveURL  //肆拾直播

//#define BXLiveURL     //秉信互娱

//#define DaBaiLiveURL  //大白互娱

#define DuoLaLiveURL    //朵拉互娱

#ifdef SiShiLiveURL

#define New_Http_Base_Url @"http://api.40zhibopingtai.com/api.php?"
#define New_Http_Base_Url_Without @"http://api.40zhibopingtai.com/api.php"
#define New_Http_Base_domain @"http://api.40zhibopingtai.com/"
#define New_Http_Base_make_friend @"http://api.40zhibopingtai.com/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.40zhibopingtai.com/"
#define SL_HTTP_BASE_API_URL @"http://shop.40zhibopingtai.com/"
#define SL_HTTP_H5_URL @"http://shop.40zhibopingtai.com/"
#define SL_UNIVERSAL_LINK @"https://yq5km7.xinstall.top/tolink/"
#define ZC_KEY @""                  //智齿key

#endif

//秉信 测试 服务器
#ifdef BXLiveURL

#define New_Http_Base_Url @"http://v1.live.libx.com.cn/api.php?"
#define New_Http_Base_Url_Without @"http://v1.live.libx.com.cn/api.php"
#define New_Http_Base_domain @"http://v1.live.libx.com.cn/"
#define New_Http_Base_make_friend @"http://v1.live.libx.com.cn/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.libx.com.cn/"
#define SL_HTTP_BASE_API_URL @"http://shop.libx.com.cn/"
#define SL_HTTP_H5_URL @"http://shop.libx.com.cn/"
#define SL_UNIVERSAL_LINK @"https://6s9n03.xinstall.top/tolink/"
#define ZC_KEY @"0937ca53a36741d081f01297039d1060"                      //智齿key

#endif

//大白直播
#ifdef DaBaiLiveURL

#define New_Http_Base_Url @"http://api.dabaiyule.com/api.php?"
#define New_Http_Base_Url_Without @"http://api.dabaiyule.com/api.php"
#define New_Http_Base_domain @"http://api.dabaiyule.com/"
#define New_Http_Base_make_friend @"http://api.dabaiyule.com/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.libx.com.cn/"
#define SL_HTTP_BASE_API_URL @"http://shop.libx.com.cn/"
#define SL_HTTP_H5_URL @"http://shop.libx.com.cn/"
#define SL_UNIVERSAL_LINK @"https://7hlbqw.xinstall.top/tolink/"
#define ZC_KEY @"30287f0183124391a17849ac4eed7867"                      //智齿key
#endif

//朵拉互娱
#ifdef DuoLaLiveURL

#define New_Http_Base_Url @"http://api.hfseyscm.com/api.php?"
#define New_Http_Base_Url_Without @"http://api.hfseyscm.com/api.php"
#define New_Http_Base_domain @"http://api.hfseyscm.com/"
#define New_Http_Base_make_friend @"http://api.hfseyscm.com/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.libx.com.cn/"
#define SL_HTTP_BASE_API_URL @"http://shop.libx.com.cn/"
#define SL_HTTP_H5_URL @"http://shop.libx.com.cn/"
#define SL_UNIVERSAL_LINK @"https://7hlbqw.xinstall.top/tolink/"
#define ZC_KEY @"e85ba28f99df4e14957406b63e438653"                      //智齿key
#endif


//比例
#define SCALE SCREEN_WIDTH / 375.0

#define ZZL(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//账号信息
#define INIT_TOKEN               @"2bc29158f230db6c2a7a6712e57de6e4b48116f2"

//#define Version                  @"ios_100"
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

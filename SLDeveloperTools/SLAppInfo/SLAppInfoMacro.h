//
//  SLAppInfoMacro.h
//  Pods
//
//  Created by sweetloser on 2021/1/5.
//

#ifndef SLAppInfoMacro_h
#define SLAppInfoMacro_h

//#define SiShiLiveURL          //肆拾直播

//#define BXLiveURL             //秉信互娱

//#define DuoLaLiveURL          //朵拉互娱

//#define DaBaiLiveURL          //大白直播

//#define MeiWoYouPinURL        //每窝优品

//#define MaiKeXiuURL           //麦客秀

//#define ChongYouURL           //宠友

//#define HuHaLiveURL           //呼哈直播

//#define LYGLiveURL            //洛英格

//#define WLLiveURL             //喂来

//#define GNGLiveURL            //呱牛购

//#define HSLiveURL             //红手

//#define ShiBeiLiveURL         //拾贝直播

//#define KuLeShiJieURL         //酷乐世界

//#define JingJiLiveURL         //竞技直播

//#define HuanZhuHeHeLiveURL    //还珠盒盒

//#define YingXiaoKeLiveURL     //赢销客

//#define HCLMLiveURL           //辉创联盟

#define YingYinLiveURL        //赢音直播

//#define XiLuoBoLiveURL        //喜萝播

//#define AiMiLiveURL           //爱米直播

//#define HaoYouGouLiveURL      //好优购

//#define PiMaoLiveURL          //批猫直播

//#define DaYuXingQiuLiveURL    //大鱼星球

//#define YuanGuiLiveURL         //圆规

//#define ShiJiXiangLiveURL         //释吉祥

#pragma mark - 释吉祥
#ifdef ShiJiXiangLiveURL
#define New_Http_Base_domain        @"http://api.longyuanshanji.com/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.longyuanshanji.com/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://qc45xe.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"sjxlive"
#endif

#pragma mark - 圆规
#ifdef YuanGuiLiveURL
#define New_Http_Base_domain        @"http://liveapi.ygkj1314.com/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.ygkj1314.com/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://c280l6.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"yglive"
#endif

#pragma mark - 大鱼星球
#ifdef DaYuXingQiuLiveURL
#define New_Http_Base_domain        @"http://api.dayuxingqiu.com/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.dayuxingqiu.com/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://84iuvm.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"dyxqlive"
#endif

#pragma mark - 批猫直播
#ifdef PiMaoLiveURL
#define New_Http_Base_domain        @"http://api.pimao.cn/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.pimao.cn/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://pkrcwh.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"pmlive"
#endif

#pragma mark - 好优购
#ifdef HaoYouGouLiveURL
#define New_Http_Base_domain        @"http://api.renminfeiyi.cn/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.renminfeiyi.cn/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://vk812a.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"hyglive"
#endif

#pragma mark - 爱米直播
#ifdef AiMiLiveURL
#define New_Http_Base_domain        @"http://api.whzccxx.cn/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.xiluobo.cn/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://vk812a.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"amlive"
#endif

#pragma mark - 喜萝播
#ifdef XiLuoBoLiveURL
#define New_Http_Base_domain        @"http://api.xiluobo.cn/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.xiluobo.cn/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://59cnep.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"xlblive"
#endif

#pragma mark - 赢音直播
#ifdef YingYinLiveURL
#define New_Http_Base_domain        @"http://api.yingyin.live/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.yingyin.live/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://6yc47x.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"yylive"
#endif
#pragma mark - 辉创联盟
#ifdef HCLMLiveURL
#define New_Http_Base_domain        @"http://api.huichuanglianmeng.com/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.huichuanglianmeng.com/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://kd5iup.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"hclmlive"
#endif

#pragma mark - 赢销客
#ifdef YingXiaoKeLiveURL
#define New_Http_Base_domain        @"http://api.zhongnaruiheng.com/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.zhongnaruiheng.com/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://8czsv1.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"yxklive"
#endif

#ifdef HuanZhuHeHeLiveURL
#define New_Http_Base_domain        @"http://api.lllkw.com/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.lllkw.com/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://ux538k.xinstall.com.cn/tolink/"
#define ZC_KEY @"d860138a296449a2ae598a859e1b727e"                  //智齿key
#define Scheme_URL @"hzhhlive"
#endif


#ifdef JingJiLiveURL
#define New_Http_Base_domain        @"http://live.fallowgame.com/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.kuleshijie.cn/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://anedq4.xinstall.com.cn/tolink/"
#define ZC_KEY @"d860138a296449a2ae598a859e1b727e"                  //智齿key
#define Scheme_URL @""
#endif

#ifdef KuLeShiJieURL
#define New_Http_Base_domain        @"http://www.kuleshijie.cn/"
#define New_Http_Base_Url           New_Http_Base_domain @"api.php?"
#define New_Http_Base_Url_Without   New_Http_Base_domain @"api.php"
#define New_Http_Base_make_friend   New_Http_Base_domain @"api/"
#define SL_HTTP_BASE_AMWAY_URL      @"http://shop.kuleshijie.cn/"
#define SL_HTTP_BASE_API_URL        SL_HTTP_BASE_AMWAY_URL
#define SL_HTTP_H5_URL              SL_HTTP_BASE_AMWAY_URL
#define SL_UNIVERSAL_LINK @"https://gv10jm.xinstall.com.cn/tolink/"
#define ZC_KEY @"d860138a296449a2ae598a859e1b727e"                  //智齿key
#define Scheme_URL @"klsjlive"
#endif

#ifdef ShiBeiLiveURL

#define New_Http_Base_Url @"http://live.smxlive.net/api.php?"
#define New_Http_Base_Url_Without @"http://live.smxlive.net/api.php"
#define New_Http_Base_domain @"http://live.smxlive.net/"
#define New_Http_Base_make_friend @"http://live.smxlive.net/api/"
#define SL_HTTP_BASE_AMWAY_URL @""
#define SL_HTTP_BASE_API_URL @""
#define SL_HTTP_H5_URL @""
#define SL_UNIVERSAL_LINK @"https://2kwajt.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"shibeilive"

#endif

#ifdef HSLiveURL

#define New_Http_Base_Url @"http://live.sawee.shop/api.php?"
#define New_Http_Base_Url_Without @"http://live.sawee.shop/api.php"
#define New_Http_Base_domain @"http://live.sawee.shop/"
#define New_Http_Base_make_friend @"http://live.sawee.shop/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://hsshop.sawee.shop/"
#define SL_HTTP_BASE_API_URL @"http://hsshop.sawee.shop/"
#define SL_HTTP_H5_URL @"http://hsshop.sawee.shop/"
#define SL_UNIVERSAL_LINK @"https://bh2ouk.xinstall.com.cn/tolink/"
#define ZC_KEY @"d860138a296449a2ae598a859e1b727e"                  //智齿key
#define Scheme_URL @"hslive"

#endif

#ifdef GNGLiveURL

#define New_Http_Base_Url @"http://api.guaniugo.com/api.php?"
#define New_Http_Base_Url_Without @"http://api.guaniugo.com/api.php"
#define New_Http_Base_domain @"http://api.guaniugo.com/"
#define New_Http_Base_make_friend @"http://api.guaniugo.com/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.guaniugo.com/"
#define SL_HTTP_BASE_API_URL @"http://shop.guaniugo.com/"
#define SL_HTTP_H5_URL @"http://shop.guaniugo.com/"
#define SL_UNIVERSAL_LINK @"https://r30b76.xinstall.com.cn/tolink/"
#define ZC_KEY @"a37a02441dfb4974bbbef7dbbc4a78c8"                  //智齿key
#define Scheme_URL @"gnglive"

#endif

#ifdef WLLiveURL

#define New_Http_Base_Url @"http://vapi.shenqianvip.com/api.php?"
#define New_Http_Base_Url_Without @"http://vapi.shenqianvip.com/api.php"
#define New_Http_Base_domain @"http://vapi.shenqianvip.com/"
#define New_Http_Base_make_friend @"http://vapi.shenqianvip.com/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.shenqianvip.com/"
#define SL_HTTP_BASE_API_URL @"http://shop.shenqianvip.com/"
#define SL_HTTP_H5_URL @"http://shop.shenqianvip.com/"
#define SL_UNIVERSAL_LINK @"https://c7db9u.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"wllive"

#endif

#ifdef LYGLiveURL

#define New_Http_Base_Url @"http://www.luoyinggeliangzi.com/api.php?"
#define New_Http_Base_Url_Without @"http://www.luoyinggeliangzi.com/api.php"
#define New_Http_Base_domain @"http://www.luoyinggeliangzi.com/"
#define New_Http_Base_make_friend @"http://www.luoyinggeliangzi.com/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.luoyinggeliangzi.com/"
#define SL_HTTP_BASE_API_URL @"http://shop.luoyinggeliangzi.com/"
#define SL_HTTP_H5_URL @"http://shop.luoyinggeliangzi.com/"
#define SL_UNIVERSAL_LINK @"https://gq4tym.xinstall.com.cn/tolink/"
#define ZC_KEY @""                  //智齿key
#define Scheme_URL @"lyglive"

#endif

#ifdef HuHaLiveURL

#define New_Http_Base_Url @"http://api.tglzb.com/api.php?"
#define New_Http_Base_Url_Without @"http://api.tglzb.com/api.php"
#define New_Http_Base_domain @"http://api.tglzb.com/"
#define New_Http_Base_make_friend @"http://api.tglzb.com/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.nzpap.cn/"
#define SL_HTTP_BASE_API_URL @"http://shop.nzpap.cn/"
#define SL_HTTP_H5_URL @"http://shop.nzpap.cn/"
#define SL_UNIVERSAL_LINK @"https://0g42ov.xinstall.com.cn/tolink/"
#define ZC_KEY @"d860138a296449a2ae598a859e1b727e"                  //智齿key
#define Scheme_URL @""

#endif

#ifdef ChongYouURL

#define New_Http_Base_Url @"http://live.nzpap.cn/api.php?"
#define New_Http_Base_Url_Without @"http://live.nzpap.cn/api.php"
#define New_Http_Base_domain @"http://live.nzpap.cn/"
#define New_Http_Base_make_friend @"http://live.nzpap.cn/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.nzpap.cn/"
#define SL_HTTP_BASE_API_URL @"http://shop.nzpap.cn/"
#define SL_HTTP_H5_URL @"http://shop.nzpap.cn/"
#define SL_UNIVERSAL_LINK @"https://t4zr1e.xinstall.top/tolink/"
#define ZC_KEY @"d860138a296449a2ae598a859e1b727e"                  //智齿key
#define Scheme_URL @"nzpapLive"

#endif

#ifdef MaiKeXiuURL

#define New_Http_Base_Url @"http://live.wuyalangzi.com/api.php?"
#define New_Http_Base_Url_Without @"http://live.wuyalangzi.com/api.php"
#define New_Http_Base_domain @"http://live.wuyalangzi.com/"
#define New_Http_Base_make_friend @"http://live.wuyalangzi.com/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.wuyalangzi.com/"
#define SL_HTTP_BASE_API_URL @"http://shop.wuyalangzi.com/"
#define SL_HTTP_H5_URL @"http://shop.wuyalangzi.com/"
#define SL_UNIVERSAL_LINK @"https://re5l1p.xinstall.top/tolink/"
#define ZC_KEY @"9072849c597949adbf5dd8d6df535637"                  //智齿key
#define Scheme_URL @"maikexiuLive"

#endif

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
#define Scheme_URL @"SiShiLive"

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
#define Scheme_URL @"bingxinkejiLive"

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
#define SL_UNIVERSAL_LINK @"https://y5hmz8.xinstall.top/tolink/"
#define ZC_KEY @"e85ba28f99df4e14957406b63e438653"                      //智齿key
#define Scheme_URL @"duolalive"

#endif

#ifdef MeiWoYouPinURL

//每窝优品
#define New_Http_Base_Url @"http://api.live.meiwoyoupin.com/api.php?"
#define New_Http_Base_Url_Without @"http://api.live.meiwoyoupin.com/api.php"
#define New_Http_Base_domain @"http://api.live.meiwoyoupin.com/"
#define New_Http_Base_make_friend @"http://api.live.meiwoyoupin.com/api/"
#define SL_HTTP_BASE_AMWAY_URL @"http://shop.meiwoyoupin.com/"
#define SL_HTTP_BASE_API_URL @"http://shop.meiwoyoupin.com/"
#define SL_HTTP_H5_URL @"http://shop.meiwoyoupin.com/"
#define SL_UNIVERSAL_LINK @"https://ylzgr6.xinstall.top/tolink/"
#define ZC_KEY @"e85ba28f99df4e14957406b63e438653"                      //智齿key
#define Scheme_URL @"meiwoyoupinLive"
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

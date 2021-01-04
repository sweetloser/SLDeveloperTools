//
//  SLCommonMacro.h
//  Pods
//
//  Created by sweetloser on 2021/1/4.
//

#ifndef SLCommonMacro_h
#define SLCommonMacro_h

//resource path
#define __kWidth [[UIScreen mainScreen]bounds].size.width
#define __kHeight [[UIScreen mainScreen]bounds].size.height

//新增
#define __UIWidth 375
#define __UIHeight 812
#define __ScaleWRatio (__kWidth / __UIWidth)
#define __ScaleWidth(width) (__kWidth / __UIWidth) * (width)
#define __ScaleHeight(height) (__kHeight / __UIHeight) * height

#define __k5Width                  320
#define __kPWidth                  414

#define __k5Height                 568
#define __k6Height                 667
#define __k6PHeigt                 736
#define __kXHeight                 812
#define __kXMHeight                896
#define __kTopAddHeight            (iPhoneX ? 24 : 0)
#define __kBottomAddHeight         (iPhoneX ? 34 : 0)

#define isPadS                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr              ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX                   (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)

#define kSystemVersion           [[[UIDevice currentDevice] systemVersion]  floatValue]
#define IOS11      @available(iOS 11, *)
#define IsNilString(__String)    (__String==nil || [__String isEqualToString:@""] || [__String isEqualToString:@"null"] || [__String isEqualToString:@"(null)"])
#define CFont(font)              [UIFont systemFontOfSize:(font)]
#define CWFont(font,style)      [UIFont systemFontOfSize:font weight:style]
#define CBFont(font)             [UIFont boldSystemFontOfSize:(font)]
#define CAFont(name,font)        [UIFont fontWithName:name size:font]
//新增 苹方字体
#define PFFONTNAME @"PingFangSC-Regular"
#define SLPFFont(size) CAFont(PFFONTNAME,size)
#define SLBFont(size) CAFont(@"PingFangSC-Semibold",size)
#define SLMFont(size) CAFont(@"PingFangSC-Medium",size)
#define SL1451Font(size) CAFont(@"Alte DIN 1451 Mittelschrift gepraegt",size)
//

//从消息页跳转到视频
#define FromeMessageToVideo @"pushVideo"

#define CImage(image) [UIImage imageNamed:(image)]

#define IsNull(__Text) [__Text isKindOfClass:[NSNull class]]
#define IsEquallString(_Str1,_Str2)  [_Str1 isEqualToString:_Str2]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self


//16进制color 使用方法：HEXCOLOR(0xffffff)
#define CHHCOLOR(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]

#define CHHCOLOR_D(rgbValue) CHHCOLOR(rgbValue,1.0)


#define CHH_RGBCOLOR(R, G, B,A)    [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:A]
#define CHH_RandomColor          CHH_RGBCOLOR(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255),1.0)

//新增
#define SLClearColor [UIColor clearColor]
#define DynDownLineColor  UIColorHex(#F5F9FC)

#define DynUnSendButtonTitle UIColorHex(#8C8C8C)
#define DynUnSendButtonBackColor UIColorHex(#F5F9FC)

#define DynSendButtonTitle [UIColor whiteColor]
#define DynSendButtonBackColor UIColorHex(#FF2D52)

#define kDocumentFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

//button
#define BtnNormal            UIControlStateNormal
#define BtnSelected          UIControlStateSelected
#define BtnTouchUpInside     UIControlEventTouchUpInside

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//断言
#ifdef DEBUG
#define sl_asset(condition,desc,...) NSAssert(condition, desc, ##__VA_ARGS__)
#else
#define sl_asset(condition,desc,...)
#endif

#define isiPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define statusHeight \
({CGFloat height = 20.0;\
if (isiPhoneX) {\
height = 44.0;\
}\
(height);})

#define navBarHeight 44.0

#define bottomSafeAreaHeight  \
({CGFloat height = 0.0;\
if (isiPhoneX) {\
height = 34.0;\
}\
(height);})

#define navAndStatusHight \
({\
CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];\
CGRect rectNav = self.navigationController.navigationBar.frame;\
( rectStatus.size.height+ rectNav.size.height);\
})\

#define systemInterval \
({CGFloat interval = 15.0;\
if (kScreenWidth == 414.0) {\
interval = 20.0;\
}\
(interval);})


//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:1.f]

//主标题选中(#F0F8F8)
#define MainTitleColor             [UIColor colorWithRed:240/255.0 green:248/255.0 blue:248/255.0 alpha:1]
//主标题未选中、次标题、次要信息(#B8C2C2)
#define SubTitleColor              [UIColor colorWithRed:184/255.0 green:194/255.0 blue:194/255.0 alpha:1]
//最次要信息(#7A8181)
#define MinorColor                 [UIColor colorWithRed:122/255.0 green:129/255.0 blue:129/255.0 alpha:1]
//文字最亮（纯白色）
#define TextBrightestColor         [UIColor whiteColor]
//文字高亮（主题色）
#define TextHighlightColor         sl_normalColors
//内容高亮（@张三）
#define ContentHighlightColor      sl_normalColors
//白色背景字体颜色
#define WhiteBgTitleColor          [UIColor colorWithHexString:@"#161A1A"]
//按钮置灰文字(#7A8181)
#define ButtonGrayTitleColor       [UIColor colorWithRed:122/255.0 green:129/255.0 blue:129/255.0 alpha:1]

//底部导航栏(#0E0F10)
#define TabBarColor                [UIColor colorWithRed:14/255.0 green:15/255.0 blue:16/255.0 alpha:1]
//页面背景(#121A1E)
#define PageBackgroundColor        [UIColor colorWithRed:18/255.0 green:26/255.0 blue:30/255.0 alpha:1]
//页面背景(#1E1E1E)
#define SLPageBackgroundColor       [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]

//页面次背景(#1B2327)
#define PageSubBackgroundColor     [UIColor colorWithRed:27/255.0 green:35/255.0 blue:39/255.0 alpha:1]
//按钮置灰(#2E3D41)
#define ButtonGrayColor            [UIColor colorWithRed:46/255.0 green:61/255.0 blue:65/255.0 alpha:1]

//分割线-粗(#111417)
#define LineThickColor             [UIColor colorWithRed:17/255.0 green:20/255.0 blue:23/255.0 alpha:1]
//分割线-细（普通）(#2B3434)
#define LineNormalColor            [UIColor colorWithRed:43/255.0 green:52/255.0 blue:52/255.0 alpha:1]
//分割线-细（标题栏）(#2B3434)
#define LineTitleColor             LineNormalColor
//分割线-细（深）
#define LineDeeplColor             LineNormalColor

//分割线-细（深）
#define LineEAEAColor             UIColorHex(#EAEAEA)

//主题色(#01D0C5)
#define normalColors               [UIColor colorWithRed:1/255.0 green:208/255.0 blue:197/255.0 alpha:1]

//SL主题色（#F92C56）
#define sl_normalColors               [UIColor colorWithRed:249/255.0 green:44/255.0 blue:86/255.0 alpha:1]

//SL背景色 (#FFFFFF)
#define sl_BGColors               [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]

//SL次背景色 (#F5F9FC)
#define sl_subBGColors               [UIColor colorWithRed:245/255.0 green:249/255.0 blue:252/255.0 alpha:1]

//SL黑色景色 (#282828)
#define sl_blackBGColors               [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1]


//SL字体颜色（#282828）
#define sl_textColors               [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1]


#define sl_HeigthLightTextColors  UIColorHex(#91B8F4)

//SLweb页进度条颜色
#define sl_webProgressTintColor  UIColorHex(#FF2D52)

#define sl_blacktextColors  UIColorHex(#000000)


#define sl_2B2BtextColors  UIColorHex(#2B2B2B)

#define sl_FF2DtextColors  UIColorHex(#FF2D52)

#define sl_imageBackColors UIColorHex(#F5F9FC)

//SL字体次颜色（#8c8c8c）
#define sl_textSubColors               [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1]

//SL白色字体颜色(#f8f8f8)
#define sl_whiteTextColors               [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]

//SL分割线颜色 （#EAEAEA）
#define sl_divideLineColor [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1]


#endif /* SLCommonMacro_h */

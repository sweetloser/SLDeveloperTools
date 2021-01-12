//
//  Header.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//
#import <TiSDK/TiSDKInterface.h>
#import <Masonry/Masonry.h>
//#import <SDWebImage/SDWebImage.h>
#import "TIMenuPlistManager.h"

#import "TiUIManager.h"

//点击子菜单总开关按钮发出的通知
#define NotificationCenterSubMenuOnTotalSwitch @"NotificationCenterSubMenuOnTotalSwitch"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define WeakSelf __weak typeof(self) weakSelf = self;

#define getSafeBottomHeight ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom)
//^(){\
//    if(@available(iOS 11.0, *)) {\
//     return (CGFloat);\
//    }\
//    return 0.0f;\
//}() 

// MARK: --默认配置--
//字体
#define TI_Font_Default_Size_Small [UIFont fontWithName:@"Helvetica" size:10]
#define TI_Font_Default_Size_Medium [UIFont fontWithName:@"Helvetica" size:12]
#define TI_Font_Default_Size_Big [UIFont fontWithName:@"Helvetica" size:14]
//颜色
#define TI_Color_Default_Text_White [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1.0]
//#define TI_Color_Default_Text_Black [UIColor colorWithRed:(137)/255.0f green:(137)/255.0f blue:(137)/255.0f alpha:(1.0)]
#define TI_Color_Default_Text_Black [UIColor colorWithRed:(149)/255.0f green:(149)/255.0f blue:(149)/255.0f alpha:(1.0)]


//#define TI_Color_Default_Background_Pink [UIColor colorWithRed:239/255.0 green:128/255.0 blue:116/255.0 alpha:1.0]
//#define TI_Color_Default_Background_Pink [UIColor colorWithRed:88/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]

#define TI_Color_Default_Background_Pink [UIColor colorWithHexString:@"#FF2D52"]
 


// MARK: --默认按钮的宽度(以拍照按钮为基准) TiUIDefaultButtonView--
#define DefaultButton_WIDTH SCREEN_WIDTH/4

 // MARK: --美颜弹框视图总高度 TiUIManager--
//#define TiUIViewBoxTotalHeight SCREEN_HEIGHT/2.5
#define TiUIViewBoxTotalHeight 224.0
 // MARK:  拉条View --TiUISliderRelatedView--
#define TiUISliderRelatedViewHeight 50
#define TiUIMenuViewHeight 45

//左右按钮的宽度
#define TiUISliderLeftRightWidth 55
// slider高度
#define TiUISliderHeight 5
#define TiUISliderTagViewWidth 30
#define TiUISliderTagViewHeight TiUISliderTagViewWidth * 1.219 // 更具UI图得出的比例

// MARK:  子菜单状态1View --TiUISubMenuOneView--
#define TiUISubMenuOneViewTIButtonWidth 45
#define TiUISubMenuOneViewTIButtonHeight 70

#define TiUISubMenuTowViewTIButtonWidth 50
#define TiUISubMenuTowViewTIButtonHeight 75



// MARK: -- 与一键美颜中“标准” 类型参数一致
#define SkinWhiteningValue 70 // 美白拉条默认参数
#define SkinBlemishRemovalValue 70 // 磨皮拉条默认参数
#define SkinTendernessValue 40 // 粉嫩拉条默认参数
#define SkinBrightnessValue 0 // 亮度拉条默认参数，0表示无亮度效果，[-50, 0]表示降低亮度，[0, 50]表示提升亮度
#define SkinBrightValue 0 // 鲜明拉条默认参数，

#define EyeMagnifyingValue 60 // 大眼拉条默认参数
#define ChinSlimmingValue 60 // 瘦脸拉条默认参数
#define FaceNarrowingValue 80 // 窄脸拉条默认参数
#define JawTransformingValue 0 // 下巴拉条默认参数
#define ForeheadTransformingValue 0 // 额头拉条默认参数
#define MouthTransformingValue 0 // 嘴型拉条默认参数
#define NoseSlimmingValue 0 // 瘦鼻拉条默认参数
#define BeautyToothValue 50 // 美牙拉条默认参数
#define EyeSpacingValue 0 // 眼间距拉条默认参数
#define LongNoseValue 0 // 长鼻拉条默认参数
#define EyeCornerValue 0 // 眼角拉条默认参数

#define FilterValue 100 // 滤镜拉条默认参数

#define OnewKeyBeautyValue 100 // 一键美颜
 

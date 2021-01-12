//
//  TISetSDKParameters.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/10.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIConfig.h"
#import <TiSDK/TiSDKInterface.h>

@interface TISetSDKParameters : NSObject

#pragma mark -- UI保存参数时使用到的键值枚举
typedef NS_ENUM(NSInteger, TiUIDataCategoryKey) {
    
    TI_UIDCK_SKIN_WHITENING_SLIDER = 100, // 美白拉条
    TI_UIDCK_SKIN_BLEMISH_REMOVAL_SLIDER = 101, // 磨皮拉条
    TI_UIDCK_SKIN_BRIGHTNESS_SLIDER = 102, // 亮度拉条
    TI_UIDCK_SKIN_TENDERNESS_SLIDER = 103, // 粉嫩拉条
    TI_UIDCK_SKIN_SKINBRIGGT_SLIDER = 104, // 鲜明拉条
     TI_UIDCK_SKIN_SATURATION_SLIDER = 105, // 饱和拉条 ->暂未
    
    TI_UIDCK_EYE_MAGNIFYING_SLIDER = 200, // 大眼拉条
    TI_UIDCK_FACE_NARROWING_SLIDER = 201, // 瘦脸拉条
    TI_UIDCK_CHIN_SLIMMING_SLIDER = 202, // 窄脸拉条
    TI_UIDCK_JAW_TRANSFORMING_SLIDER = 203, // 下巴拉条
    TI_UIDCK_FOREHEAD_TRANSFORMING_SLIDER = 204, // 额头拉条
    TI_UIDCK_MOUTH_TRANSFORMING_SLIDER = 205, // 嘴型拉条
    TI_UIDCK_NOSE_SLIMMING_SLIDER = 206, // 瘦鼻拉条
    TI_UIDCK_TEETH_WHITENING_SLIDER = 207, // 美牙拉条
    TI_UIDCK_EYE_SPACING_SLIDER = 208, // 眼间距拉条
    TI_UIDCK_NOSE_LONG_SLIDER = 209, // 长鼻拉条
    TI_UIDCK_EYE_CORNER_SLIDER = 210, // 眼角拉条 
    
    TI_UIDCK_FILTER_SLIDER = 300,// 滤镜调节拉条
    
    TI_UIDCK_ONEKEY_SLIDER = 400, // 一键美颜
};

// 保存key float值
+ (void)setFloatValue:(float)value forKey:(TiUIDataCategoryKey)key;

// 获取key float值
+ (float)getFloatValueForKey:(TiUIDataCategoryKey)key;

// 保存key float值
//+ (void)setBoolValue:(BOOL)value forKey:(TiUIDataCategoryKey)key;
//
//// 获取key float值
//+ (float)getBoolValueForKey:(TiUIDataCategoryKey)key;

// 键值由枚举转换为String类型
//+ (NSString *)getTiUIDataCategoryKey:(TiUIDataCategoryKey)key;

// 保存key filter值
+ (void)setFilterValue:(float)value forIndex:(int)index;

// 获取key filter值
+ (float)getFilterValueForIndex:(int)index;


 


+(void)initSDK;

+(void)setTotalEnable:(BOOL)enable toIndex:(NSInteger)index;

+(void)setBeautySlider:(float)v forKey:(TiUIDataCategoryKey)key withIndex:(NSInteger)index;
 
+(TiFilterEnum)getTiFilterEnumForIndex:(NSInteger)index;

+(TiRockEnum)setRockEnumByIndex:(NSInteger)index;

+(TiDistortionEnum)setDistortionEnumByIndex:(NSInteger)index;

@end
 

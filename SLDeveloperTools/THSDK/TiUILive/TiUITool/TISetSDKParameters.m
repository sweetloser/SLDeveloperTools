//
//  TISetSDKParameters.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/10.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TISetSDKParameters.h"

@interface TISetSDKParameters ()

  
@end

@implementation TISetSDKParameters

+(void)initSDK{
      
    [[TiSDKManager shareManager] setBeautyEnable:YES];
    [[TiSDKManager shareManager] setFaceTrimEnable:YES];
     
     
      //美白指定初始值
          if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_WHITENING_SLIDER]) {
              [TISetSDKParameters setFloatValue:SkinWhiteningValue forKey:TI_UIDCK_SKIN_WHITENING_SLIDER];
          }
     [[TiSDKManager shareManager] setSkinWhitening:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_WHITENING_SLIDER]];
    
      //磨皮指定初始值
         if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_BLEMISH_REMOVAL_SLIDER]) {
               [TISetSDKParameters setFloatValue:SkinBlemishRemovalValue forKey:TI_UIDCK_SKIN_BLEMISH_REMOVAL_SLIDER];
            }
     [[TiSDKManager shareManager] setSkinBlemishRemoval:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_WHITENING_SLIDER]];
    
      //亮度
         if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_BRIGHTNESS_SLIDER]) {
                   [TISetSDKParameters setFloatValue:SkinBrightnessValue forKey:TI_UIDCK_SKIN_BRIGHTNESS_SLIDER];
            }
    [[TiSDKManager shareManager] setSkinBrightness:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_BRIGHTNESS_SLIDER]];
    
      //粉嫩
        if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_TENDERNESS_SLIDER]) {
              [TISetSDKParameters setFloatValue:SkinTendernessValue forKey:TI_UIDCK_SKIN_TENDERNESS_SLIDER];
             }
    [[TiSDKManager shareManager] setSkinTenderness:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_TENDERNESS_SLIDER]];
    
    //鲜明
        if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_SKINBRIGGT_SLIDER]) {
                 [TISetSDKParameters setFloatValue:SkinBrightValue forKey:TI_UIDCK_SKIN_SKINBRIGGT_SLIDER];
                }
       [[TiSDKManager shareManager] setSkinSharpness:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_SKIN_SKINBRIGGT_SLIDER]];
    
    
//    ------------------------------------------
 
    
    //    TI_UIDCK_EYE_MAGNIFYING_SLIDER = 201, // 大眼拉条
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_EYE_MAGNIFYING_SLIDER]) {
               [TISetSDKParameters setFloatValue:EyeMagnifyingValue forKey:TI_UIDCK_EYE_MAGNIFYING_SLIDER];
            }
    [[TiSDKManager shareManager] setEyeMagnifying:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_EYE_MAGNIFYING_SLIDER]];
    
    //       TI_UIDCK_CHIN_SLIMMING_SLIDER = 202, // 瘦脸拉条
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_FACE_NARROWING_SLIDER]) {
                [TISetSDKParameters setFloatValue:ChinSlimmingValue forKey:TI_UIDCK_FACE_NARROWING_SLIDER];
            }
    [[TiSDKManager shareManager] setChinSlimming:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_FACE_NARROWING_SLIDER]];
    
    //       TI_UIDCK_CHIN_SLIMMING_SLIDER = 202, // 窄脸脸拉条
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_CHIN_SLIMMING_SLIDER]) {
                [TISetSDKParameters setFloatValue:FaceNarrowingValue forKey:TI_UIDCK_CHIN_SLIMMING_SLIDER];
            }
    [[TiSDKManager shareManager] setFaceNarrowing:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_CHIN_SLIMMING_SLIDER]];
    
    //       TI_UIDCK_JAW_TRANSFORMING_SLIDER = 203, // 下巴拉条
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_JAW_TRANSFORMING_SLIDER]) {
                [TISetSDKParameters setFloatValue:JawTransformingValue forKey:TI_UIDCK_JAW_TRANSFORMING_SLIDER];
                   }
    [[TiSDKManager shareManager] setJawTransforming:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_JAW_TRANSFORMING_SLIDER]];
    
    //       TI_UIDCK_FOREHEAD_TRANSFORMING_SLIDER = 204, // 额头拉条
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_FOREHEAD_TRANSFORMING_SLIDER]) {
               [TISetSDKParameters setFloatValue:ForeheadTransformingValue forKey:TI_UIDCK_FOREHEAD_TRANSFORMING_SLIDER];
                   }
    [[TiSDKManager shareManager] setForeheadTransforming:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_FOREHEAD_TRANSFORMING_SLIDER]];
    
//    TI_UIDCK_MOUTH_TRANSFORMING_SLIDER = 205, // 嘴型拉条
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_MOUTH_TRANSFORMING_SLIDER]) {
                [TISetSDKParameters setFloatValue:MouthTransformingValue forKey:TI_UIDCK_MOUTH_TRANSFORMING_SLIDER];
        }
    [[TiSDKManager shareManager] setMouthTransforming:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_MOUTH_TRANSFORMING_SLIDER]];
    
//      TI_UIDCK_NOSE_SLIMMING_SLIDER = 206, // 瘦鼻拉条
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_NOSE_SLIMMING_SLIDER]) {
                   [TISetSDKParameters setFloatValue:NoseSlimmingValue forKey:TI_UIDCK_NOSE_SLIMMING_SLIDER];
           }
    [[TiSDKManager shareManager] setNoseMinifying:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_NOSE_SLIMMING_SLIDER]];
    
    
//      TI_UIDCK_TEETH_WHITENING_SLIDER = 208, // 美牙拉条
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_TEETH_WHITENING_SLIDER]) {
                   [TISetSDKParameters setFloatValue:BeautyToothValue forKey:TI_UIDCK_TEETH_WHITENING_SLIDER];
           }
    [[TiSDKManager shareManager] setTeethWhitening:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_TEETH_WHITENING_SLIDER]];
    
    // 眼间距拉条 EyeSpacingValue
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_EYE_SPACING_SLIDER]) {
                   [TISetSDKParameters setFloatValue:EyeSpacingValue forKey:TI_UIDCK_EYE_SPACING_SLIDER];
           }
    
    ;
    
    // 长鼻拉条 LongNoseValue
     if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_NOSE_LONG_SLIDER]) {
                    [TISetSDKParameters setFloatValue:LongNoseValue forKey:TI_UIDCK_NOSE_LONG_SLIDER];
            }
     [[TiSDKManager shareManager] setNoseElongating:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_NOSE_LONG_SLIDER]];
    
    // 眼角拉条 EyeCornerValue
        if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_EYE_CORNER_SLIDER]) {
                       [TISetSDKParameters setFloatValue:EyeCornerValue forKey:TI_UIDCK_EYE_CORNER_SLIDER];
               }
        [[TiSDKManager shareManager] setEyeCorners:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_EYE_CORNER_SLIDER]];
    
    
    //      TI_UIDCK_FILTER_SLIDER = 300, // 滤镜拉条
    if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_FILTER_SLIDER]) {
                   [TISetSDKParameters setFloatValue:FilterValue forKey:TI_UIDCK_FILTER_SLIDER];
           }
    //      TI_UIDCK_ONEKEY_SLIDER = 400, // 一键美颜
     if (![TISetSDKParameters getFloatValueForKey:TI_UIDCK_ONEKEY_SLIDER]) {
                    [TISetSDKParameters setFloatValue:OnewKeyBeautyValue forKey:TI_UIDCK_ONEKEY_SLIDER];
            }
    
    /**
     * 切换贴纸函数
     *
     * @param stickerName 贴纸名称
     */
    [[TiSDKManager shareManager] setStickerName:@""];
    
    /**
      * 切换互动贴纸函数
      *
      * @param stickerName 互动贴纸名称
      */
     [[TiSDKManager shareManager] setStickerName:@""];
    
    /**
     * 设置礼物特效参数函数
     *
     * @param giftName 礼物名称
     */
    [[TiSDKManager shareManager] setGift:@""];
    /**
     * 切换滤镜函数
     *
     * @param filterEnum 参考宏定义TiFilterEnum
     */
    [[TiSDKManager shareManager] setFilterEnum:NO_FILTER Param:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_FILTER_SLIDER]];
    /**
     * 设置Rock特效参数函数
     *
     * @param rockEnum 参考宏定义TiRockEnum
     */
    [[TiSDKManager shareManager] setRockEnum:NO_ROCK];
     /**
      * 设置哈哈镜特效参数函数
      *
      * @param distortionEnum 参考宏定义TiDistortionEnum
      */
    [[TiSDKManager shareManager] setDistortionEnum:NO_DISTORTION];
    
    /**
     * 设置水印参数函数
     *
     * @param enable  true: 开启 false: 关闭
     * @param x         水印左上角横坐标[0, 100]
     * @param y         水印右上角纵坐标[0, 100]
     * @param ratio    水印横向占据屏幕的比例[0, 100]
     */
//    [[TiSDKManager shareManager] setWatermark:NO Left:0 Top:0 Ratio:0 FileName:@""];
    
    /**
     * 设置面具特效参数函数
     *
     * @param maskName 面具名称
     */
    [[TiSDKManager shareManager] setMask:@""];
     
    
   /**
     * 设置绿幕特效参数函数
     *
     * @param greenScreenName 幕布名称
     */
    [[TiSDKManager shareManager] setGreenScreen:@""];
    
}



+ (void)setFloatValue:(float)value forKey:(TiUIDataCategoryKey)key {
    NSString *keyString = [self getTiUIDataCategoryKey:key];
    if (keyString.length == 0 || keyString == nil) {
        return;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:value forKey:keyString];
        [defaults synchronize];
    }
}

+ (float)getFloatValueForKey:(TiUIDataCategoryKey)key {
    NSString *keyString = [self getTiUIDataCategoryKey:key];
    if (keyString.length == 0 || keyString == nil) {
        return 0;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        return [defaults floatForKey:keyString];
    }
}

+ (void)setBoolValue:(BOOL)value forKey:(TiUIDataCategoryKey)key {
    NSString *keyString = [self getTiUIDataCategoryKey:key];
    if (keyString.length == 0 || keyString == nil) {
        return;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:value forKey:keyString];
        [defaults synchronize];
    }
}

+ (float)getBoolValueForKey:(TiUIDataCategoryKey)key {
    NSString *keyString = [self getTiUIDataCategoryKey:key];
    if (keyString.length == 0 || keyString == nil) {
        return 0;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        return [defaults boolForKey:keyString];
    }
}

+ (NSString *)getTiUIDataCategoryKey:(TiUIDataCategoryKey)key {
    switch (key) {
//        case TI_UIDCK_BEAUTY_ENABLE:
//            return @"TiUIDCKBeautyEnable";
//            break;
            //美颜
        case TI_UIDCK_SKIN_WHITENING_SLIDER:
                return @"TiUIDCKSkinWhiteningSlider";
              break;
        case TI_UIDCK_SKIN_BLEMISH_REMOVAL_SLIDER:
                return @"TiUIDCKSkinBlemishRemovalSlider";
            break;
        case TI_UIDCK_SKIN_BRIGHTNESS_SLIDER:
                return @"TiUIDCKSkinBrightnessSlider";
            break;
       
        case TI_UIDCK_SKIN_TENDERNESS_SLIDER:
            return @"TiUIDCKSkinTendernessSlider";
            break;
        case TI_UIDCK_SKIN_SATURATION_SLIDER:
            return @"TiUIDCKSkinSaturationSlider";
            break;
        case TI_UIDCK_SKIN_SKINBRIGGT_SLIDER:
                return @"TI_UIDCK_SKIN_SKINBRIGGT_SLIDER";
            break;
              
            
            //美型
        case TI_UIDCK_EYE_MAGNIFYING_SLIDER://200
              return @"TiUIDCKEyeMagnifyingSlider";
             break;
        case TI_UIDCK_FACE_NARROWING_SLIDER://1
              return @"TiUIDCKFaceNarrowingSlider";
             break;
        case TI_UIDCK_CHIN_SLIMMING_SLIDER://2
             return @"TiUIDCKChinSlimmingSlider";
            break;
        case TI_UIDCK_JAW_TRANSFORMING_SLIDER://3
             return @"TiUIDCKJawTramsformingSlider";
            break;
        case TI_UIDCK_FOREHEAD_TRANSFORMING_SLIDER://4
             return @"TiUIDCKForeheadTransformingSlider";
            break;
        case TI_UIDCK_MOUTH_TRANSFORMING_SLIDER://5
             return @"TiUIDCKMouthTransformingSlider";
            break;
        case TI_UIDCK_NOSE_SLIMMING_SLIDER://6
             return @"TiUIDCKNoseSlimmingSlider";
            break;
        case TI_UIDCK_TEETH_WHITENING_SLIDER://7
             return @"TiUIDCKTeethWhiteningSlider";
            break;
        case TI_UIDCK_EYE_SPACING_SLIDER://8
            return @"TI_UIDCK_EYE_SPACING_SLIDER";
            break;
        case TI_UIDCK_NOSE_LONG_SLIDER://9
            return @"TI_UIDCK_NOSE_LONG_SLIDER";
            break;
            case TI_UIDCK_EYE_CORNER_SLIDER://10
                return @"TI_UIDCK_EYE_CORNER_SLIDER";
            break;
            
            //滤镜
        case TI_UIDCK_FILTER_SLIDER://8
            return @"TiUIDCKFilterSlider";
            break;
        //一键美颜
           case TI_UIDCK_ONEKEY_SLIDER:
               return @"TiUIDCKOneKeySlider";
               break;
        default:
            return @"";
            break;
    }
}



// 保存key filter值
+ (void)setFilterValue:(float)value forIndex:(int)index {
    NSString *keyString = [self getFilterDataCategoryKeyByIndex:index];
    if (keyString.length == 0 || keyString == nil) {
        return;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:value forKey:keyString];
        [defaults synchronize];
    }
}

// 获取key filter值
+ (float)getFilterValueForIndex:(int)index {
    NSString *keyString = [self getFilterDataCategoryKeyByIndex:index];
    if (keyString.length == 0 || keyString == nil) {
        return 0;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        return [defaults floatForKey:keyString];
    }
}

+ (NSString *)getFilterDataCategoryKeyByIndex:(int)index {
    return [NSString stringWithFormat:@"TiUIDCKFilterEnum%dSlider", index];
}






+(void)setTotalEnable:(BOOL)enable toIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
    [[TiSDKManager shareManager] setBeautyEnable:enable];
            break;
        case 1:
    [[TiSDKManager shareManager] setFaceTrimEnable:enable];
            break;
            
        default:
            break;
    }
     
}


+(void)updateSlider{
    
}

+(void)setBeautySlider:(float)v forKey:(TiUIDataCategoryKey)key withIndex:(NSInteger)index{
    
    switch (key) {
            
            case TI_UIDCK_SKIN_WHITENING_SLIDER:
            //美颜
            [[TiSDKManager shareManager] setSkinWhitening:v];
                      break;
            
            case TI_UIDCK_SKIN_BLEMISH_REMOVAL_SLIDER:
            //磨皮
            [[TiSDKManager shareManager] setSkinBlemishRemoval:v];
                      break;
            
            case TI_UIDCK_SKIN_BRIGHTNESS_SLIDER:
            //亮度
            [[TiSDKManager shareManager] setSkinBrightness:v];
                      break;
            
            case TI_UIDCK_SKIN_TENDERNESS_SLIDER:
            //粉嫩
            [[TiSDKManager shareManager] setSkinTenderness:v];
                      
                      break;
//             饱和
            case TI_UIDCK_SKIN_SATURATION_SLIDER:
                                 
                      break;
            //鲜明
            case TI_UIDCK_SKIN_SKINBRIGGT_SLIDER:
                                        
              [[TiSDKManager shareManager] setSkinSharpness:v];
                                
                      break;
            
            //美型
                   case TI_UIDCK_EYE_MAGNIFYING_SLIDER:
                             //大眼
                        [[TiSDKManager shareManager] setEyeMagnifying:v];
                             break;
                   case TI_UIDCK_FACE_NARROWING_SLIDER:
                             //瘦脸
                        [[TiSDKManager shareManager] setChinSlimming:v];
            
                             break;
                   case TI_UIDCK_CHIN_SLIMMING_SLIDER:
                             //窄脸
                        [[TiSDKManager shareManager] setFaceNarrowing:v];
            
                             break;
                   case TI_UIDCK_JAW_TRANSFORMING_SLIDER:
                             //下巴
                        [[TiSDKManager shareManager] setJawTransforming:v];
            
                             break;
                   case TI_UIDCK_FOREHEAD_TRANSFORMING_SLIDER:
                             //额头
                        [[TiSDKManager shareManager] setForeheadTransforming:v];
                             break;
                   case TI_UIDCK_MOUTH_TRANSFORMING_SLIDER:
                            //嘴型
                       [[TiSDKManager shareManager] setMouthTransforming:v];
            
                            break;
                   case TI_UIDCK_NOSE_SLIMMING_SLIDER:
                            //瘦鼻
                       [[TiSDKManager shareManager] setNoseMinifying:-v];
            
                            break;
                   case TI_UIDCK_TEETH_WHITENING_SLIDER:
                            //美牙
                       [[TiSDKManager shareManager] setTeethWhitening:v];
                            break;
            case TI_UIDCK_EYE_SPACING_SLIDER:
                                       //眼间距
                         [[TiSDKManager shareManager] setEyeSpacing:v];
                                       break;
            case TI_UIDCK_NOSE_LONG_SLIDER:
                                       //长鼻
                         [[TiSDKManager shareManager] setNoseElongating:v];
                                       break;
            case TI_UIDCK_EYE_CORNER_SLIDER:
                                       //眼角
                         [[TiSDKManager shareManager] setEyeCorners:v];
                                       break;
            
            
                   case TI_UIDCK_FILTER_SLIDER:
                                       //滤镜
                    [[TiSDKManager shareManager] setFilterEnum:[TISetSDKParameters getTiFilterEnumForIndex:index] Param:v];
                                       break;
                   case TI_UIDCK_ONEKEY_SLIDER:
                                      //一键美颜
            [TISetSDKParameters setOneKeyBeautySlider:v Index:index];
                                                  break;
            
        default:
            break;
    }
      
}

+(void)setOneKeyBeautySlider:(float)v Index:(NSInteger)index{
    CGFloat a = v/100;
    NSDictionary *oneKeyParameter = [[TIMenuPlistManager shareManager].oneKeyParameter objectAtIndex:index];
    
    
    
    CGFloat value100 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:100]] floatValue];
    [TISetSDKParameters setFloatValue:value100  * a forKey:100];//将一键美颜的参数储存本地
    [TISetSDKParameters setBeautySlider:value100 * a forKey:100 withIndex:999];
    
    
    CGFloat value101 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:101]] floatValue];
       [TISetSDKParameters setFloatValue:value101  * a forKey:101];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value101 * a forKey:101 withIndex:999];
    
    
    CGFloat value102 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:102]] floatValue];
       [TISetSDKParameters setFloatValue:value102 * a forKey:102];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value102 * a forKey:102 withIndex:999];
    
    
    CGFloat value103 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:103]] floatValue];
       [TISetSDKParameters setFloatValue:value103  * a forKey:103];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value103 * a forKey:103 withIndex:999];
    
    
    CGFloat value104 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:104]] floatValue];
       [TISetSDKParameters setFloatValue:value104  * a forKey:104];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value104 * a forKey:104 withIndex:999];
    
    
    
    CGFloat value200 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:200]] floatValue];
    [TISetSDKParameters setFloatValue:value200  * a forKey:200];//将一键美颜的参数储存本地
    [TISetSDKParameters setBeautySlider:value200 * a forKey:200 withIndex:999];
    
    CGFloat value201 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:201]] floatValue];
       [TISetSDKParameters setFloatValue:value201  * a forKey:201];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value201 * a forKey:201 withIndex:999];
    
    CGFloat value202 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:202]] floatValue];
       [TISetSDKParameters setFloatValue:value202  * a forKey:202];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value202 * a forKey:202 withIndex:999];
    
    CGFloat value203 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:203]] floatValue];
       [TISetSDKParameters setFloatValue:value203  * a forKey:203];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value203 * a forKey:203 withIndex:999];
    
    CGFloat value204 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:204]] floatValue];
       [TISetSDKParameters setFloatValue:value204  * a forKey:204];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value204 * a forKey:204 withIndex:999];
    
    CGFloat value205 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:205]] floatValue];
       [TISetSDKParameters setFloatValue:value205 * a forKey:205];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value205 * a forKey:205 withIndex:999];
    
    CGFloat value206 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:206]] floatValue];
       [TISetSDKParameters setFloatValue:value206  * a forKey:206];//将一键美颜的参数储存本地
       [TISetSDKParameters setBeautySlider:value206 * a forKey:206 withIndex:999];
    
    CGFloat value207 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:207]] floatValue];
    [TISetSDKParameters setFloatValue:value207  * a forKey:207];//将一键美颜的参数储存本地
    [TISetSDKParameters setBeautySlider:value207 * a forKey:207 withIndex:999];
    
    CGFloat value208 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:208]] floatValue];
    [TISetSDKParameters setFloatValue:value208  * a forKey:208];//将一键美颜的参数储存本地
    [TISetSDKParameters setBeautySlider:value208 * a forKey:208 withIndex:999];
    
    CGFloat value209 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:209]] floatValue];
    [TISetSDKParameters setFloatValue:value209  * a forKey:209];//将一键美颜的参数储存本地
    [TISetSDKParameters setBeautySlider:value209 * a forKey:209 withIndex:999];
    
    CGFloat value210 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:210]] floatValue];
    [TISetSDKParameters setFloatValue:value210  * a forKey:210];//将一键美颜的参数储存本地
    
     
    CGFloat value300 = [[oneKeyParameter objectForKey:[TISetSDKParameters getTiUIDataCategoryKey:300]] floatValue];
    [TISetSDKParameters setFloatValue:value300  * a forKey:300];//将一键美颜的参数储存本地
    [TISetSDKParameters setBeautySlider:value300 * a forKey:300 withIndex:[[oneKeyParameter objectForKey:@"TiFilterEnum"] intValue]];
    
}

+(TiFilterEnum)getTiFilterEnumForIndex:(NSInteger)index{
    switch (index) {
        case 0:
            return NO_FILTER; // 无
            break;
        case 50:
            return SKETCH_FILTER; // 1素描
            break;
        case 49:
            return SOBELEDGE_FILTER; // 2黑边
            break;
        case 48:
            return TOON_FILTER; // 3卡通
            break;
        case 47:
            return EMBOSS_FILTER; // 4浮雕
            break;
        case 36:
            return FILM_FILTER; // 5胶片
            break;
        case 46:
            return PIXELLATION_FILTER; // 6马赛克
            break;
        case 45:
            return HALFTONE_FILTER; // 7半色调
            break;
        case 44:
            return CROSSHATCH_FILTER; // 8交叉边
            break;
        case 12:
            return KISS_FILTER; // 19初吻
            break;
        case 27:
            return COFFEE_FILTER; // 10咖啡
            break;
        case 14:
            return CHOCOLATE_FILTER; // 11巧克力
            break;
        case 28:
            return COCO_FILTER; // 12可可
            break;
        case 29:
            return DELICIOUS_FILTER; // 13美味
            break;
        case 17:
            return FIRSTLOVE_FILTER; // 14初恋
            break;
        case 16:
            return FOREST_FILTER; // 15森林
            break;
        case 25:
            return GLOSSY_FILTER; // 16光泽
            break;
        case 18:
            return GRASS_FILTER; // 17禾草
            break;
        case 19:
            return HOLIDAY_FILTER; // 18假日
            break;
        case 11:
            return LOLITA_FILTER; // 20洛丽塔
            break;
        case 10:
            return RED_FILTER; // 26赤红
            break;
        case 32:
            return MEMORY_FILTER; // 21回忆
            break;
        case 30:
            return MOUSSE_FILTER; // 22慕斯
            break;
        case 13:
            return NASHVILLE_FILTER; // 9那舍尔
            break;
        case 15:
            return OXGEN_FILTER; // 24氧气
            break;
        case 23:
            return PLATYCODON_FILTER; // 25桔梗
            break;
        case 9:
            return VIGNETTE_FILTER; // 32光晕
            break;
        case 31:
            return SUNLESS_FILTER; // 27冷日
            break;
        case 43:
            return PINCH_DISTORTION_FILTER; // 28扭曲
            break;
        case 33:
            return KUWAHARA_FILTER; // 29油画
            break;
        case 35:
            return POSTERIZE_FILTER; // 30分色
            break;
        case 42:
            return SWIRL_DISTORTION_FILTER; // 31漩涡
            break;
        case 8:
            return AZREAL_FILTER; // 41艾瑟福尔
            break;
        case 41:
            return ZOOM_BLUR_FILTER; // 33眩晕
            break;
        case 40:
            return POLKA_DOT_FILTER; // 34圆点
            break;
        case 39:
            return POLAR_PIXELLATE_FILTER; // 35极坐标
            break;
        case 38:
            return GLASS_SPHERE_REFRACTION_FILTER; // 36水晶球
            break;
        case 37:
            return SOLARIZE_FILTER; // 37曝光
            break;
        case 34:
            return INK_WASH_PAINTING_FILTER; // 38水墨
            break;
        case 26:
            return ARABICA_FILTER; // 39阿拉比卡
            break;
        case 22:
            return AVA_FILTER; // 40阿瓦
            break;
        case 7:
            return BYERS_FILTER; // 43拜尔斯
            break;
        case 21:
            return BOURBON_FILTER; // 42波旁
            break;
        case 6:
            return FUJI_REALA_FILTER; // 90真实
            break;
        case 5:
            return CHEMICAL_FILTER; // 44化学
            break;
        case 20:
            return CLAYTON_FILTER; // 45克莱顿
            break;
        case 2:
            return CLOUSEAU_FILTER; // 46克卢索
            break;
        case 4:
            return COBI_FILTER; // 47小新
            break;
        case 3:
            return CONTRAIL_FILTER; // 48凝迹
            break;
        case 24:
            return CUBICLE_FILTER; // 49隔间
            break;
        case 1:
            return DJANGO_FILTER; // 50姜戈
            break;
        default:
            return NO_FILTER;
            break;
    }
}

+(TiRockEnum)setRockEnumByIndex:(NSInteger)index{
    switch(index) {
        case 0:
            return NO_ROCK;
            break;
        case 1:
            return DAZZLED_COLOR_ROCK;
            break;
        case 2:
            return LIGHT_COLOR_ROCK;
            break;
        case 3:
            return DIZZY_GIDDY_ROCK;
            break;
        case 4:
            return ASTRAL_PROJECTION_ROCK;
            break;
        case 5:
            return BLACK_MAGIC_ROCK;
            break;
        case 6:
            return VIRTUAL_MIRROR_ROCK;
            break;
        case 7:
            return DYNAMIC_SPLIT_SCREEN_ROCK;
            break;
        case 8:
            return BLACK_WHITE_FILM_ROCK;
            break;
        case 9:
            return GRAY_PETRIFACTION_ROCK; // 瞬间石化
            break;
        case 10:
            return BULGE_DISTORTION__ROCK; // 魔法镜面
            break;
        default:
            return NO_ROCK;
            break;
    }
}

+(TiDistortionEnum)setDistortionEnumByIndex:(NSInteger)index {
    switch(index) {
        case 0:
            return NO_DISTORTION;
            break;
        case 1:
            return ET_DISTORTION;
            break;
        case 2:
            return PEAR_FACE_DISTORTION;
            break;
        case 3:
            return SLIM_FACE_DISTORTION;
            break;
        case 4:
            return SQUARE_FACE_DISTORTION;
            break;
        default:
            return NO_DISTORTION;
            break;
    }
}

@end

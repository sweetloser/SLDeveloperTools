//
//  FUManager+SLExtension.m
//  SLDeveloperTools
//
//  Created by sweetloser on 2021/4/12.
//

#import "FUManager+SLExtension.h"
#import <objc/runtime.h>
#import <libCNamaSDK/FURenderer.h>
#import <MMKV/MMKV.h>

@implementation FUManager (SLExtension)


- (void)setIsLive:(BOOL)isLive {
     objc_setAssociatedObject(self, @selector(isLive), @(isLive), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)isLive {
    NSNumber *isLive = objc_getAssociatedObject(self, @selector(isLive));
    return [isLive boolValue];
}

- (void)setEnableGesture:(BOOL)enableGesture {
     objc_setAssociatedObject(self, @selector(enableGesture), @(enableGesture), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)enableGesture {
    NSNumber *enableGesture = objc_getAssociatedObject(self, @selector(enableGesture));
    return [enableGesture boolValue];
}

- (void)setEnableMaxFaces:(BOOL)enableMaxFaces {
     objc_setAssociatedObject(self, @selector(enableMaxFaces), @(enableMaxFaces), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)enableMaxFaces {
    NSNumber *enableMaxFaces = objc_getAssociatedObject(self, @selector(enableMaxFaces));
    return [enableMaxFaces boolValue];
}


- (void)setSkinDetectEnable:(BOOL)skinDetectEnable {
     objc_setAssociatedObject(self, @selector(skinDetectEnable), @(skinDetectEnable), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)skinDetectEnable {
    NSNumber *skinDetectEnable = objc_getAssociatedObject(self, @selector(skinDetectEnable));
    return [skinDetectEnable boolValue];
}

- (void)setBlurShape:(NSInteger)blurShape {
     objc_setAssociatedObject(self, @selector(blurShape), @(blurShape), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSInteger)blurShape {
    NSNumber *blurShape = objc_getAssociatedObject(self, @selector(blurShape));
    return [blurShape integerValue];
}

- (void)setBlurLevel:(double)blurLevel {
     objc_setAssociatedObject(self, @selector(blurLevel), @(blurLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)blurLevel {
    NSNumber *blurLevel = objc_getAssociatedObject(self, @selector(blurLevel));
    return [blurLevel doubleValue];
}

- (void)setWhiteLevel:(double)whiteLevel {
     objc_setAssociatedObject(self, @selector(whiteLevel), @(whiteLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)whiteLevel {
    NSNumber *whiteLevel = objc_getAssociatedObject(self, @selector(whiteLevel));
    return [whiteLevel doubleValue];
}

- (void)setRedLevel:(double)redLevel {
     objc_setAssociatedObject(self, @selector(redLevel), @(redLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)redLevel {
    NSNumber *redLevel = objc_getAssociatedObject(self, @selector(redLevel));
    return [redLevel doubleValue];
}

- (void)setEyelightingLevel:(double)eyelightingLevel {
     objc_setAssociatedObject(self, @selector(eyelightingLevel), @(eyelightingLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)eyelightingLevel {
    NSNumber *eyelightingLevel = objc_getAssociatedObject(self, @selector(eyelightingLevel));
    return [eyelightingLevel doubleValue];
}

- (void)setBeautyToothLevel:(double)beautyToothLevel {
     objc_setAssociatedObject(self, @selector(beautyToothLevel), @(beautyToothLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)beautyToothLevel {
    NSNumber *beautyToothLevel = objc_getAssociatedObject(self, @selector(beautyToothLevel));
    return [beautyToothLevel doubleValue];
}

- (void)setFaceShape:(NSInteger)faceShape {
     objc_setAssociatedObject(self, @selector(faceShape), @(faceShape), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSInteger)faceShape {
    NSNumber *faceShape = objc_getAssociatedObject(self, @selector(faceShape));
    return [faceShape integerValue];
}

- (void)setEnlargingLevel:(double)enlargingLevel {
     objc_setAssociatedObject(self, @selector(enlargingLevel), @(enlargingLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)enlargingLevel {
    NSNumber *enlargingLevel = objc_getAssociatedObject(self, @selector(enlargingLevel));
    return [enlargingLevel doubleValue];
}

- (void)setThinningLevel:(double)thinningLevel {
     objc_setAssociatedObject(self, @selector(thinningLevel), @(thinningLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)thinningLevel {
    NSNumber *thinningLevel = objc_getAssociatedObject(self, @selector(thinningLevel));
    return [thinningLevel doubleValue];
}

- (void)setEnlargingLevel_new:(double)enlargingLevel_new {
     objc_setAssociatedObject(self, @selector(enlargingLevel_new), @(enlargingLevel_new), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)enlargingLevel_new {
    NSNumber *enlargingLevel_new = objc_getAssociatedObject(self, @selector(enlargingLevel_new));
    return [enlargingLevel_new doubleValue];
}

- (void)setThinningLevel_new:(double)thinningLevel_new {
     objc_setAssociatedObject(self, @selector(thinningLevel_new), @(thinningLevel_new), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)thinningLevel_new {
    NSNumber *thinningLevel_new = objc_getAssociatedObject(self, @selector(thinningLevel_new));
    return [thinningLevel_new doubleValue];
}

- (void)setJewLevel:(double)jewLevel {
     objc_setAssociatedObject(self, @selector(jewLevel), @(jewLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)jewLevel {
    NSNumber *jewLevel = objc_getAssociatedObject(self, @selector(jewLevel));
    return [jewLevel doubleValue];
}

- (void)setForeheadLevel:(double)foreheadLevel {
     objc_setAssociatedObject(self, @selector(foreheadLevel), @(foreheadLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)foreheadLevel {
    NSNumber *foreheadLevel = objc_getAssociatedObject(self, @selector(foreheadLevel));
    return [foreheadLevel doubleValue];
}

- (void)setNoseLevel:(double)noseLevel {
     objc_setAssociatedObject(self, @selector(noseLevel), @(noseLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)noseLevel {
    NSNumber *noseLevel = objc_getAssociatedObject(self, @selector(noseLevel));
    return [noseLevel doubleValue];
}

- (void)setMouthLevel:(double)mouthLevel {
     objc_setAssociatedObject(self, @selector(mouthLevel), @(mouthLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)mouthLevel {
    NSNumber *mouthLevel = objc_getAssociatedObject(self, @selector(mouthLevel));
    return [mouthLevel doubleValue];
}

- (void)setSelectedFilter:(NSString *)selectedFilter {
     objc_setAssociatedObject(self, @selector(selectedFilter), selectedFilter, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)selectedFilter {
    NSString *selectedFilter = objc_getAssociatedObject(self, @selector(selectedFilter));
    return selectedFilter;
}

- (void)setSelectedFilterLevel:(double)selectedFilterLevel {
     objc_setAssociatedObject(self, @selector(selectedFilterLevel), @(selectedFilterLevel), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (double)selectedFilterLevel {
    NSNumber *selectedFilterLevel = objc_getAssociatedObject(self, @selector(selectedFilterLevel));
    return [selectedFilterLevel doubleValue];
}

- (void)setSelectedItem:(NSString *)selectedItem {
     objc_setAssociatedObject(self, @selector(selectedItem), selectedItem, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)selectedItem {
    NSString *selectedItem = objc_getAssociatedObject(self, @selector(selectedItem));
    return selectedItem;
}
//设置美颜参数
- (void)resetAllBeautyParams{
    int beautyItem = [self getHandleAboutType:FUNamaHandleTypeBeauty];
    [FURenderer itemSetParam:beautyItem withName:@"skin_detect" value:@(self.skinDetectEnable)]; //是否开启皮肤检测
    [FURenderer itemSetParam:beautyItem withName:@"heavy_blur" value:@(self.blurShape)]; // 美肤类型 (0、1、) 清晰：0，朦胧：1
    [FURenderer itemSetParam:beautyItem withName:@"blur_level" value:@(self.blurLevel * 6.0 )]; //磨皮 (0.0 - 6.0)
    [FURenderer itemSetParam:beautyItem withName:@"blur_type" value:@(0)]; //磨皮精细度
    [FURenderer itemSetParam:beautyItem withName:@"color_level" value:@(self.whiteLevel * 2.0)]; //美白 (0~1)
    [FURenderer itemSetParam:beautyItem withName:@"red_level" value:@(self.redLevel * 2.0)]; //红润 (0~1)
    [FURenderer itemSetParam:beautyItem withName:@"eye_bright" value:@(self.eyelightingLevel)]; // 亮眼
    [FURenderer itemSetParam:beautyItem withName:@"tooth_whiten" value:@(self.beautyToothLevel)];// 美牙
    [FURenderer itemSetParam:beautyItem withName:@"face_shape" value:@(self.faceShape)]; //美型类型 (0、1、2、3、4)女神：0，网红：1，自然：2，默认：3，自定义：4
    [FURenderer itemSetParam:beautyItem withName:@"eye_enlarging" value:@(self.enlargingLevel)]; //大眼 (0~1)
    [FURenderer itemSetParam:beautyItem withName:@"cheek_thinning" value:@(self.thinningLevel)]; //瘦脸 (0~1)
    [FURenderer itemSetParam:beautyItem withName:@"intensity_chin" value:@(self.jewLevel)]; /**下巴 (0~1)*/
    [FURenderer itemSetParam:beautyItem withName:@"intensity_nose" value:@(self.noseLevel)];/**鼻子 (0~1)*/
    [FURenderer itemSetParam:beautyItem withName:@"intensity_forehead" value:@(self.foreheadLevel)];/**额头 (0~1)*/
    [FURenderer itemSetParam:beautyItem withName:@"intensity_mouth" value:@(self.mouthLevel)];/**嘴型 (0~1)*/
    //滤镜名称需要小写
    [FURenderer itemSetParam:beautyItem withName:@"filter_name" value:[self.selectedFilter lowercaseString]];
    [FURenderer itemSetParam:beautyItem withName:@"filter_level" value:@(self.selectedFilterLevel)]; //滤镜程度
}
/*设置默认参数*/
- (void)setBeautyDefaultParameters {
    self.whiteLevel             = 0.6 ; // 美白
    self.blurLevel              = 0.6 ; // 磨皮， 实际设置的时候 x6
    self.thinningLevel_new      = 0.6 ; // 瘦脸
    self.enlargingLevel         = 0.3 ; // 大眼
    self.redLevel               = 0.3 ; // 红润
    self.jewLevel               = 0.5 ; // 下巴
    self.foreheadLevel          = 0.5 ; // 额头
    self.noseLevel              = 0.2 ; // 鼻子
    
    self.selectedFilter = @"origin";
    self.selectedFilterLevel = 0.7;
    
    self.selectedItem = @"filter_nono";
    
    self.faceShape              = 4 ;   // 脸型
    self.skinDetectEnable       = YES;// 精准美肤
    self.blurShape              = 0 ;
    self.thinningLevel          = 0.6 ; // 瘦脸
    self.enlargingLevel_new     = 0.3 ; // 大眼
    self.eyelightingLevel       = 0; // 亮眼
    self.beautyToothLevel       = 0; // 美牙
    self.mouthLevel             = 0.0 ; // 嘴
    

    self.enableGesture = NO;
    self.enableMaxFaces = NO;
    MMKV *mmkv = [MMKV defaultMMKV];
    if (self.isLive) {
        NSLog(@"直播美颜");
        NSString *filterName = [mmkv getStringForKey:@"DSFilterName"];
        if (filterName) {
            self.selectedFilter = filterName;
        }
        
        CGFloat colorLevel = [mmkv getFloatForKey:@"DSColorLevel"];
        if (colorLevel) {
            self.whiteLevel = colorLevel;
        }
        CGFloat blurLevel = [mmkv getFloatForKey:@"DSBlurLevel"];
        if (blurLevel) {
            self.blurLevel = blurLevel;
        }
        CGFloat enlargingLevel = [mmkv getFloatForKey:@"DSEnlargingLevel"];
        if (enlargingLevel) {
            self.enlargingLevel = enlargingLevel;
        }
        CGFloat thinningLevel = [mmkv getFloatForKey:@"DSThinningLevel"];
        if (thinningLevel) {
            self.thinningLevel = thinningLevel;
        }
        CGFloat redLevel = [mmkv getFloatForKey:@"DSRedLevel"];
        if (redLevel) {
            self.redLevel = redLevel;
        }
        CGFloat chinLevel = [mmkv getFloatForKey:@"DSChinLevel"];
        if (chinLevel) {
            self.jewLevel = chinLevel;
        }
        CGFloat foreheadLevel = [mmkv getFloatForKey:@"DSForeheadLevel"];
        if (foreheadLevel) {
            self.foreheadLevel = foreheadLevel;
        }
        CGFloat noseLevel = [mmkv getFloatForKey:@"DSNoseLevel"];
        if (noseLevel) {
            self.noseLevel = noseLevel;
        }
    }else{
        NSLog(@"短视频");
        self.selectedFilter = @"origin";
        CGFloat colorLevel = [mmkv getFloatForKey:@"DSColorLevelShort"];
        if (colorLevel) {
            self.whiteLevel = colorLevel;
        }
        CGFloat blurLevel = [mmkv getFloatForKey:@"DSBlurLevelShort"];
        if (blurLevel) {
            self.blurLevel = blurLevel;
        }
        CGFloat enlargingLevel = [mmkv getFloatForKey:@"DSEnlargingLevelShort"];
        if (enlargingLevel) {
            self.enlargingLevel = enlargingLevel;
        }
        CGFloat thinningLevel = [mmkv getFloatForKey:@"DSThinningLevelShort"];
        if (thinningLevel) {
            self.thinningLevel = thinningLevel;
        }
        CGFloat redLevel = [mmkv getFloatForKey:@"DSRedLevelShort"];
        if (redLevel) {
            self.redLevel = redLevel;
        }
        CGFloat chinLevel = [mmkv getFloatForKey:@"DSChinLevelShort"];
        if (chinLevel) {
            self.jewLevel = chinLevel;
        }
        CGFloat foreheadLevel = [mmkv getFloatForKey:@"DSForeheadLevelShort"];
        if (foreheadLevel) {
            self.foreheadLevel = foreheadLevel;
        }
        CGFloat noseLevel = [mmkv getFloatForKey:@"DSNoseLevelShort"];
        if (noseLevel) {
            self.noseLevel = noseLevel;
        }
    }
}

-(void)ckresetALLBeautParams {
    self.selectedFilter = @"origin";
    self.selectedFilterLevel = 0.7;
    
    self.selectedItem = @"filter_nono";
    
    self.whiteLevel             = 0.6 ; // 美白
    self.blurLevel              = 0.6 ; // 磨皮， 实际设置的时候 x6
    self.thinningLevel_new      = 0.6 ; // 瘦脸
    self.enlargingLevel         = 0.3 ; // 大眼
    self.redLevel               = 0.3 ; // 红润
    self.jewLevel               = 0.5 ; // 下巴
    self.foreheadLevel          = 0.5 ; // 额头
    self.noseLevel              = 0.2 ; // 鼻子
    
    int beautyItem = [self getHandleAboutType:FUNamaHandleTypeBeauty];

    [FURenderer itemSetParam:beautyItem withName:@"skin_detect" value:@(self.skinDetectEnable)]; //是否开启皮肤检测
    [FURenderer itemSetParam:beautyItem withName:@"heavy_blur" value:@(self.blurShape)]; // 美肤类型 (0、1、) 清晰：0，朦胧：1
    [FURenderer itemSetParam:beautyItem withName:@"blur_level" value:@(self.blurLevel * 6.0 )]; //磨皮 (0.0 - 6.0)
    [FURenderer itemSetParam:beautyItem withName:@"color_level" value:@(self.whiteLevel)]; //美白 (0~1)
    [FURenderer itemSetParam:beautyItem withName:@"red_level" value:@(self.redLevel)]; //红润 (0~1)
    [FURenderer itemSetParam:beautyItem withName:@"eye_bright" value:@(self.eyelightingLevel)]; // 亮眼
    [FURenderer itemSetParam:beautyItem withName:@"tooth_whiten" value:@(self.beautyToothLevel)];// 美牙
    [FURenderer itemSetParam:beautyItem withName:@"face_shape" value:@(4)]; //美型类型 (0、1、2、3、4)女神：0，网红：1，自然：2，默认：3，自定义：4
    [FURenderer itemSetParam:beautyItem withName:@"eye_enlarging" value:@(self.enlargingLevel)]; //大眼 (0~1)
    [FURenderer itemSetParam:beautyItem withName:@"cheek_thinning" value:@(self.thinningLevel)]; //瘦脸 (0~1)
    [FURenderer itemSetParam:beautyItem withName:@"intensity_chin" value:@(self.jewLevel)]; /**下巴 (0~1)*/
    [FURenderer itemSetParam:beautyItem withName:@"intensity_nose" value:@(self.noseLevel)];/**鼻子 (0~1)*/
    [FURenderer itemSetParam:beautyItem withName:@"intensity_forehead" value:@(self.foreheadLevel)];/**额头 (0~1)*/
    [FURenderer itemSetParam:beautyItem withName:@"intensity_mouth" value:@(self.mouthLevel)];/**嘴型 (0~1)*/
    //滤镜名称需要小写
    [FURenderer itemSetParam:beautyItem withName:@"filter_name" value:[self.selectedFilter lowercaseString]];
    [FURenderer itemSetParam:beautyItem withName:@"filter_level" value:@(self.selectedFilterLevel)]; //滤镜程度
    
}

@end

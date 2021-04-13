//
//  FUManager+SLExtension.h
//  SLDeveloperTools
//
//  Created by sweetloser on 2021/4/12.
//

#import "FUManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUManager (SLExtension)

@property (nonatomic, assign) BOOL isLive;

@property (nonatomic, assign)               BOOL enableGesture;         /**设置是否开启手势识别，默认未开启*/
@property (nonatomic, assign)               BOOL enableMaxFaces;        /**设置人脸识别个数，默认为单人模式*/

@property (nonatomic, assign) BOOL skinDetectEnable;   // 精准美肤
@property (nonatomic, assign) NSInteger blurShape;      // 美肤类型 (0、1、) 清晰：0，朦胧：1
@property (nonatomic, assign) double blurLevel;         // 磨皮(0.0 - 6.0)
@property (nonatomic, assign) double whiteLevel;        // 美白
@property (nonatomic, assign) double redLevel;          // 红润
@property (nonatomic, assign) double eyelightingLevel;  // 亮眼
@property (nonatomic, assign) double beautyToothLevel;  // 美牙

@property (nonatomic, assign) NSInteger faceShape;        //脸型 (0、1、2、3、4)女神：0，网红：1，自然：2，默认：3，自定义：4
@property (nonatomic, assign) double enlargingLevel;      /**大眼 (0~1)*/
@property (nonatomic, assign) double thinningLevel;       /**瘦脸 (0~1)*/
@property (nonatomic, assign) double enlargingLevel_new;  /**大眼 (0~1) --  新版美颜*/
@property (nonatomic, assign) double thinningLevel_new;   /**瘦脸 (0~1) --  新版美颜*/

@property (nonatomic, assign) double jewLevel;            /**下巴 (0~1)*/
@property (nonatomic, assign) double foreheadLevel;       /**额头 (0~1)*/
@property (nonatomic, assign) double noseLevel;           /**鼻子 (0~1)*/
@property (nonatomic, assign) double mouthLevel;          /**嘴型 (0~1)*/

@property (nonatomic, strong) NSString *selectedFilter; /* 选中的滤镜 */
@property (nonatomic, assign) double selectedFilterLevel; /* 选中滤镜的 level*/

@property (nonatomic, strong)               NSString *selectedItem;     /**选中的道具名称*/

-(void)ckresetALLBeautParams;
- (void)resetAllBeautyParams;
- (void)setBeautyDefaultParameters;
@end

NS_ASSUME_NONNULL_END

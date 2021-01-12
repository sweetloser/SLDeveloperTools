//
//  TiSDKInterface.h
//  TiSDK
//
//  Created by Cat66 on 2018/5/10.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
/**
 * 初始化状态回调值
 */
typedef struct InitStatus {
    int code ;
    const char*message;
} InitStatus;
typedef void (^TiInitCallbackBlock)(InitStatus callBack);

/***************************
 * TiSDK初始化
 ***************************/
@interface TiSDK : NSObject

/**
 * 初始化函数一
 *
 * @param key TiSDK鉴权Key
 */
+ (TiSDK *)init:(NSString *)key;

/**
 * 初始化函数二
 *
 * @param key TiSDK在线鉴权Key
 * @param block 初始化回调block
 */
+ (TiSDK *)init:(NSString *)key CallBack:(TiInitCallbackBlock)block;

/**
 * 初始化函数三，适配最新版本swift
 *
 * @param key TiSDK在线鉴权Key
 * @param block 初始化回调block
 */
+ (TiSDK *)initSDK:(NSString *)key CallBack:(TiInitCallbackBlock)block;

/**
 * 初始化函数四
 *
 * @param license TiSDK离线鉴权License
 */
+ (TiSDK *)initOffline:(NSString *)license;

/**
 * 资源文件（贴纸、礼物、水印）URL是否获取成功通知名称
 */
#define TiResourceURLNotificationName @"TiResourceURLNotification"

/**
 * 贴纸文件URL地址设置函数
 */
+ (void)setStickerUrl:(NSString *)url;
/**
 * 贴纸文件URL地址获取函数
 */
+ (NSString *)getStickerURL;

/**
 * 贴纸IconURL地址设置函数
 */
+ (void)setStickerThumbUrl:(NSString *)url;
/**
 * 贴纸IconURL地址获取函数
 */
+ (NSString *)getStickerIconURL;

/**
 * 礼物文件URL地址设置函数
 */
+ (void)setGiftUrl:(NSString *)url;
/**
 * 礼物文件URL地址获取函数
 */
+ (NSString *)getGiftURL;

/**
 * 礼物IconURL地址设置函数
 */
+ (void)setGiftThumbUrl:(NSString *)url;
/**
 * 礼物IconURL地址获取函数
 */
+ (NSString *)getGiftIconURL;

/**
 * 水印文件URL地址设置函数
 */
+ (void)setWatermarkUrl:(NSString *)url;
/**
 * 水印文件URL地址获取函数
 */
+ (NSString *)getWatermarkURL;

/**
 * 水印IconURL地址设置函数
 */
+ (void)setWatermarkThumbUrl:(NSString *)url;
/**
 * 水印IconURL地址获取函数
 */
+ (NSString *)getWatermarkIconURL;

/**
 * 面具文件URL地址设置函数
 */
+ (void)setMaskUrl:(NSString *)url;
/**
 * 面具文件URL地址获取函数
 */
+ (NSString *)getMaskURL;

/**
 * 面具IconURL地址设置函数
 */
+ (void)setMaskThumbUrl:(NSString *)url;
/**
 * 面具IconURL地址获取函数
 */
+ (NSString *)getMaskIconURL;

/**
 * 绿幕文件URL地址设置函数
 */
+ (void)setGreenScreenUrl:(NSString *)url;
/**
 * 绿幕文件URL地址获取函数
 */
+ (NSString *)getGreenScreenURL;

/**
 * 绿幕IconURL地址设置函数
 */
+ (void)setGreenScreenThumbUrl:(NSString *)url;
/**
 * 绿幕IconURL地址获取函数
 */
+ (NSString *)getGreenScreenIconURL;

/**
 * 互动文件URL地址设置函数
 */
+ (void)setInteractionUrl:(NSString *)url;
/**
 * 互动文件URL地址获取函数
 */
+ (NSString *)getInteractionURL;

/**
 * 互动IconURL地址设置函数
 */
+ (void)setInteractionThumbUrl:(NSString *)url;
/**
 * 互动IconURL地址获取函数
 */
+ (NSString *)getInteractionIconURL;

/**
 * 美妆文件URL地址设置函数
 */
+ (void)setMakeupUrl:(NSString *)url;
/**
 * 美妆文件URL地址获取函数
 */
+ (NSString *)getMakeupURL;

/**
 * 美妆IconURL地址设置函数
 */
+ (void)setMakeupThumbUrl:(NSString *)url;

/**
 * 美妆IconURL地址获取函数
 */
+ (NSString *)getMakeupIconURL;

/**
* 模型文件沙盒路径
*/
+ (NSString *)getModelPath;

/**
 * 打开/关闭日志
 */
+ (void)setLog:(BOOL)enable;



@end

/****************************
 * TiSDK渲染管理器
 ***************************/
@interface TiSDKManager : NSObject

// 视频帧格式
typedef NS_ENUM(NSInteger, TiImageFormatEnum) {
    RGBA = 3,
    NV21 = 1,
    BGRA = 0,
    RGB = 2,
    NV12 = 4,
    I420 = 5
};

// 旋转角度
typedef NS_ENUM(NSInteger, TiRotationEnum){
    CLOCKWISE_0 = 0,
    CLOCKWISE_90 = 90,
    CLOCKWISE_180 = 180,
    CLOCKWISE_270 = 270
};

// Filter类型
typedef NS_ENUM(NSInteger, TiFilterEnum) {
    NO_FILTER = 0, // 无
    SKETCH_FILTER = 1, // 素描
    SOBELEDGE_FILTER = 2, // 黑边
    TOON_FILTER = 3, // 卡通
    EMBOSS_FILTER = 4, // 浮雕
    FILM_FILTER = 5, // 胶片
    PIXELLATION_FILTER = 6, // 马赛克
    HALFTONE_FILTER = 7, // 半色调
    CROSSHATCH_FILTER = 8, // 交叉线
    NASHVILLE_FILTER = 9, // 那舍尔
    COFFEE_FILTER = 10, // 咖啡
    CHOCOLATE_FILTER = 11, // 巧克力
    COCO_FILTER = 12, // 可可
    DELICIOUS_FILTER = 13, // 美味
    FIRSTLOVE_FILTER = 14, // 初恋
    FOREST_FILTER = 15, // 森林
    GLOSSY_FILTER = 16, // 光泽
    GRASS_FILTER = 17, // 禾草
    HOLIDAY_FILTER = 18, // 假日
    KISS_FILTER = 19, // 初吻
    LOLITA_FILTER = 20, // 洛丽塔
    MEMORY_FILTER = 21, // 回忆
    MOUSSE_FILTER = 22, // 慕斯
    NORMAL_FILTER = 23, // 标准
    OXGEN_FILTER = 24, // 氧气
    PLATYCODON_FILTER = 25, // 桔梗
    RED_FILTER = 26, // 赤红
    SUNLESS_FILTER = 27, // 冷日
    PINCH_DISTORTION_FILTER = 28, // 扭曲
    KUWAHARA_FILTER = 29, // 油画
    POSTERIZE_FILTER = 30, // 分色
    SWIRL_DISTORTION_FILTER = 31, // 漩涡
    VIGNETTE_FILTER = 32, // 光晕
    ZOOM_BLUR_FILTER = 33, // 眩晕
    POLKA_DOT_FILTER = 34, // 圆点
    POLAR_PIXELLATE_FILTER = 35, // 极坐标
    GLASS_SPHERE_REFRACTION_FILTER = 36, // 水晶球
    SOLARIZE_FILTER = 37, // 曝光
    INK_WASH_PAINTING_FILTER = 38, // 水墨
    ARABICA_FILTER = 39, // 阿拉比卡
    AVA_FILTER = 40, // 阿瓦
    AZREAL_FILTER = 41, // 艾瑟瑞尔
    BOURBON_FILTER = 42, // 波旁
    BYERS_FILTER = 43, // 拜尔斯
    CHEMICAL_FILTER = 44, // 化学
    CLAYTON_FILTER = 45, // 克莱顿
    CLOUSEAU_FILTER = 46, // 克卢索
    COBI_FILTER = 47, // 小新
    CONTRAIL_FILTER = 48, // 凝迹
    CUBICLE_FILTER = 49, // 隔间
    DJANGO_FILTER = 50, // 姜戈
    FUJI_REALA_FILTER = 90 // 真实
};

// Rock类型
typedef NS_ENUM(NSInteger, TiRockEnum) {
    NO_ROCK = 0, // 无抖音特效
    DAZZLED_COLOR_ROCK = 1, // 炫彩抖动
    LIGHT_COLOR_ROCK = 2, // 轻彩抖动
    DIZZY_GIDDY_ROCK = 3, // 头晕目眩
    ASTRAL_PROJECTION_ROCK = 4, // 灵魂出窍
    BLACK_MAGIC_ROCK = 5, // 暗黑魔法
    VIRTUAL_MIRROR_ROCK = 6, // 虚拟镜像
    DYNAMIC_SPLIT_SCREEN_ROCK = 7, //动感分屏
    BLACK_WHITE_FILM_ROCK = 8, // 黑白电影
    GRAY_PETRIFACTION_ROCK = 9, // 瞬间石化
    BULGE_DISTORTION__ROCK = 10 // 魔法镜面
};

// Distortion类型
typedef NS_ENUM(NSInteger, TiDistortionEnum) {
    NO_DISTORTION = 0, // 无
    ET_DISTORTION = 1, // 外星人
    PEAR_FACE_DISTORTION = 2, // 梨梨脸
    SLIM_FACE_DISTORTION = 3, // 瘦瘦脸
    SQUARE_FACE_DISTORTION = 4 // 方方脸
};

//// GreenScreen类型
//typedef NS_ENUM(NSInteger, TiGreenScreenEnum) {
//    NO_GREEN_SCREEN = 0, // 无
//    STARRY_SKY_GREEN_SCREEN = 1, // 星空
//    CLASS_ROOM_GREEN_SCREEN = 2, // 教室
//    THE_BUND_GREEN_SCREEN=3, // 外滩
//    IMPERIAL_PALACE_GREEN_SCREEN=4 // 故宫
//};

// Makeup类型
typedef NS_ENUM(NSInteger, TiMakeupEnum) {
    NO_MAKEUP = 0, // 无
    LIP_GLOSS_MAKEUP = 1, // 唇彩
    EYE_SHADWO_MAKEUP= 2, // 眼影
    BROW_PENCIL_MAKEUP = 3, // 描眉
    BLUSHER_MAKEUP = 4 // 腮红
};

+ (TiSDKManager *)shareManager;

/**
 * 纹理渲染接口函数
 *
 * @param texture2D 待渲染纹理
 * @param imageWidth 纹理宽度
 * @param imageHeight 纹理高度
 * @param rotation 纹理转为正向（home键向下）待旋转角度
 * @param isMirror 是否存在镜像
 *
 * @return 渲染后的纹理
 */
- (GLuint)renderTexture2D:(GLuint)texture2D Width:(CGFloat)imageWidth Height:(CGFloat)imageHeight Rotation:(TiRotationEnum)rotation Mirror:(BOOL)isMirror;

/**
 * 纹理渲染接口函数
 *
 * @param texture2D 待渲染纹理
 * @param imageWidth 纹理宽度
 * @param imageHeight 纹理高度
 * @param rotation 纹理转为正向（home键向下）待旋转角度
 * @param isMirror 是否存在镜像
 * @param faceNumber 人脸相关特效可支持的人脸数 [1, 5]
 *
 * @return 渲染后的纹理
 */
- (GLuint)renderTexture2D:(GLuint)texture2D Width:(CGFloat)imageWidth Height:(CGFloat)imageHeight Rotation:(TiRotationEnum)rotation Mirror:(BOOL)isMirror FaceNumber:(int)faceNumber;

/**
 * pixelBuffer渲染接口函数
 *
 * @param pixels 待渲染视频帧
 * @param imageWidth 纹理宽度
 * @param imageHeight 纹理高度
 * @param rotation 纹理转为正向（home键向下）待旋转角度
 * @param isMirror 是否存在镜像
 *
 */
- (void)renderPixels:(unsigned char *)pixels Format:(TiImageFormatEnum)imageFormat Width:(CGFloat)imageWidth Height:(CGFloat)imageHeight Rotation:(TiRotationEnum)rotation Mirror:(BOOL)isMirror;

/**
 * pixelBuffer渲染接口函数
 *
 * @param pixels 待渲染视频帧
 * @param imageWidth 纹理宽度
 * @param imageHeight 纹理高度
 * @param rotation 纹理转为正向（home键向下）待旋转角度
 * @param isMirror 是否存在镜像
 * @param faceNumber 人脸相关特效可支持的人脸数 [1, 5]
 *
 */
- (void)renderPixels:(unsigned char *)pixels Format:(TiImageFormatEnum)imageFormat Width:(CGFloat)imageWidth Height:(CGFloat)imageHeight Rotation:(TiRotationEnum)rotation Mirror:(BOOL)isMirror FaceNumber:(int)faceNumber;

/**
 * 开启/关闭美颜特效函数
 *
 * @param enable 是否开启美颜特效
 */
- (void)setBeautyEnable:(BOOL)enable;

/**
 * 设置美颜-美白特效参数函数
 *
 * @param param [0, 100]
 */
- (void)setSkinWhitening:(int)param;

/**
 * 设置美颜-磨皮特效参数函数
 *
 * @param param [0, 100]
 */
- (void)setSkinBlemishRemoval:(int)param;

/**
 * 设置美颜-饱和特效参数函数
 *
 * @param param [-50, 50]
 */
- (void)setSkinSaturation:(int)param;

/**
 * 设置美颜-粉嫩特效参数函数
 *
 * @param param [0, 100]
 */
- (void)setSkinTenderness:(int)param;

/**
 * 设置美颜-亮度特效参数函数
 *
 * @param param [-50, 50]
 */
- (void)setSkinBrightness:(int)param;

/**
 * 设置美颜-鲜明特效参数函数
 *
 * @param param [0, 100]
 */
- (void)setSkinSharpness:(int)param;

/**
 * 打开/关闭美型特效函数
 *
 * @param enable 是否打开美型特效
 */
- (void)setFaceTrimEnable:(BOOL)enable;

/**
 * 设置美型-大眼特效参数函数
 *
 * @param param [0, 100]
 */
- (void)setEyeMagnifying:(int)param;

/**
 * 设置美型-瘦脸特效参数函数
 *
 * @param param [0, 100]
 */
- (void)setChinSlimming:(int)param;

/**
 * 设置美型-下巴特效参数函数
 *
 * @param param [-50, 50]
 */
- (void)setJawTransforming:(int)param;

/**
 * 设置美型-额头特效参数函数
 *
 * @param param [-50, 50]
 */
- (void)setForeheadTransforming:(int)param;

/**
 * 设置美型-嘴型特效参数函数
 *
 * @param param [-50, 50]
 */
- (void)setMouthTransforming:(int)param;

/**
 * 设置美型-瘦鼻特效参数函数
 *
 * @param param [-50, 50]
 */
- (void)setNoseMinifying:(int)param;

/**
 * 设置美型-美牙特效参数函数
 *
 * @param param [0, 100]
 */
- (void)setTeethWhitening:(int)param;

/**
 * 设置美型-窄脸特效参数函数
 *
 * @param param [0, 100]
 */
- (void)setFaceNarrowing:(int)param;

/**
 * 设置美型-眼间距特效参数函数
 *
 * @param param [-50, 50]
 * 默认值为0
 * >0，缩小眼间距；<0，增大眼间距
 */
- (void)setEyeSpacing:(int)param;

/**
 * 设置美型-长鼻特效参数函数
 *
 * @param param [0, 100]
 * 默认值为0
 */
- (void)setNoseElongating:(int)param;

/**
 * 设置美型-眼角特效参数函数
 *
 * @param param [-50, 50]
 * 默认值为0
 */
- (void)setEyeCorners:(int)param;

/**
 * 切换贴纸函数
 *
 * @param stickerName 贴纸名称
 */
- (void)setStickerName:(NSString *)stickerName;

/**
 * 切换滤镜函数
 *
 * @param filterEnum 参考宏定义TiFilterEnum
 */
- (void)setFilterEnum:(TiFilterEnum)filterEnum;

/**
 * 切换滤镜并设置相应参数函数
 *
 * @param filterEnum 参考宏定义TiFilterEnum
 * @param param 滤镜参数
 */
- (void)setFilterEnum:(TiFilterEnum)filterEnum Param:(int)param;

/**
 * 设置Rock特效参数函数
 *
 * @param rockEnum 参考宏定义TiRockEnum
 */
- (void)setRockEnum:(TiRockEnum)rockEnum;

/**
 * 设置哈哈镜特效参数函数
 *
 * @param distortionEnum 参考宏定义TiDistortionEnum
 */
- (void)setDistortionEnum:(TiDistortionEnum)distortionEnum;

/**
 * 设置水印参数函数
 *
 * @param enable  true: 开启 false: 关闭
 * @param x         水印左上角横坐标[0, 100]
 * @param y         水印右上角纵坐标[0, 100]
 * @param ratio    水印横向占据屏幕的比例[0, 100]
 */
- (void)setWatermark:(BOOL)enable Left:(int)x Top:(int)y Ratio:(int)ratio FileName:(NSString *)fileName;

/**
 * 设置绿幕特效参数函数
 *
 * @param greenScreenName 幕布名称
 */
- (void)setGreenScreen:(NSString *)greenScreenName;

/**
 * 设置礼物特效参数函数
 *
 * @param giftName 礼物名称
 */
- (void)setGift:(NSString *)giftName;

/**
 * 设置面具特效参数函数
 *
 * @param maskName 面具名称
 */
- (void)setMask:(NSString *)maskName;

/**
 * 设置互动特效参数函数
 */
-(void)setInteraction:(NSString *)interactionName;

/**
 * 美妆特效开关函数
 *
 * @param enable 是否开启美妆
 */
- (void)setMakeupEnable:(bool)enable;

/**
 * 美妆-腮红特效开关函数
 *
 * @param name 腮红特效名称
 * @param param 腮红特效参数
 */
- (void)setBlusher:(NSString*)name Param:(int)param;

/**
 * 美妆-眉毛特效开关函数
 *
 * @param name 眉毛特效名称
 * @param param 眉毛特效参数
 */
- (void)setEyeBrow:(NSString*)name Param:(int)param;

/**
 * 美妆-睫毛特效开关函数
 *
 * @param name 睫毛特效名称
 * @param param 睫毛特效参数
 */
- (void)setEyeLash:(NSString*)name Param:(int)param;

/**
 * 渲染特效开关
 *
 * @param enable YES是打开渲染；NO是关闭开关
 */
-(void)setRenderEnable:(bool)enable;

/**
 * 资源释放函数
 */
- (void)destroy;

@end


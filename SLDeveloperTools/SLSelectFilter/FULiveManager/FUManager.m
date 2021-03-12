//
//  FUManager.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUManager.h"
#import <libCNamaSDK/CNamaSDK.h>
#import <libCNamaSDK/FURenderer.h>
#import "authpack.h"
#import <sys/utsname.h>
#import <CoreMotion/CoreMotion.h>
#import "FUMusicPlayer.h"
#import "HMItem.h"
#import "../SLSelectFilterHeader.h"
#import <MMKV/MMKV.h>
#import <YYCategories/YYCategories.h>

BeautyStatus bs = {0,@"",@""};

@interface FUManager ()
{
    int items[12];
    int frameID;
    
    dispatch_queue_t makeupQueue;
    dispatch_queue_t asyncLoadQueue;
}

@property (nonatomic, strong) EAGLContext *txContext;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) int deviceOrientation;
/* 重力感应道具 */
@property (nonatomic,assign) BOOL isMotionItem;
/* 当前加载的道具资源 */
@property (nonatomic,copy) NSString *currentBoudleName;
/* 需提示item */
@property (nonatomic, strong) NSDictionary *hintDic;

@end

static FUManager *shareManager = NULL;

@implementation FUManager

+ (FUManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUManager alloc] init];
    });
    
    return shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupDeviceMotion];
        makeupQueue = dispatch_queue_create("com.faceUMakeup", DISPATCH_QUEUE_SERIAL);
        asyncLoadQueue = dispatch_queue_create("com.faceLoadItem", DISPATCH_QUEUE_SERIAL);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"v3.bundle" ofType:nil];
        
        /**这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。
         还有设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。*/
        if (bs.code == 2) {
            NSData *data = [NSData dataWithBase64EncodedString:bs.key];
            char *auth_byte = (char *)data.bytes;
            [[FURenderer shareRenderer] setupWithDataPath:path authPackage:auth_byte authSize:(int)(data.length) shouldCreateContext:YES];
            
            dispatch_async(asyncLoadQueue, ^{

                   NSData *tongueData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tongue.bundle" ofType:nil]];
                   int ret0 = fuLoadTongueModel((void *)tongueData.bytes, (int)tongueData.length) ;
                   NSLog(@"fuLoadTongueModel %@",ret0 == 0 ? @"failure":@"success" );

               });

               [self setBeautyDefaultParameters];


               /* 提示语句 */
               [self setupItmeHintData];

               // 默认竖屏
            self.deviceOrientation = 0 ;
            fuSetDefalutOrientation() ;
               
               // 性能优先关闭
               self.performance = NO ;
        }

//        [[FURenderer shareRenderer] setupWithDataPath:path authPackage:&auth_keykey authSize:sizeof(auth_keykey) shouldCreateContext:YES];
    }
    
    return self;
}

-(void)setupItmeHintData{
    self.hintDic = @{
                @"future_warrior":@"张嘴试试",
                @"jet_mask":@"鼓腮帮子",
                @"sdx2":@"皱眉触发",
                @"luhantongkuan_ztt_fu":@"眨一眨眼",
                @"qingqing_ztt_fu":@"嘟嘴试试",
                @"xiaobianzi_zh_fu":@"微笑触发",
                @"xiaoxueshen_ztt_fu":@"吹气触发",
                @"hez_ztt_fu":@"张嘴试试",
                @"fu_lm_koreaheart":@"单手手指比心",
                @"fu_zh_baoquan":@"双手抱拳",
                @"fu_zh_hezxiong":@"双手合十",
                @"fu_ztt_live520":@"双手比心",
                @"ssd_thread_thumb":@"竖个拇指",
                @"ssd_thread_six":@"比个六",
                @"ssd_thread_cute":@"双拳靠近脸颊卖萌",
                @"ctrl_rain":@"推出手掌",
                @"ctrl_snow":@"推出手掌",
                @"ctrl_flower":@"推出手掌",
                };
}

- (void)loadItems
{
    /**加载普通道具*/
    [self loadItem:self.selectedItem];
    NSLog(@"版本--%@--",[FURenderer getVersion]);
    /**加载美颜道具*/
    [self loadFilter];
}


/**销毁全部道具*/
- (void)destoryItems{
    dispatch_async(asyncLoadQueue, ^{
        if ([EAGLContext currentContext] != self.txContext){
            [EAGLContext setCurrentContext:self.txContext];
        }
        
//        [FURenderer destroyAllItems];
        fuDestroyAllItems();
        fuOnDeviceLost();
        fuOnCameraChange();
        /**销毁道具后，为保证被销毁的句柄不再被使用，需要将int数组中的元素都设为0*/
        for (int i = 0; i < sizeof(self->items) / sizeof(int); i++) {
            self->items[i] = 0;
        }
        
        /**销毁道具后，清除context缓存*/
//        [FURenderer OnDeviceLost];
        /**销毁道具后，重置人脸检测*/
//        [FURenderer onCameraChange];
    });
}

/**销毁老道具句柄*/
- (void)destoryItemAboutType:(FUNamaHandleType)type;
{
    /**后销毁老道具句柄*/
    if (items[type] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[type]];
        items[type] = 0;
    }
}

/**加载手势识别道具，默认未不加载*/
- (void)loadGesture
{
    dispatch_async(asyncLoadQueue, ^{
        if (self->items[FUNamaHandleTypeGesture] != 0) {
            NSLog(@"faceunity: destroy gesture");
            [FURenderer destroyItem:self->items[FUNamaHandleTypeGesture]];
            self->items[FUNamaHandleTypeGesture] = 0;
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:@"heart_v2.bundle" ofType:nil];
        self->items[FUNamaHandleTypeGesture] = [FURenderer itemWithContentsOfFile:path];
    });
}
/*
 is3DFlipH 翻转模型
 isFlipExpr 翻转表情
 isFlipTrack 翻转位置和旋转
 isFlipLight 翻转光照
 */
- (void)set3DFlipH
{
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"is3DFlipH" value:@(1)];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"isFlipExpr" value:@(1)];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"isFlipTrack" value:@(1)];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"isFlipLight" value:@(1)];
}

- (void)setLoc_xy_flip
{
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"loc_x_flip" value:@(1)];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"loc_y_flip" value:@(1)];
}

- (void)musicFilterSetMusicTime
{
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"music_time" value:@([FUMusicPlayer sharePlayer].currentTime * 1000 + 50)];//需要加50ms的延迟
}

/**加载美颜道具*/
- (void)loadFilter{
    dispatch_async(asyncLoadQueue, ^{
        NSLog(@"aaaaa111");
        if (self->items[FUMNamaHandleTypeBeauty] == 0) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
            self->items[FUMNamaHandleTypeBeauty] = [FURenderer itemWithContentsOfFile:path];
        }
    });
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

/**设置美颜参数*/
- (void)resetAllBeautyParams{
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"skin_detect" value:@(self.skinDetectEnable)]; //是否开启皮肤检测
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"heavy_blur" value:@(self.blurShape)]; // 美肤类型 (0、1、) 清晰：0，朦胧：1
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"blur_level" value:@(self.blurLevel * 6.0 )]; //磨皮 (0.0 - 6.0)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"blur_type" value:@(0)]; //磨皮精细度
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"color_level" value:@(self.whiteLevel)]; //美白 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"red_level" value:@(self.redLevel)]; //红润 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"eye_bright" value:@(self.eyelightingLevel)]; // 亮眼
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"tooth_whiten" value:@(self.beautyToothLevel)];// 美牙
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"face_shape" value:@(self.faceShape)]; //美型类型 (0、1、2、3、4)女神：0，网红：1，自然：2，默认：3，自定义：4
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"eye_enlarging" value:@(self.enlargingLevel)]; //大眼 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"cheek_thinning" value:@(self.thinningLevel)]; //瘦脸 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_chin" value:@(self.jewLevel)]; /**下巴 (0~1)*/
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_nose" value:@(self.noseLevel)];/**鼻子 (0~1)*/
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_forehead" value:@(self.foreheadLevel)];/**额头 (0~1)*/
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_mouth" value:@(self.mouthLevel)];/**嘴型 (0~1)*/
    //滤镜名称需要小写
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"filter_name" value:[self.selectedFilter lowercaseString]];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"filter_level" value:@(self.selectedFilterLevel)]; //滤镜程度
}

//外部重置美颜参数
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
    
    
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"skin_detect" value:@(self.skinDetectEnable)]; //是否开启皮肤检测
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"heavy_blur" value:@(self.blurShape)]; // 美肤类型 (0、1、) 清晰：0，朦胧：1
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"blur_level" value:@(self.blurLevel * 6.0 )]; //磨皮 (0.0 - 6.0)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"color_level" value:@(self.whiteLevel)]; //美白 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"red_level" value:@(self.redLevel)]; //红润 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"eye_bright" value:@(self.eyelightingLevel)]; // 亮眼
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"tooth_whiten" value:@(self.beautyToothLevel)];// 美牙
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"face_shape" value:@(self.faceShape)]; //美型类型 (0、1、2、3、4)女神：0，网红：1，自然：2，默认：3，自定义：4
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"eye_enlarging" value:@(self.enlargingLevel)]; //大眼 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"cheek_thinning" value:@(self.thinningLevel)]; //瘦脸 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_chin" value:@(self.jewLevel)]; /**下巴 (0~1)*/
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_nose" value:@(self.noseLevel)];/**鼻子 (0~1)*/
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_forehead" value:@(self.foreheadLevel)];/**额头 (0~1)*/
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_mouth" value:@(self.mouthLevel)];/**嘴型 (0~1)*/
    //滤镜名称需要小写
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"filter_name" value:[self.selectedFilter lowercaseString]];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"filter_level" value:@(self.selectedFilterLevel)]; //滤镜程度
    
}


/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItem:(NSString *)itemName{
    dispatch_async(asyncLoadQueue, ^{
        self.selectedItem = itemName ;
        
        int destoryItem = items[FUMNamaHandleTypeItem];
        
        if (itemName != nil && ![itemName isEqual: @"noitem"]) {
            /**先创建道具句柄*/
            NSString *path = [HMItem allFilePathWithName:itemName];
            int itemHandle = [FURenderer itemWithContentsOfFile:path];
            
            if ([itemName isEqualToString:@"luhantongkuan_ztt_fu"]) {
                [FURenderer itemSetParam:itemHandle withName:@"flip_action" value:@(1)];
            }
            
            if ([itemName isEqualToString:@"ctrl_rain"] || [itemName isEqualToString:@"ctrl_snow"] || [itemName isEqualToString:@"ctrl_flower"]) {//带重力感应道具
                [FURenderer itemSetParam:itemHandle withName:@"rotMode" value:@(self.deviceOrientation)];
                self.isMotionItem = YES;
            }else{
                self.isMotionItem = NO;
            }
            
            if ([itemName isEqualToString:@"fu_lm_koreaheart"]) {//比心道具手动调整下
                 [FURenderer itemSetParam:itemHandle withName:@"handOffY" value:@(-100)];
            }
            /**将刚刚创建的句柄存放在items[FUMNamaHandleTypeItem]中*/
            items[FUMNamaHandleTypeItem] = itemHandle;
            
        }else{
            /**为避免道具句柄被销毁会后仍被使用导致程序出错，这里需要将存放道具句柄的items[FUMNamaHandleTypeItem]设为0*/
            items[FUMNamaHandleTypeItem] = 0;
        }
        NSLog(@"faceunity: load item");
        
        /**后销毁老道具句柄*/
        if (destoryItem != 0)
        {
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:destoryItem];
        }
    });
 
}


#pragma mark -  render
/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer flip:(BOOL)flip
{
	// 在未识别到人脸时根据重力方向设置人脸检测方向
    if ([self isDeviceMotionChange]) {
        fuSetDefalutOrientation();
        
    }
    if (self.isMotionItem) {//针对带重力道具
        [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"rotMode" value:@(self.deviceOrientation)];
    }    
    /**设置美颜参数*/
    [self resetAllBeautyParams];
    
    /*Faceunity核心接口，将道具及美颜效果绘制到pixelBuffer中，执行完此函数后pixelBuffer即包含美颜及贴纸效果*/
    CVPixelBufferRef buffer = [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:NO];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    return buffer;
}
#pragma mark -  nama查询&设置
- (void)setAsyncTrackFaceEnable:(BOOL)enable{
    [FURenderer setAsyncTrackFaceEnable:enable];
}

- (void)setEnableGesture:(BOOL)enableGesture
{
    _enableGesture = enableGesture;
    /**开启手势识别*/
    if (_enableGesture) {
        [self loadGesture];
    }else{
        if (items[FUNamaHandleTypeGesture] != 0) {
            
            NSLog(@"faceunity: destroy gesture");
            
            [FURenderer destroyItem:items[FUNamaHandleTypeGesture]];
            
            items[FUNamaHandleTypeGesture] = 0;
        }
    }
}

/**开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内*/
- (void)setEnableMaxFaces:(BOOL)enableMaxFaces
{
    if (_enableMaxFaces == enableMaxFaces) {
        return;
    }
    
    _enableMaxFaces = enableMaxFaces;
    
    if (bs.code == 2) {
        if (_enableMaxFaces) {
            [FURenderer setMaxFaces:4];
        }else{
            [FURenderer setMaxFaces:1];
        }
    }
}

/**获取图像中人脸中心点*/
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize{
    
    static CGPoint preCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preCenter = CGPointMake(0.49, 0.5);
    });
    
    // 获取人脸矩形框，坐标系原点为图像右下角，float数组为矩形框右下角及左上角两个点的x,y坐标（前两位为右下角的x,y信息，后两位为左上角的x,y信息）
    float faceRect[4];
    int ret = [FURenderer getFaceInfo:0 name:@"face_rect" pret:faceRect number:4];
    
    if (ret == 0) {
        return preCenter;
    }
    
    // 计算出中心点的坐标值
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    
    // 将坐标系转换成以左上角为原点的坐标系
    centerX = frameSize.width - centerX;
    centerX = centerX / frameSize.width;
    
    centerY = frameSize.height - centerY;
    centerY = centerY / frameSize.height;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    preCenter = center;
    
    return center;
}
/**将道具绘制到pixelBuffer*/

- (int)renderItemWithTexture:(int)texture Width:(int)width Height:(int)height {
    if ([EAGLContext currentContext] != self.txContext) {
        self.txContext = [EAGLContext currentContext];
        NSLog(@"上下文修改-----------%@---%@",self.txContext,[EAGLContext currentContext]);
    }
    [self resetAllBeautyParams];

    [self prepareToRender];
    
    fuRenderItemsEx(FU_FORMAT_RGBA_TEXTURE, &texture, FU_FORMAT_RGBA_TEXTURE, &texture, width, height, frameID, items, sizeof(items)/sizeof(int)) ;
    
    [self renderFlush];
    
    frameID ++ ;
    
    return texture;
}
/**将道具绘制到texture*/
- (int)renderItemWithTexture:(int)texture Width:(int)width Height:(int)height flipx:(BOOL)flip{
    if ([EAGLContext currentContext] != self.txContext) {
        self.txContext = [EAGLContext currentContext];
        NSLog(@"上下文修改-----------%@---%@",self.txContext,[EAGLContext currentContext]);
    }
    [self resetAllBeautyParams];
    
    [self prepareToRender];
    
    if (flip) {
        fuRenderItemsEx2(FU_FORMAT_RGBA_TEXTURE, &texture, FU_FORMAT_RGBA_TEXTURE, &texture, width, height, frameID, items, sizeof(items)/sizeof(int), NAMA_RENDER_OPTION_FLIP_X | NAMA_RENDER_FEATURE_FULL, NULL);
    }else{
        fuRenderItemsEx2(FU_FORMAT_RGBA_TEXTURE, &texture, FU_FORMAT_RGBA_TEXTURE, &texture, width, height, frameID, items, sizeof(items)/sizeof(int), NAMA_RENDER_FEATURE_FULL, NULL);
    }
    
    [self renderFlush];
    
    frameID ++ ;
    
    return texture;
}

// 此方法用于提高 FaceUnity SDK 和 腾讯 SDK 的兼容性
static int enabled[10];
- (void)prepareToRender {
    for (int i = 0; i<10; i++) {
        glGetVertexAttribiv(i,GL_VERTEX_ATTRIB_ARRAY_ENABLED,&enabled[i]);
    }
}

// 此方法用于提高 FaceUnity SDK 和 腾讯 SDK 的兼容性
- (void)renderFlush {
    glFlush();
    
    for (int i = 0; i<10; i++) {
        
        if(enabled[i]){
            glEnableVertexAttribArray(i);
        }
        else{
            glDisableVertexAttribArray(i);
        }
    }
}
/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks index:(int)index;
{
    int ret = [FURenderer getFaceInfo:index name:@"landmarks" pret:landmarks number:150];
    
    if (ret == 0) {
        memset(landmarks, 0, sizeof(float)*150);
    }
}

- (CGRect)getFaceRectWithIndex:(int)index size:(CGSize)renderImageSize{
    CGRect rect = CGRectZero ;
    float faceRect[4];
    
    [FURenderer getFaceInfo:index name:@"face_rect" pret:faceRect number:4];
    
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    CGFloat width = faceRect[2] - faceRect[0] ;
    CGFloat height = faceRect[3] - faceRect[1] ;
    
    centerX = renderImageSize.width - centerX;
    centerX = centerX / renderImageSize.width;
    
    centerY = renderImageSize.height - centerY;
    centerY = centerY / renderImageSize.height;
    
    width = width / renderImageSize.width ;
    
    height = height / renderImageSize.height ;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    CGSize size = CGSizeMake(width, height) ;
    
    rect.origin = CGPointMake(center.x - size.width / 2.0, center.y - size.height / 2.0) ;
    rect.size = size ;
    
    
    return rect ;
}


/**判断是否检测到人脸*/
- (BOOL)isTracking
{
    return [FURenderer isTracking] > 0;
}

/**切换摄像头要调用此函数*/
- (void)onCameraChange{
    [FURenderer onCameraChange];
}

/**获取错误信息*/
- (NSString *)getError
{
    // 获取错误码
    int errorCode = fuGetSystemError();
    
    if (errorCode != 0) {
        
        // 通过错误码获取错误描述
        NSString *errorStr = [NSString stringWithUTF8String:fuGetSystemErrorString(errorCode)];
        
        return errorStr;
    }
    
    return nil;
}


/**判断 SDK 是否是 lite 版本**/
- (BOOL)isLiteSDK {
    NSString *version = [FURenderer getVersion];
    return [version containsString:@"lite"];
}


//保证正脸
-(BOOL)isGoodFace:(int)index{
    // 保证正脸
    float rotation[4] ;
    float DetectionAngle = 15.0 ;
    [FURenderer getFaceInfo:index name:@"rotation" pret:rotation number:4];
    
    float q0 = rotation[0];
    float q1 = rotation[1];
    float q2 = rotation[2];
    float q3 = rotation[3];
    
    float z =  atan2(2*(q0*q1 + q2 * q3), 1 - 2*(q1 * q1 + q2 * q2)) * 180 / M_PI;
    float y =  asin(2 *(q0*q2 - q1*q3)) * 180 / M_PI;
    float x = atan(2*(q0*q3 + q1*q2)/(1 - 2*(q2*q2 + q3*q3))) * 180 / M_PI;
    NSLog(@"x=%lf  y=%lf z=%lf",x,y,z);
    if (x > DetectionAngle || x < - 5 || fabs(y) > DetectionAngle || fabs(z) > DetectionAngle) {//抬头低头角度限制：仰角不大于5°，俯角不大于15°
        return NO;
    }
    
    return YES;
}

/* 是否夸张 */
-(BOOL)isExaggeration:(int)index{
    float expression[46] ;
    [FURenderer getFaceInfo:index name:@"expression" pret:expression number:46];
    
    for (int i = 0 ; i < 46; i ++) {
        
        if (expression[i] > 0.60) {
            
            return YES;
        }
    }
    return NO;
}


#pragma mark -  其他
/**
 获取item的提示语
 
 @param item 道具名
 @return 提示语
 */
- (NSString *)hintForItem:(NSString *)item
{
    return self.hintDic[item];
}

#pragma mark -  重力感应
-(void)setupDeviceMotion{
    
    // 初始化陀螺仪
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.5;// 1s刷新一次
    
    if ([self.motionManager isDeviceMotionAvailable]) {
       [self.motionManager startAccelerometerUpdates];
    }
}

#pragma mark -  设备类型 
-(BOOL)isDeviceMotionChange{
    if (![FURenderer isTracking]) {
        CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration ;
        int orientation = 0;
        if (acceleration.x >= 0.75) {
            orientation = 3;
        } else if (acceleration.x <= -0.75) {
            orientation = 1;
        } else if (acceleration.y <= -0.75) {
            orientation = 0;
        } else if (acceleration.y >= 0.75) {
            orientation = 2;
        }
        
        if (self.deviceOrientation != orientation) {
            self.deviceOrientation = orientation ;
            return YES;
        }
    }
    return NO;
}

@end

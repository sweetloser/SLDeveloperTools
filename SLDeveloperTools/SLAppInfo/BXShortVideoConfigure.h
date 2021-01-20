//
//  BXShortVideoConfigure.h
//  BXlive
//
//  Created by sweetloser on 2020/4/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TXLiteAVSDK_Professional/TXUGCRecord.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SLMeiYanSDKTypeTH,
    SLMeiYanSDKTypeOther,
} SLMeuYanSdkType;

/**
 *  短视频录制VC
 */
@interface BXShortVideoConfigure : NSObject
@property(nonatomic,assign)TXVideoAspectRatio videoRatio;
@property(nonatomic,assign)TXVideoResolution videoResolution;
@property(nonatomic,assign)int bps;
@property(nonatomic,assign)int fps;
@property(nonatomic,assign)int gop;

//SL 新增 2020-04-23 （用于判断当前用户使用的是哪个美颜  拓幻 or --）
@property(nonatomic,assign)SLMeuYanSdkType sdkType;
@end

NS_ASSUME_NONNULL_END

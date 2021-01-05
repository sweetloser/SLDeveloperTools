//
//  BXliveWatcerHelp.h
//  BXlive
//
//  Created by bxlive on 2019/6/25.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BXVideoWatcerHelp : NSObject

/**
 处理水印gpu
 @param videoPath 视频本地的路径
 @param waterImg 水印图片
 @param name 水印文字
 @param isShow 是否显示蒙版
 @param isSavePhotos 是否保存本地相册
 @param isCover 是否得到封面路径
 @param completion 得到本地路径
 */
+ (void)watermarkingWithVideoUrl:(NSURL *)videoUrl waterImg:(NSString *)waterImg text:(NSString *)text isShow:(BOOL)isShow completion:(void ((^)(NSString *videofilePath)))completion isSystem:(BOOL)isSystem;

@end

NS_ASSUME_NONNULL_END

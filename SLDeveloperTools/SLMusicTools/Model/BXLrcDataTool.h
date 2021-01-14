//
//  BXLrcDataTool.h
//  BXlive
//
//  Created by bxlive on 2019/6/12.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXLrcModel;

@interface BXLrcDataTool : NSObject

/**
 *  根据歌词文件名称获取歌词
 *
 *  @param path 歌词路径
 *
 *  @return 歌词数组
 */
+ (NSArray <BXLrcModel *> *)getLrcModelsWithPath:(NSString *)path;

/**
 *  根据歌曲播放当前时间和歌词获取当前歌词行号
 *
 *  @param currentTime 歌曲播放当前的时间
 *  @param lrcModels   歌词数组
 *
 *  @return 行号
 */
+ (NSInteger)getRowWithCurrentTime:(NSTimeInterval)currentTime lrcModels:(NSArray <BXLrcModel *> *)lrcModels;

@end



//
//  BXLrcDataTool.m
//  BXlive
//
//  Created by bxlive on 2019/6/12.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXLrcDataTool.h"
#import "BXLrcModel.h"

@implementation BXLrcDataTool

/**
 *  根据歌词名称, 解析歌词
 *
 *  @param fileName 歌词名称
 *
 *  @return 歌词数据模型组成的数据
 */
+ (NSArray<BXLrcModel *> *)getLrcModelsWithPath:(NSString *)path {
    NSString *lyricStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //分隔整首歌词
    NSArray *lyricArr = [lyricStr componentsSeparatedByString:@"\n"];
    //正则匹配时间字符串[**:**.**],遍历单句歌词组成的数组
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"\\[[0-9]{2}:[0-9]{2}.[0-9]{2}\\]" options:0 error:nil];
    
    NSMutableArray *temArrM = [[NSMutableArray alloc] init];
    
    for(NSString *aLyric in lyricArr) {
        NSArray *resultArr = [expression matchesInString:aLyric options:0 range:NSMakeRange(0, aLyric.length)];
        //歌词内容
        NSTextCheckingResult *lastResult = resultArr.lastObject;
        NSString *aLyricStr =[aLyric substringFromIndex:(lastResult.range.location + lastResult.range.length)];
        
        for(NSTextCheckingResult *result in resultArr) {
            //截取时间字符串
            NSString *timeStr = [aLyric substringWithRange:NSMakeRange(result.range.location, result.range.length)];
            BXLrcModel *lrcModel = [[BXLrcModel alloc] init];
            lrcModel.beginTime = [self transformStringToTimeIntervalWithTimeString:timeStr];
            lrcModel.lrcText = aLyricStr;
            [temArrM addObject:lrcModel];
        }
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:true];
    NSArray *lyricSortedArr = [temArrM sortedArrayUsingDescriptors:@[descriptor]];
    
    // 得到结束时间
    NSInteger count = lyricSortedArr.count;
    for (NSInteger i = 0; i < count; i ++) {
        BXLrcModel *nowModel = lyricSortedArr[i];
        if (i < count - 1) {
            BXLrcModel *nextModel = lyricSortedArr[i + 1];
            nowModel.endTime = nextModel.beginTime;
        } else {
            if (nowModel.lrcText && nowModel.lrcText.length) {
                NSInteger preIndex = i - 1;
                if (preIndex >= 0) {
                    BXLrcModel *preModel = lyricSortedArr[i - 1];
                    if (preModel.lrcText && preModel.lrcText.length) {
                        CGFloat preDuration = preModel.endTime - preModel.beginTime;
                        CGFloat nowDuration = nowModel.lrcText.length * preDuration / preModel.lrcText.length;
                        nowModel.endTime = nowModel.beginTime + nowDuration;
                    }
                }
            }
        }
    }
    return lyricSortedArr;
}

/**
 *  根据当前时间何歌词数据模型组成的数据, 获取对应的应该播放的歌词数据模型
 *
 *  @param currentTime 当前时间
 *  @param lrcModels   歌词数据模型数组
 *
 *  @return 索引
 */
+ (NSInteger)getRowWithCurrentTime:(NSTimeInterval)currentTime lrcModels:(NSArray<BXLrcModel *> *)lrcModels
{
    NSInteger count = lrcModels.count;
    if (count) {
        BXLrcModel *fLrcModel = lrcModels[0];
        if (currentTime < fLrcModel.beginTime) {
            return 0;
        }
    }
    
    for (NSInteger i = 0; i < count; i ++) {
        BXLrcModel *lrcModel = lrcModels[i];
        if (currentTime >= lrcModel.beginTime && currentTime < lrcModel.endTime) {
            return i;
        }
    }
    
    // 如果都没查找到, 并且是存在时间, 是当做最后一行处理, 防止跳回到第一行
    if (currentTime > 0) {
        return count - 1;
    }
    return 0;
}

#pragma mark ---- 将时间字符串转换成时间间隔
+ (NSTimeInterval)transformStringToTimeIntervalWithTimeString:(NSString *)timeStr {
    //初始化时间格式对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"[mm:ss.SS]";
    //转换日期格式对象
    NSDate *targetDate = [formatter dateFromString:timeStr];
    //初始化初始时间
    NSDate *initDate = [formatter dateFromString:@"[00:00.00"];
    return [targetDate timeIntervalSinceDate:initDate];
}

@end


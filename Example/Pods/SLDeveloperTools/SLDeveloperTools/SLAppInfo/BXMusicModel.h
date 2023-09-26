//
//  BXMusicModel.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXMusicModel : BaseObject
/** 音乐id */
@property (nonatomic, copy) NSString * music_id;
/** 音乐名称 */
@property (nonatomic, copy) NSString * title;
/** 作者 */
@property (nonatomic, copy) NSString * singer;
/** 图片 */
@property (nonatomic, copy) NSString * image;
/** 是否收藏 */
@property (nonatomic, copy) NSString * is_collect;
/** 网络地址 */
@property (nonatomic, copy) NSString * link;
/** 歌词 */
@property (nonatomic , copy) NSString * lrc;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelect;
/** 时长 */
@property (nonatomic, copy) NSString * duration_str;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString * use_num;

@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;


@property (nonatomic, strong) NSURL *audioFileURL;


- (NSString *)allFilePath;
- (NSString *)lyricFilePath;

@end

NS_ASSUME_NONNULL_END

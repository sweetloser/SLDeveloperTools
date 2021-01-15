//
//  BXKSongVC.h
//  BXlive
//
//  Created by bxlive on 2019/6/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"
@class BXMusicModel;
NS_ASSUME_NONNULL_BEGIN

@interface BXKSongVC : BaseVC

@property(nonatomic,copy)void(^musicAndLyricPathBlock)(BXMusicModel *model);

+ (void)downloadMusic:(BXMusicModel *)music isDownLyric:(BOOL)lyric completion:(void (^)(BXMusicModel *music))completion;

@end

NS_ASSUME_NONNULL_END

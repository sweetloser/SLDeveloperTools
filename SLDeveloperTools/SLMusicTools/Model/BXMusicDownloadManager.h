//
//  BXMusicDownloadManager.h
//  BXlive
//
//  Created by bxlive on 2019/4/29.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXMusicDownloadManager : NSObject

+ (BXMusicDownloadManager *)shareMusicDownloadManager;

+ (void)downloadMusic:(BXMusicModel *)music isDownLyric:(BOOL)isDownLyric completion:(void (^)(BXMusicModel *music))completion;

@end

NS_ASSUME_NONNULL_END

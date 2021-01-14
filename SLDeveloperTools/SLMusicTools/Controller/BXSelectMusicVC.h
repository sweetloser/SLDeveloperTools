//
//  BXSelectMusicVC.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXSelectMusicVC : BaseVC

@property(nonatomic,copy)void(^musicPathBlock)(BXMusicModel *model);
@property(nonatomic,copy)void(^closeMusicBlock)();

+ (void)downloadMusic:(BXMusicModel *)music completion:(void (^)(BXMusicModel *music))completion;

@end

NS_ASSUME_NONNULL_END

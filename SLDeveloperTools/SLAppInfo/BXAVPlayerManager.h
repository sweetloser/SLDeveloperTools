//
//  BXAVPlayerManager.h
//  BXlive
//
//  Created by bxlive on 2019/2/28.
//  Copyright © 2019 cat. All rights reserved.
//

#import "ZFAVPlayerManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BXAVPlayerManagerVideoPlayRecommended,  //推荐
    BXAVPlayerManagerVideoPlayFocusOn,  //关注
    BXAVPlayerManagerVideoPlayDynamicNew,  //动态-最新
    BXAVPlayerManagerVideoPlayDynamicNearBy,  //动态-附近
    BXAVPlayerManagerVideoPlayDynamicCircle,  //动态-圈子
    BXAVPlayerManagerVideoPlayOthers,  //其他
} BXAVPlayerManagerType;

@interface BXAVPlayerManager : ZFAVPlayerManager

-(instancetype)initWithTpye:(BXAVPlayerManagerType)type;

@end

NS_ASSUME_NONNULL_END

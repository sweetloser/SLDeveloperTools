//
//  TXLivePlayer+PlayType.h
//  BXlive
//
//  Created by bxlive on 2018/12/26.
//  Copyright © 2018 cat. All rights reserved.
//

#import <TXLiteAVSDK_Professional/TXLivePlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXLivePlayer (PlayType)

+ (TX_Enum_PlayType)getTXEnumPlayTypeWithPullUrl:(NSString *)pullUrl;

@end

NS_ASSUME_NONNULL_END

//
//  TXLivePlayer+PlayType.m
//  BXlive
//
//  Created by bxlive on 2018/12/26.
//  Copyright © 2018 cat. All rights reserved.
//

#import "TXLivePlayer+PlayType.h"

@implementation TXLivePlayer (PlayType)

+ (TX_Enum_PlayType)getTXEnumPlayTypeWithPullUrl:(NSString *)pullUrl {
    TX_Enum_PlayType playType = PLAY_TYPE_LIVE_RTMP;
    if ([pullUrl hasPrefix:@"rtmp:"]) {
        if ([pullUrl containsString:@"bizid"]) {
            playType = PLAY_TYPE_LIVE_RTMP_ACC;
        }
    } else if ([pullUrl hasSuffix:@"flv"]) {
        playType = PLAY_TYPE_LIVE_FLV;
    }else if ([pullUrl hasSuffix:@"mp4"]) {
        playType = PLAY_TYPE_VOD_MP4;
    }
    return playType;
}

@end

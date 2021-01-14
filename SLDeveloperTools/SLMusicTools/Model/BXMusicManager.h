//
//  BXMusicManager.h
//  BXlive
//
//  Created by bxlive on 2019/4/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    RepeatPlayMode,
    RepeatOnlyOnePlayMode,
    ShufflePlayMode,
} ShuffleAndRepeatState;

@interface BXMusicManager : NSObject

@property (nonatomic,strong) AVPlayer *play;
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,assign) ShuffleAndRepeatState shuffleAndRepeatState;
@property (nonatomic,assign) NSInteger playingIndex;

+ (BXMusicManager *)sharedManager;
-(void) setPlayItem: (NSString *)songURL;
-(void) setPlay;
-(void) startPlay;
-(void) pausePlay;
-(void) stopPlay;
-(void) play: (NSString *)songURL;

@property(nonatomic,copy)void(^playerFinish)();

@end




//
//  BXMusicManager.m
//  BXlive
//
//  Created by bxlive on 2019/4/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicManager.h"
#import <YYCategories/YYCategories.h>

@implementation BXMusicManager


static BXMusicManager *_sharedManager = nil;

+(BXMusicManager *)sharedManager {
    @synchronized( [BXMusicManager class] ){
        if(!_sharedManager)
            _sharedManager = [[self alloc] init];
        return _sharedManager;
    }
    return nil;
}


-(void) setPlayItem: (NSString *)songURL {
    NSURL * url  = [NSURL URLWithString:songURL];
    _playerItem = [[AVPlayerItem alloc] initWithURL:url];
}

-(void) setPlay {
    _play = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
    _play.volume = 1;
}

-(void) startPlay {
    [_play play];
    @weakify(self);
    
     [_play addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
         CGFloat progress = CMTimeGetSeconds(self.play.currentItem.currentTime) / CMTimeGetSeconds(self.play.currentItem.duration);
         //在这里截取播放进度并处理
         if (progress == 1.0f) {
             [self.play pause];
             self.playerItem = nil;
             self.play = nil;
             if (self.playerFinish) {
                 self.playerFinish();
             }
         }
    }];
    
}

-(void)pausePlay{
    [_play pause];
}

-(void) stopPlay {
    [_play pause];
    _play = nil;
    _playerItem = nil;
}

-(void) play: (NSString *)songURL {
    
    [self setPlayItem:songURL];
    [self setPlay];
    [self startPlay];
    
}


@end



//
//  DynPlayMp3Voice.m
//  BXlive
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DynPlayMp3Voice.h"
#import <AVFoundation/AVFoundation.h>
@interface DynPlayMp3Voice()<AVAudioPlayerDelegate>

@property (nonatomic,strong) NSTimer *playStatusTimer;
@property (nonatomic,assign) NSInteger residueTime;
@end
@implementation DynPlayMp3Voice

-(void)StartPlayWithplaypath:(NSString *)path{
    if (_player) {
        [self StopPlay];
//        _player = nil;
    }
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path]error:nil];
    _playPath = path;
    
    self.player.delegate = self;
    //开始播放
//    [self.player prepareToPlay];
    //播放
//    [self.player play];
//    NSString *timestr = [self getFormatString:self.player.duration];
//    if ([self.player play]) {
//        [self.delegate startPlaySound];
//        [self.playStatusTimer setFireDate:[NSDate distantPast]];
//
//    }
    if ([self.delegate respondsToSelector:@selector(getTime:)]) {
        [self.delegate getTime:[self getFormatString:self.player.duration]];
    }
    if ([self.delegate respondsToSelector:@selector(getDurationTime:)]) {
        [self.delegate getDurationTime:[NSString stringWithFormat:@"%ld",(long)self.player.duration]];
    }

}
-(void)startPlay{
    [self.player prepareToPlay];
    //播放
    [self.player play];
    if ([self.delegate respondsToSelector:@selector(ReturnDuratime:)]) {
        [self.delegate ReturnDuratime:[self getFormatString:self.player.duration]];
    }
    [self startPlayTimer];

}
-(void)StopPlay{
    [self.player stop];
    self.player.currentTime = 0;
    if ([self.delegate respondsToSelector:@selector(ReturnDuratime:)]) {
        [self.delegate ReturnDuratime:[self getFormatString:self.player.duration]];
    }
    if (_playStatusTimer) {
        [_playStatusTimer invalidate];
        _playStatusTimer = nil;
    }
}
- (void)stopPlayStatusTimer{
    if (_playStatusTimer) {
        [_playStatusTimer invalidate];
        _playStatusTimer = nil;
    }
}
-(NSInteger)retureDuraTime{
    return self.player.duration;
}
- (void)startPlayTimer{
    _residueTime = self.player.duration;
    if (!_playStatusTimer) {
        _playStatusTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(PlayTime) userInfo:nil repeats:YES];
        [_playStatusTimer setFireDate:[NSDate distantPast]];
    }
}
-(void)PlayTime{
    _residueTime--;
    if (_residueTime >= 0) {
        if ([self.delegate respondsToSelector:@selector(ReturnDuratime:)]) {
            [self.delegate ReturnDuratime:[self getFormatString:_residueTime]];
        }
    }
}

- (NSString *)getFormatString:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours <= 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}
#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    //播放结束
    [self StopPlay];
    if (self) {
        if ([self.delegate respondsToSelector:@selector(endPlaySound)]) {
            [self.delegate endPlaySound];
        }
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误
}

- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断
}

- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束
}
@end

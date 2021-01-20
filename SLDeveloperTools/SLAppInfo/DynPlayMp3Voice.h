//
//  DynPlayMp3Voice.h
//  BXlive
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol playDelegate <NSObject>

@optional
//-(void)startPlaySound;
-(void)endPlaySound;
-(void)ReturnDuratime:(NSString *)timeString;
-(void)getTime:(NSString *)timeString;
-(void)getDurationTime:(NSString *)timeString;
@end

@interface DynPlayMp3Voice : NSObject
@property(nonatomic, weak)id <playDelegate>delegate;
@property (nonatomic,strong) AVAudioPlayer *player;
@property(nonatomic, strong)NSString *playPath;
-(void)StartPlayWithplaypath:(NSString *)path;
-(void)startPlay;
-(void)StopPlay;
-(NSInteger)retureDuraTime;
@end

NS_ASSUME_NONNULL_END

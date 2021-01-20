//
//  DetailVideoView.h
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailBaseheaderView.h"
//#import "BXDynamicModel.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "BXNormalControllView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol BXDynNewVideoTableViewCellDelegate <NSObject>
@optional
@end

@interface DetailVideoView : DetailBaseheaderView

@property (nonatomic ,strong) UIView *backView;//图片背景
@property (nonatomic ,strong) UIButton *playBtn;//播放文字


@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) BXNormalControllView *controlView;
@property (nonatomic, strong) ZFAVPlayerManager  *playerManager;

@property (copy, nonatomic) void (^Didamp)();
@property (copy, nonatomic) void (^DidPlaybtn)(UIButton *playbtn);
@end

NS_ASSUME_NONNULL_END

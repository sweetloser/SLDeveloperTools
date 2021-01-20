//
//  BXAVPlayerManager.m
//  BXlive
//
//  Created by bxlive on 2019/2/28.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAVPlayerManager.h"
//#import "BXHomepageCategoryVC.h"
//#import "BXHomeDynamic.h"
#import "../SLCategory/SLCategory.h"
#import "../SLWidget/SLJXCategoryView/JXCategoryView.h"
@interface BXAVPlayerManager ()

@property (assign, nonatomic) BOOL isFailedPause;

@property(nonatomic,assign)BXAVPlayerManagerType managerType;

@end

@implementation BXAVPlayerManager

@synthesize isPreparedToPlay               = _isPreparedToPlay;
@synthesize loadState                      = _loadState;


-(instancetype)initWithTpye:(BXAVPlayerManagerType)type{
    self = [super init];
    if (self) {
        self.managerType = type;
    }
    return self;
}


- (void)play {
    
    switch (self.managerType) {
        case BXAVPlayerManagerVideoPlayRecommended:
            {
//                推荐
                UIViewController *cvc = [[UIApplication sharedApplication] activityViewController];
                if (![cvc isKindOfClass:NSClassFromString(@"BXHomepageCategoryVC")] || [(JXCategoryTitleView *)[cvc valueForKeyPath:@"categoryView"] selectedIndex] != 0) {
                    return;
                }
            }
            break;
        case BXAVPlayerManagerVideoPlayDynamicNew:
            {
    //                动态-最新
                UIViewController *cvc = [[UIApplication sharedApplication] activityViewController];
                if ([cvc isKindOfClass:NSClassFromString(@"BXDynClickPlayVC")]) {
                    break;
                }
                if ([cvc isKindOfClass:NSClassFromString(@"BXHomepageCategoryVC")]){
                    if ([[cvc valueForKeyPath:@"categoryView"] selectedIndex] == 2) {
//                        BXHomepageCategoryVC *hp = (BXHomepageCategoryVC *)cvc;
                        NSArray *childVCs = [cvc valueForKeyPath:@"childVCs"];
                        id selected2 = childVCs[2];
                        if ([(JXCategoryTitleView *)[selected2 valueForKeyPath:@"categoryView"] selectedIndex] != 0) {
                            return;
                        }
                    }else if([(JXCategoryTitleView *)[cvc valueForKeyPath:@"categoryView"] selectedIndex] == 3) {
                        break;
                    }else{
                        return;
                    }
                }
            }
            break;
        case BXAVPlayerManagerVideoPlayDynamicNearBy:
            {
//                动态-附近
                UIViewController *cvc = [[UIApplication sharedApplication] activityViewController];
                if ([cvc isKindOfClass:NSClassFromString(@"BXDynClickPlayVC")]) {
                    break;
                }
                if (![cvc isKindOfClass:NSClassFromString(@"BXHomepageCategoryVC")] || [(JXCategoryTitleView *)[cvc valueForKeyPath:@"categoryView"] selectedIndex] != 2) {
                    return;
                }
//                BXHomepageCategoryVC *hp = (BXHomepageCategoryVC *)cvc;
                NSArray *childViewControllers = [cvc valueForKeyPath:@"childViewControllers"];
                JXCategoryTitleView *categoryView = [cvc valueForKeyPath:@"categoryView"];
                id selected2 = childViewControllers[categoryView.selectedIndex];
//                BXHomeDynamic *selected2 = hp.childViewControllers[hp.categoryView.selectedIndex];
                if (((JXCategoryTitleView *)[selected2 valueForKeyPath:@"categoryView"]).selectedIndex != 1) {
                    return;
                }
            }
            break;
        case BXAVPlayerManagerVideoPlayDynamicCircle:
            {
//                动态-圈子
                UIViewController *cvc = [[UIApplication sharedApplication] activityViewController];
                if ([cvc isKindOfClass:NSClassFromString(@"BXDynClickPlayVC")]) {
                    break;
                }
                if (![cvc isKindOfClass:NSClassFromString(@"BXHomepageCategoryVC")] || [(JXCategoryTitleView *)[cvc valueForKeyPath:@"categoryView"] selectedIndex] != 2) {
                    return;
                }
//                BXHomepageCategoryVC *hp = (BXHomepageCategoryVC *)cvc;
//                BXHomeDynamic *selected2 = hp.childViewControllers[hp.categoryView.selectedIndex];
                NSArray *childViewControllers = [cvc valueForKeyPath:@"childViewControllers"];
                JXCategoryTitleView *categoryView = [cvc valueForKeyPath:@"categoryView"];
                id selected2 = childViewControllers[categoryView.selectedIndex];
                
                if (((JXCategoryTitleView *)[selected2 valueForKeyPath:@"categoryView"]).selectedIndex != 2) {
                    return;
                }
            }
            break;
        case BXAVPlayerManagerVideoPlayFocusOn:
            {
//                关注
                UIViewController *cvc = [[UIApplication sharedApplication] activityViewController];
                if (![cvc isKindOfClass:NSClassFromString(@"BXHomepageCategoryVC")] || [(JXCategoryTitleView *)[cvc valueForKeyPath:@"categoryView"] selectedIndex] != 1) {
                    return;
                }
            }
            break;
        case BXAVPlayerManagerVideoPlayOthers:
            {

            }
            break;
        default:
            break;
    }
    
    NSLog(@"a");
    if (_isFailedPause) {
        _isFailedPause = NO;
        self.seekTime = self.currentTime;
        if (!self.assetURL) return;
        _isPreparedToPlay = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [super performSelector:@selector(initializePlayer)];
#pragma clang diagnostic pop
        [super play];
        
        self.loadState = ZFPlayerLoadStatePrepare;
        if (self.playerPrepareToPlay) {
            self.playerPrepareToPlay(self, self.assetURL);
        }
    } else {
        [super play];
    }
}

- (void)pause {
    _isFailedPause = NO;
    if (self.playState == ZFPlayerPlayStatePlayFailed) {
        _isFailedPause = YES;
    }
    [super pause];
}

- (void)replay {
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        NSLog(@"===============:%d",finished);
        if (finished) {
            [self play];
        }
    }];
}

#pragma mark - setter
- (void)setLoadState:(ZFPlayerLoadState)loadState {
    _loadState = loadState;
    if (self.playerLoadStateChanged) self.playerLoadStateChanged(self, loadState);
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    if (self.totalTime > 0) {
        CMTime seekTime = kCMTimeZero;
        CMTime duration = self.player.currentItem.duration;
        if (CMTIME_IS_VALID(duration) && duration.timescale) {
            seekTime = CMTimeMakeWithSeconds(time, duration.timescale);
        } else {
            seekTime = CMTimeMake(time, 1);
        }
        [self.player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
    } else {
        self.seekTime = time;
    }
}

@end

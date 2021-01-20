//
//  BXDynVideoControllerView.h
//  BXlive
//
//  Created by mac on 2020/8/15.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXProgressView.h"
#import <ZFPlayer/ZFPlayer.h>
NS_ASSUME_NONNULL_BEGIN

@interface BXDynVideoControllerView : UIView<ZFPlayerMediaControl>


@property (strong, nonatomic) BXProgressView *progressView;

- (void)resetControlView;

- (void)showCoverURLString:(NSString *)coverUrl scalingMode:(NSInteger)scalingMode;

@end

NS_ASSUME_NONNULL_END

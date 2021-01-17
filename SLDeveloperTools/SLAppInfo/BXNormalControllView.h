//
//  BXNormalControllView.h
//  BXlive
//
//  Created by bxlive on 2019/5/16.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXProgressView.h"
#import <ZFPlayer/ZFPlayer.h>

@interface BXNormalControllView : UIView <ZFPlayerMediaControl>


@property (strong, nonatomic) BXProgressView *progressView;

- (void)resetControlView;

- (void)showCoverURLString:(NSString *)coverUrl scalingMode:(NSInteger)scalingMode;


@end

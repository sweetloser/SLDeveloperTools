//
//  BXReplayKitProcessView.h
//  BXlive
//
//  Created by bxlive on 2019/1/7.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BX_MIN_RECORD_TIME  5
#define BX_MAX_RECORD_TIME  30

@interface BXRecordingScreenProcessView : UIView

- (void)update:(CGFloat)progress;

- (void)updateProgressWithTime:(NSInteger)time;

@end




//
//  BXPlayerControlView.h
//  BXlive
//
//  Created by bxlive on 2019/2/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "BXHMovieModel.h"

@interface BXPlayerControlView : UIView <ZFPlayerMediaControl>

@property (nonatomic, strong) BXHMovieModel *video;
@property (nonatomic, copy) void (^likeAction)();
@property (nonatomic, copy) void (^didLongPressAction)(CGPoint point);

//type：0 有底部 1：无底部 进度条无凸起
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;
- (void)showCoverURL:(NSString *)coverUrl scalingMode:(NSInteger)scalingMode;
- (void)resetControlView;

@end



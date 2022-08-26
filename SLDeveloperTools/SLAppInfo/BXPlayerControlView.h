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

@property(nonatomic,strong)BXHMovieModel *video;
@property(nonatomic,copy)void(^likeAction)();
@property(nonatomic,copy)void(^didLongPressAction)(CGPoint point);
@property(nonatomic,copy)void(^showRedEnvelopeViewBlock)(BXHMovieModel *videoModel);

//type：0 有底部且中间凸起   1：无底部 进度条无凸起，距离底部有安全距离       2：无底部，紧贴底部（无安全距离）      3：有底部但无中间凸起
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;
- (void)showCoverURL:(NSString *)coverUrl scalingMode:(NSInteger)scalingMode;
- (void)resetControlView;

@end



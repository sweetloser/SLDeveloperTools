//
//  BXClickVideoViewVC.h
//  BXlive
//
//  Created by bxlive on 2019/5/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXHMovieModel.h"
#import <ZFPlayer/ZFPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXClickVideoViewVC : BaseVC<UINavigationControllerDelegate>


-(instancetype)initWithVideoModel:(BXHMovieModel *)model;

@property (nonatomic, strong) UIView * containerView;

@property (nonatomic, strong) ZFPlayerController *player;

@property(nonatomic,copy)void(^detailPlayCallback)(BXHMovieModel * playVideoModel);
@property(nonatomic,copy)void(^moveState)(UIGestureRecognizerState state);

@end

NS_ASSUME_NONNULL_END

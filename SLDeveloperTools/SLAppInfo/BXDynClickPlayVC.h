//
//  BXDynClickPlayVC.h
//  BXlive
//
//  Created by mac on 2020/8/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXDynamicModel.h"
#import <ZFPlayer/ZFPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXDynClickPlayVC : BaseVC<UINavigationControllerDelegate>


-(instancetype)initWithVideoModel:(BXDynamicModel *)model;

@property (nonatomic, strong) UIView * containerView;

@property (nonatomic, strong) ZFPlayerController *player;

@property(nonatomic,copy)void(^detailPlayCallback)(BXDynamicModel * playVideoModel);
@property(nonatomic,copy)void(^moveState)(UIGestureRecognizerState state);
@end

NS_ASSUME_NONNULL_END

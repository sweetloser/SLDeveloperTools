//
//  BXDaemonListHeadView.h
//  BXlive
//
//  Created by 刘超 on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGift;
NS_ASSUME_NONNULL_BEGIN

@interface BXDaemonListHeadView : UIView

@property(nonatomic,copy)void(^buyCallBackBlock)(BXGift *gift);


@end

NS_ASSUME_NONNULL_END

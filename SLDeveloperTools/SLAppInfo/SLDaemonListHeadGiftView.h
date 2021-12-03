//
//  SLDaemonListHeadGiftView.h
//  BXlive
//
//  Created by sweetloser on 2020/8/11.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGift.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLDaemonListHeadGiftView : UIView


-(void)updateUIForModel:(BXGift *)model;

@property(nonatomic,copy)void(^buyBtnOnClickBlock)();

@end

NS_ASSUME_NONNULL_END

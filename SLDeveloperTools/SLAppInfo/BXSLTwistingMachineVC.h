//
//  BXSLTwistingMachineVC.h
//  BXlive
//
//  Created by bxlive on 2019/1/2.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseWebVC.h"
#import <STPopup/STPopup.h>
#import "BXSLPopupController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXSLTwistingMachineVC : BaseWebVC

@property (assign, nonatomic) CGFloat heightRate;

@property(nonatomic, copy)void (^wishGiftBlock)(NSDictionary *param);

@end

NS_ASSUME_NONNULL_END

//
//  SLAlertView.h
//  BXlive
//
//  Created by sweetloser on 2020/8/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLAlertView : UIView

@property(nonatomic,copy)NSString *descString;

@property(nonatomic,copy)NSString *cancelTitle;

@property(nonatomic,copy)NSString *determineTitle;

@property(nonatomic,copy)void(^cancelBlock)(void);

@property(nonatomic,copy)void(^determineBlock)(void);



-(void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END

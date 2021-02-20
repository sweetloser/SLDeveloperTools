//
//  SLBaseAlertView.h
//  BXlive
//
//  Created by sweetloser on 2020/8/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLBaseAlertView : UIView

@property (strong, nonatomic) UIView *contentView;//内容视图，需要子类去实例化

-(void)hiddenView;

-(void)show;

@end

NS_ASSUME_NONNULL_END

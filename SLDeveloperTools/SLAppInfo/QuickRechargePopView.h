//
//  QuickRechargePopView.h
//  BXlive
//
//  Created by bxlive on 2018/9/14.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickRechargePopView : UIView

@property (copy, nonatomic) void (^closeView)(NSString *baleance);
- (instancetype)initWithShareObject;

- (void)show:(UIView *)view;

@end

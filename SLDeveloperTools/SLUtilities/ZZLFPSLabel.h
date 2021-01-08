//
//  ZZLFPSLabel.h
//  BXlive
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLFPSLabel : UILabel

@property (nonatomic, assign, getter=isAutoHide) BOOL autoHide;

+ (instancetype)showInWindow:(UIWindow *)window;

@end

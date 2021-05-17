//
//  HHLoginManager.h
//  BXlive
//
//  Created by bxlive on 2018/4/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHLoginManager : NSObject

+ (HHLoginManager *)shareLoginManager;
+ (BOOL)isCanPushToLogin;

@property (assign, nonatomic) NSInteger count;
@property (nonatomic, weak) UIViewController *originController;
@end

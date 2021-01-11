//
//  SLProgressHUD.h
//  BXlive
//
//  Created by sweetloser on 2020/5/11.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLProgressHUD : NSObject

+ (SLProgressHUD *)slShowInfoWithMessage:(NSString *)msg;

+ (SLProgressHUD *)slShowLoadingWithoutBZViewInView:(UIView *)view;

+(void)hidden;
@end

NS_ASSUME_NONNULL_END

//
//  UIImage+GaussianBlur.h
//  高斯模糊
//
//  Created by Lee on 15/1/4.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GaussianBlur)
+ (UIImage *)imageWithBlurImage:(UIImage *)theImage intputRadius:(CGFloat)radius;
@end

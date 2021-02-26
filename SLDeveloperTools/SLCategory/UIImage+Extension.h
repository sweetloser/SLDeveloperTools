//
//  UIImage+Extension.h
//  XTMall
//
//  Created by LayChan on 2020/5/16.
//  Copyright © 2020 LayChan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithQRCode:(NSString *)qrCode maxSize:(CGSize)maxSize;

/** 添加图片水印 */
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage waterMarkImage:(UIImage *)waterMarkImage;

+ (UIImage *)screenSnapWithView:(UIView *)view;

+ (UIImage *)toGrayImage:(UIImage *)oldImage;

- (UIImage *)setColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END

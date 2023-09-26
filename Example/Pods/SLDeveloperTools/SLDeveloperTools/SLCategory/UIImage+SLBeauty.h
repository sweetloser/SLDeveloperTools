//
//  UIImageView+SLBeauuty.h
//  BXlive
//
//  Created by sweetloser on 2020/11/10.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SLBeauty)

+(CVPixelBufferRef)sl_UIImage2Pixe:(CGImageRef)image;

+ (UIImage*)uiImageFromPixelBuffer:(CVPixelBufferRef)p;

+(GLuint)setupTexture:(UIImage *)image;
+ (UIImage *)imageFromTexture:(GLuint)rextute Withwidth:(int)width height:(int)height;
@end

NS_ASSUME_NONNULL_END

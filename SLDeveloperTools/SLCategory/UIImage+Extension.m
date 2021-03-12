//
//  UIImage+Extension.m
//  XTMall
//
//  Created by LayChan on 2020/5/16.
//  Copyright © 2020 LayChan. All rights reserved.
//

#import "UIImage+Extension.h"


@implementation UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithQRCode:(NSString *)qrCode maxSize:(CGSize)maxSize {
    if (!qrCode || qrCode.length == 0) return nil;
    // str -> NSData
    NSData *strData = [qrCode dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    //创建二维码滤镜
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // KVO 设值
    [qrFilter setValue:strData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    return [self createNonInterpolatedUIImageFormCIImage:qrFilter.outputImage maxSize:maxSize];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image maxSize:(CGSize)maxSize {
    // 取image的尺寸
    CGRect extent = CGRectIntegral(image.extent);
    if (CGRectGetWidth(extent) == 0 || CGRectGetHeight(extent) == 0)return nil;
    // 获取比例
    CGFloat scale = MIN(maxSize.width/CGRectGetWidth(extent), maxSize.height/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage waterMarkImage:(UIImage *)waterMarkImage {
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0);
    [originalImage drawInRect:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];

    CGFloat scale = 1.0;
    CGFloat margin = 0;
    CGFloat waterW = MIN(originalImage.size.width, originalImage.size.height) * scale;
    CGFloat waterH = MIN(originalImage.size.width, originalImage.size.height) * scale;
    CGFloat waterX = (originalImage.size.width - waterW - margin)*0.5;
    CGFloat waterY = (originalImage.size.height - waterH - margin)*0.5;
    
    [waterMarkImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)screenSnapWithView:(UIView *)view {
    if (!view) return nil;
     // 第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，设置为[UIScreen mainScreen].scale可以保证转成的图片不失真。
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
}

+ (UIImage *)toGrayImage:(UIImage *)oldImage {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:oldImage.CGImage];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:superImage forKey:kCIInputImageKey];
    // 修改亮度   -1---1   数越大越亮
    [lighten setValue:@(0) forKey:@"inputBrightness"];
    // 修改饱和度  0---2
    [lighten setValue:@(0) forKey:@"inputSaturation"];
    // 修改对比度  0---4
    [lighten setValue:@(0.5) forKey:@"inputContrast"];
    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
    // 得到修改后的图片
    UIImage *newImage =  [UIImage imageWithCGImage:cgImage];
    // 释放对象
    CGImageRelease(cgImage);
    return newImage;
}

- (UIImage *)setColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

//
//  UIImage+GaussianBlur.m
//  高斯模糊
//
//  Created by Lee on 15/1/4.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "UIImage+GaussianBlur.h"

@implementation UIImage (GaussianBlur)

+ (UIImage *)imageWithBlurImage:(UIImage *)theImage intputRadius:(CGFloat)radius
{
//    Core Image是一个很强大的框架。它可以让你简单地应用各种滤镜来处理图像，比如修改鲜艳程度, 色泽, 或者曝光。 它利用GPU（或者CPU，取决于客户）来非常快速、甚至实时地处理图像数据和视频的帧。多个Core Image滤镜可以叠加在一起，从而可以一次性地产生多重滤镜效果。这种多重滤镜的优点在于它可以生成一个改进的滤镜，从而一次性的处理图像达到目标效果，而不是对同一个图像顺序地多次应用单个滤镜。每一个滤镜都有属于它自己的参数。这些参数和滤镜信息，比如功能、输入参数等都可以通过程序来查询。用户也可以来查询系统从而得到当前可用的滤镜信息。到目前为止，Mac上只有一部分Core Image滤镜可以在iOS上使用。但是随着这些可使用滤镜的数目越来越多，API可以用来发现新的滤镜属性。
//    CIContext. 所有图像处理都是在一个CIContext 中完成的，这很像是一个Core Image处理器或是OpenGL的上下文。
//    CIImage. 这个类保存图像数据。它可以从UIImage、图像文件、或者是像素数据中构造出来。
//    CIFilter. 滤镜类包含一个字典结构，对各种滤镜定义了属于他们各自的属性。滤镜有很多种，比如鲜艳程度滤镜，色彩反转滤镜，剪裁滤镜等等。

    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    CIFilter *blurFilter1 = [CIFilter filterWithName:@"CIGaussianBlur"];
    // filter是按照名字来创建的CIGaussianBlur不能更改
    [blurFilter1 setValue:inputImage forKey:kCIInputImageKey];
    [blurFilter1 setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    // 修改radius可以更改模糊程度
    CIImage *result = [blurFilter1 valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    // 即使使用ARC也要加上这个release，因为ARC不管理CGImageRef，不释放会内存泄露
    return returnImage;
}

@end

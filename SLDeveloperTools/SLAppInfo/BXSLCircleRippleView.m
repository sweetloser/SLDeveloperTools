//
//  BXSLCircleRippleView.m
//  BXlive
//
//  Created by bxlive on 2018/10/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXSLCircleRippleView.h"
#import "../SLMacro/SLMacro.h"
@interface BXSLCircleRippleView ()

@property (nonatomic, strong) CAShapeLayer *circleShapeLayer;

@end

@implementation BXSLCircleRippleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpLayers];
    }
    return self;
}

- (void)setUpLayers
{
    CGFloat width = self.bounds.size.width;
    
    self.circleShapeLayer = [CAShapeLayer layer];
    _circleShapeLayer.bounds = CGRectMake(0, 0, width, width);
    _circleShapeLayer.position = CGPointMake(width / 2.0, width / 2.0);
    _circleShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)].CGPath;
    _circleShapeLayer.lineWidth = 1.5;
    _circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _circleShapeLayer.strokeColor = sl_normalColors.CGColor;
    _circleShapeLayer.opacity = 0.0;
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.bounds = CGRectMake(0, 0, width, width);
    replicator.position = CGPointMake(width / 2.0, width / 2.0);
    replicator.instanceDelay = 0.5;
    replicator.instanceCount = 2;
    
    [replicator addSublayer:_circleShapeLayer];
    [self.layer addSublayer:replicator];
}

- (void)startAnimation {
    _isAnimation = YES;
    
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnim.toValue = [NSNumber numberWithFloat:0.0];
    
    CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DScale(t, 0.63, 0.63, 0.0);
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
    CATransform3D t3 = CATransform3DScale(t, 1.0, 1.0, 0.0);
    scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[alphaAnim, scaleAnim];
    groupAnimation.duration = 1.0;
    groupAnimation.autoreverses = NO;
    groupAnimation.repeatCount = HUGE;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.removedOnCompletion = NO;
    
    [_circleShapeLayer addAnimation:groupAnimation forKey:@"Group"];
}

- (void)stopAnimation {
    _isAnimation = NO;
    [_circleShapeLayer removeAllAnimations];
}

//
//-(UIImage *)imageAtImageURL:(NSURL *)URL pointSize:(CGSize)pointSize  scale:(CGFloat)scale{
//    NSURL *imageURL = URL;
//    CFDictionary options = kCGImageSourceShouldCache: @YES;
//    
//    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
//    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0,(__bridge CFDictionaryRef)options);
//    UIImage *image = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    CFRelease(source);
//    return image;
//    
//    
//}
//
//func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
//    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
//    let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
//    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
//    let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
//                                     kCGImageSourceShouldCacheImmediately: true,
//                               kCGImageSourceCreateThumbnailWithTransform: true,
//                                      kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
//    let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
//    return UIImage(cgImage: downsampledImage)
//}





@end

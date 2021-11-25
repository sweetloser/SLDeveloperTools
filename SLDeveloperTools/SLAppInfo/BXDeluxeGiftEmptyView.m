//
//  BXDeluxeGiftEmptyView.m
//  BXlive
//
//  Created by bxlive on 2019/7/23.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXDeluxeGiftEmptyView.h"
#import "SLDeveloperTools.h"
#import <YYWebImage/YYWebImage.h>


@interface BXDeluxeGiftEmptyView()

@property (strong, nonatomic) UIImageView *giftImage;

@property (strong, nonatomic) UIImageView *giftBgImage;

@property (strong, nonatomic) UIImageView *giftBgImageShine;

@end

@implementation BXDeluxeGiftEmptyView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self removeWithDuration:4.0];
    }
    return self;
}

-(void)addGiftUrlImage:(NSString *)urlImage {
    self.giftBgImageShine = [UIImageView new];
    self.giftBgImageShine.frame = CGRectMake((__kWidth - 215) / 2.0, (__kHeight - 211) / 2.0, 215, 211);
    self.giftBgImageShine.image = CImage(@"icon_gift_empty_bgShine");
    [self addSubview:self.giftBgImageShine];
    self.giftBgImageShine.hidden = YES;
    
    
    self.giftBgImage = [UIImageView new];
    self.giftBgImage.frame = CGRectMake(__kWidth / 2 - 50, __kHeight / 2 - 50, 100, 100);
    self.giftBgImage.image = CImage(@"icon_gift_empty_bg");
    [self addSubview:self.giftBgImage];
    
    
    _giftImage = [UIImageView new];
    _giftImage.frame = CGRectMake(10, 10, 80, 80);
    [_giftImage yy_setImageWithURL:[NSURL URLWithString:urlImage] placeholder:nil];
    _giftImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.giftBgImage addSubview:_giftImage];
    
    //左右翻转
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0,1,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                           nil];
    keyAnimation.cumulative = NO;
    keyAnimation.duration = 0.6 ;
    keyAnimation.repeatCount = 1;
    keyAnimation.removedOnCompletion = NO;
    [self.giftBgImage.layer addAnimation:keyAnimation forKey:@"transform"];
    [self performSelector:@selector(updownImange) withObject:nil afterDelay:0.9];

}
//上下翻转
-(void)updownImange{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    // 旋转角度， 其中的value表示图像旋转的最终位置
    keyAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 1,0,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1,0,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 1,0,0)],
                           nil];
    keyAnimation.cumulative = NO;
    keyAnimation.duration = 0.5 ;
    keyAnimation.repeatCount = 1;
    keyAnimation.removedOnCompletion = NO;
    [self.giftBgImage.layer addAnimation:keyAnimation forKey:@"transform"];
    [self performSelector:@selector(rotationImg) withObject:nil afterDelay:0.6];
}
//旋转图片
-(void)rotationImg{
    self.giftBgImageShine.hidden = NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1.6;
    rotationAnimation.cumulative = NO;
    rotationAnimation.repeatCount = 1;
    rotationAnimation.removedOnCompletion = NO;
    [self.giftBgImageShine.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self performSelector:@selector(scaleImg) withObject:nil afterDelay:1.7];
}
//缩放
-(void)scaleImg{
    CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//同上
    anima1.toValue = [NSNumber numberWithFloat:0.0f];
    anima1.duration = .2f;
    anima1.fillMode = kCAFillModeForwards;
    anima1.removedOnCompletion = NO;
    [self.giftBgImageShine.layer addAnimation:anima1 forKey:@"scaleAnimation"];
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//同上
    anima.toValue = [NSNumber numberWithFloat:0.0f];
    anima.duration = .4f;
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    [self.giftBgImage.layer addAnimation:anima forKey:@"scaleAnimation"];
}

@end

//
//  TiUIButton.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/4.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiIndicatorAnimationView : UIView

-(void)startAnimation;
-(void)endAnimation;

@end

@interface TIButton : UIButton
//scaling 为图片缩放比
-(instancetype _Nullable )initWithScaling:(CGFloat)scaling;

- (void)setTitle:(nullable NSString *)title withImage:(nullable UIImage *)image withTextColor:(nullable UIColor *)color forState:(UIControlState)state;

-(void)setBorderWidth:(CGFloat)W BorderColor:(nullable UIColor *)color forState:(UIControlState)state;

-(void)setDownloaded:(BOOL)downloaded;

-(void)startAnimation;
-(void)endAnimation;

@end
 

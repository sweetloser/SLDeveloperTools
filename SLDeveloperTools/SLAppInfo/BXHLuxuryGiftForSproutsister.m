//
//  BXHLuxuryGiftForSproutsister.m
//  BXlive
//
//  Created by bxlive on 2017/6/13.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BXHLuxuryGiftForSproutsister.h"
#import "SLDeveloperTools.h"

#define leftWH 120
#define rightWH 180
@interface BXHLuxuryGiftForSproutsister ()
{
    UIImageView *sproutsisterLeft;
    UIImageView *sproutsisterRight;
}
@end
@implementation BXHLuxuryGiftForSproutsister

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        sproutsisterRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sproutsister_2.png"]];
        sproutsisterRight.userInteractionEnabled = YES;
        sproutsisterRight.contentMode = UIViewContentModeScaleAspectFit;
        sproutsisterRight.frame = CGRectMake(SCREEN_WIDTH,(SCREEN_HEIGHT-rightWH)/2,rightWH,rightWH);
        sproutsisterRight.userInteractionEnabled = YES;
        [self addSubview:sproutsisterRight];
        
        sproutsisterLeft = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sproutsister_1.png"]];
        sproutsisterLeft.userInteractionEnabled = YES;
        sproutsisterLeft.contentMode = UIViewContentModeScaleAspectFit;
        sproutsisterLeft.frame = CGRectMake(-1,(SCREEN_HEIGHT-leftWH)/3,1,1);
        sproutsisterLeft.userInteractionEnabled = YES;
        [self addSubview:sproutsisterLeft];
        
        [self firstView];
        
        [self removeWithDuration:5];
    }
    
    return self;
}

- (void)firstView{
    [UIView animateWithDuration:0.5 animations:^{
        self->sproutsisterRight.frame = CGRectMake(SCREEN_WIDTH-rightWH+23,(SCREEN_HEIGHT-rightWH)/2,rightWH,rightWH);
    }];
    //创建一个CGAffineTransform  transform对象
    
    CGAffineTransform  transform;
    
    //设置旋转度数
    
    transform = CGAffineTransformRotate(sproutsisterRight.transform,-M_PI/3.1);
    
    //动画开始
    
    [UIView beginAnimations:@"sproutsisterRight" context:nil ];
    
    //动画时常
    
    [UIView setAnimationDuration:0.5];
    
    //添加代理
    
    [UIView setAnimationDelegate:self];
    
    //获取transform的值
    
    [sproutsisterRight setTransform:transform];
    
    //关闭动画
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(nextView) withObject:nil afterDelay:0.5f];
}

- (void)nextView{
    
    [UIView animateWithDuration:0.5 animations:^{
        self->sproutsisterLeft.frame = CGRectMake(-13,(SCREEN_HEIGHT-leftWH)/3,leftWH,leftWH);
    }];
    //创建一个CGAffineTransform  transform对象
    
    CGAffineTransform  transform;
    
    //设置旋转度数
    
    transform = CGAffineTransformRotate(sproutsisterLeft.transform,M_PI/5.0);
    
    
    //动画开始
    
    [UIView beginAnimations:@"sproutsisterLeft" context:nil ];
    
    //动画时常
    
    [UIView setAnimationDuration:0.5];
    
    //添加代理
    
    [UIView setAnimationDelegate:self];
    
    //获取transform的值
    
    [sproutsisterLeft setTransform:transform];
    
    //关闭动画
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(endView) withObject:nil afterDelay:0.5f];
}

- (void)endView{
//    [UIView animateWithDuration:1 animations:^{
//        sproutsisterLeft.frame = CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2,0,0);
//    }];
//    [UIView animateWithDuration:1 animations:^{
//        sproutsisterRight.frame = CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2,0,0);
//    }];
    
//    if (cishu==1) {
//        [self performSelector:@selector(firstView) withObject:nil afterDelay:1.0f];
//    }else{
//        sproutsisterLeft.hidden = YES;
//        sproutsisterRight.hidden = YES;
//    }
    
//    for (int i = 0; i<7; i++) {
//        if (i%2==0) {
//            [UIView animateWithDuration:0.5 animations:^{
//                sproutsisterLeft.frame = CGRectMake(-13,(SCREEN_HEIGHT-leftWH)/3+20,leftWH,leftWH);
//            }];
//            [UIView animateWithDuration:0.5 animations:^{
//                sproutsisterRight.frame = CGRectMake(SCREEN_WIDTH-rightWH+23,(SCREEN_HEIGHT-rightWH)/2+20,rightWH,rightWH);
//            }];
//        }else{
//            [UIView animateWithDuration:0.5 animations:^{
//                sproutsisterLeft.frame = CGRectMake(-13,(SCREEN_HEIGHT-leftWH)/3,leftWH,leftWH);
//            }];
//            [UIView animateWithDuration:0.5 animations:^{
//                sproutsisterRight.frame = CGRectMake(SCREEN_WIDTH-rightWH+23,(SCREEN_HEIGHT-rightWH)/2,rightWH,rightWH);
//            }];
//        }
//    }
    
    
    CAKeyframeAnimation *animationLeft = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animationLeft.duration = 3.0;
    
    NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2,leftWH,leftWH)];
    NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2-10,leftWH,leftWH)];
    NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2,leftWH,leftWH)];
    NSValue *value4 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2-10,leftWH,leftWH)];
    NSValue *value5 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2,leftWH,leftWH)];
    NSValue *value6 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2-10,leftWH,leftWH)];
    NSValue *value7 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2,leftWH,leftWH)];
    NSValue *value8 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2-10,leftWH,leftWH)];
    NSValue *value9 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2,leftWH,leftWH)];
    NSValue *value10 = [NSValue valueWithCGRect:CGRectMake(-13+leftWH/2,(SCREEN_HEIGHT-leftWH)/3+leftWH/2-10,leftWH,leftWH)];
    
    animationLeft.values = @[value1,value2,value3,value4,value5,value6,value7,value8,value9,value10];
    
    animationLeft.removedOnCompletion = NO;
    
    animationLeft.fillMode = kCAFillModeForwards;
    
    [sproutsisterLeft.layer addAnimation:animationLeft forKey:nil];
    
    CAKeyframeAnimation *animationRight = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animationRight.duration = 3.0;
    
    NSValue *value11 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2,rightWH,rightWH)];
    NSValue *value12 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2-10,rightWH,rightWH)];
    NSValue *value13 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2,rightWH,rightWH)];
    NSValue *value14 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2-10,rightWH,rightWH)];
    NSValue *value15 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2,rightWH,rightWH)];
    NSValue *value16 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2-10,rightWH,rightWH)];
    NSValue *value17 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2,rightWH,rightWH)];
    NSValue *value18 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2-10,rightWH,rightWH)];
    NSValue *value19 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2,rightWH,rightWH)];
    NSValue *value20 = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-rightWH+23+rightWH/2,(SCREEN_HEIGHT-rightWH)/2+rightWH/2-10,rightWH,rightWH)];
    
    animationRight.values = @[value11,value12,value13,value14,value15,value16,value17,value18,value19,value20];
    
    animationRight.removedOnCompletion = NO;
    
    animationRight.fillMode = kCAFillModeForwards;
    
    [sproutsisterRight.layer addAnimation:animationRight forKey:nil];
    
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:3.0f];
}

- (void)hiddenView{
    sproutsisterLeft.hidden = YES;
    sproutsisterRight.hidden = YES;
}

@end

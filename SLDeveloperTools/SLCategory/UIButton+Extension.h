//
//  UIButton+Extension.h
//  BXlive
//
//  Created by sweetloser on 2020/5/24.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extension)

-(void)sl_setTitleColor:(nullable UIColor *)color;
-(void)sl_setTitleNormalColor:(nullable UIColor *)normalColor selectedColor:(UIColor *)selectedColor heightLightColor:(UIColor *)heightLightColor;
@end

NS_ASSUME_NONNULL_END

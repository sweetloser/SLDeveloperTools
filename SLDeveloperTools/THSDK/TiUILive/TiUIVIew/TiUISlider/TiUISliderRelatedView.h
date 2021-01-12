//
//  TiUISliderRelatedView.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiUISliderNew.h"
 
@interface TiUISliderRelatedView : UIView

// 自定义Slider
@property(nonatomic,strong) TiUISliderNew *sliderView;


//显示Slider数值
@property(nonatomic,strong) UILabel *sliderLabel;
//美颜对比按钮
@property(nonatomic,strong) UIButton *tiContrastBtn;

-(void)setSliderHidden:(BOOL)hidden;

@end
 

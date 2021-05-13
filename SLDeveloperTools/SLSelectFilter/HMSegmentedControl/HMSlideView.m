//
//  HMSlideView.m
//  BXlive
//
//  Created by bxlive on 2019/4/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "HMSlideView.h"
#import "../../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>
#import <MMKV/MMKV.h>
#import "../../SLMaskTools/SLMaskTools.h"
#import "../SLSelectFilterConst.h"

@interface HMSlideView ()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIView *defaultView;

@property (nonatomic, assign) CGFloat width;

@property(nonatomic,assign) CGFloat pro;

@end

@implementation HMSlideView
 {

    CAGradientLayer *gradient;

}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultView = [[UIView alloc]init];
        _defaultView.backgroundColor = [UIColor sl_colorWithHex:0xA8AFAF];
        _defaultView.layer.cornerRadius = 3;
        _defaultView.layer.masksToBounds = YES;
        [self addSubview:_defaultView];
        [_defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(6);
            make.centerY.mas_equalTo(1.0);
            make.left.mas_equalTo(0);
        }];
        
        _slider = [[UISlider alloc]init];
        [_slider setThumbImage:[UIImage imageNamed:@"lc_meiyan_slider_circle"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"lc_meiyan_slider_circle"] forState:UIControlStateHighlighted];
//        [_slider setThumbImage:[UIImage imageWithColor:sl_FF2DtextColors] forState:UIControlStateNormal];
//        [_slider setThumbImage:[UIImage imageWithColor:sl_FF2DtextColors] forState:UIControlStateHighlighted];
        
//        _slider.minimumTrackTintColor = normalColors;
//        _slider.maximumTrackTintColor = CHHCOLOR_D(0xA8AFAF);
        _slider.minimumTrackTintColor = [UIColor clearColor];
        _slider.maximumTrackTintColor = [UIColor sl_colorWithHex:0xA8AFAF];
        [_slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slider];
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        gradient = [CAGradientLayer layer];
        
        _pro = 0;

        gradient.frame =CGRectMake(0,_slider.bounds.size.height/2 - 2,_pro ,4);
        gradient.cornerRadius = 2.0;
        gradient.masksToBounds = YES;

        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"#FFD576"] CGColor], (id)[[UIColor colorWithHexString:@"#FF2D52"] CGColor], nil];

        gradient.startPoint=CGPointMake(0,0.5);

        gradient.endPoint=CGPointMake(1,0.5);

        [_slider.layer addSublayer:gradient];
        
        
        
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isIn = [super pointInside:point withEvent:event];
    if (isIn) {
       MMKV *mmkv = [MMKV defaultMMKV];
        if ([mmkv getBoolForKey:kSaveSkipKey]) {
            [BGProgressHUD showInfoWithMessage:@"请先打开美颜开关"];
            isIn = NO;
        }
    }
    return isIn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _width = self.width - 6;
    self.defaultValue = _defaultValue;
    _pro   = self.bounds.size.width * _slider.value;
    gradient.frame =CGRectMake(0,_slider.bounds.size.height/2 - 2,_pro ,4);
}

- (void)setValue:(CGFloat)value {
    _value = value;
    _slider.value = value;
    
    _pro   = self.bounds.size.width * _slider.value;
    gradient.frame =CGRectMake(0,_slider.bounds.size.height/2 - 2,_pro ,4);
    
}

- (void)setDefaultValue:(CGFloat)defaultValue {
    _defaultValue = defaultValue;
    
    _defaultView.transform = CGAffineTransformMakeTranslation(_width * defaultValue, 0);
    _pro   = self.bounds.size.width * _slider.value;
    gradient.frame =CGRectMake(0,_slider.bounds.size.height/2 - 2,_pro ,4);
}

- (void)valueChanged {
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideViewValueChangedWithType:value:)]) {
        [self.delegate slideViewValueChangedWithType:_type value:_slider.value];
    }
    _pro   = self.bounds.size.width * _slider.value;
    gradient.frame =CGRectMake(0,_slider.bounds.size.height/2 - 2,_pro ,4);
}





@end

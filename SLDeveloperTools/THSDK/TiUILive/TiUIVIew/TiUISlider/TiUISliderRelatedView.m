//
//  TiUISliderRelatedView.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUISliderRelatedView.h"
#import "TIConfig.h"

#import <TiSDK/TiSDKInterface.h>

@interface TiUISliderRelatedView ()

 
@end
 

@implementation TiUISliderRelatedView

- (TiUISliderNew *)sliderView {
    if (!_sliderView) {
        _sliderView = [[TiUISliderNew alloc] init]; 
        WeakSelf
        [_sliderView setValueBlock:^(CGFloat value) {
            //数值
         weakSelf.sliderLabel.text = [NSString stringWithFormat:@"%.f%%",value];
        }];
    }
    return _sliderView;
}

-(UILabel *)sliderLabel{
    if (_sliderLabel==nil) {
        _sliderLabel = [[UILabel alloc]init];
        [_sliderLabel setTextAlignment:NSTextAlignmentCenter];
        [_sliderLabel setFont:TI_Font_Default_Size_Small];
        [_sliderLabel setTextColor:TI_Color_Default_Text_White];
        _sliderLabel.userInteractionEnabled = NO;
        _sliderLabel.text = @"100%";
    }
    return _sliderLabel;
}

-(UIButton *)tiContrastBtn{
    if (_tiContrastBtn==nil) {
        _tiContrastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tiContrastBtn setImage:[UIImage imageNamed:@"compare"] forState:UIControlStateNormal];
        [_tiContrastBtn setImage:[UIImage imageNamed:@"compare"] forState:UIControlStateSelected];
        [_tiContrastBtn setSelected:NO];
        _tiContrastBtn.layer.masksToBounds = NO;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.0; //定义按的时间
        [_tiContrastBtn addGestureRecognizer:longPress];
    }
    return _tiContrastBtn;
}

-(void)longPress:(UILongPressGestureRecognizer*)gestureRecognizer{
     
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [[TiSDKManager shareManager] setRenderEnable:false];
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        [[TiSDKManager shareManager] setRenderEnable:true];
    }
    else{
        return;
    }
}

-(void)setSliderHidden:(BOOL)hidden{
    [self.sliderView setHidden:hidden];
    [self.sliderLabel setHidden:hidden];
}

- (instancetype)init
{
    self = [super init];
    if (self) { 
        
        [self addSubview:self.sliderView];
        [self addSubview:self.sliderLabel];
        [self addSubview:self.tiContrastBtn];
        
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(TiUISliderLeftRightWidth).priorityHigh();
            make.right.equalTo(self.mas_right).offset(-TiUISliderLeftRightWidth).priorityHigh();
            make.height.offset(TiUISliderHeight-1);
        }];
         
        [self.sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.right.equalTo(self.sliderView.mas_left);
        }];
        [self.tiContrastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.right.bottom.equalTo(self);
                   make.left.equalTo(self.sliderView.mas_right);
               }];
    }
    return self;
}
 

@end

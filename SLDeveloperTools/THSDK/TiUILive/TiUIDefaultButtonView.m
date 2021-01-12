//
//  TiUIDefaultButtonView.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUIDefaultButtonView.h"
#import "TIConfig.h"

@interface TiUIDefaultButtonView ()


@end

@implementation TiUIDefaultButtonView

// MARK: --懒加载--
-(UIButton *)mainSwitchButton{
    if (_mainSwitchButton==nil){
        _mainSwitchButton = [[UIButton alloc] init];
        [_mainSwitchButton setTag:0];
        [_mainSwitchButton setImage:[UIImage imageNamed:@"gongneng_black.png"] forState:UIControlStateNormal];
        [_mainSwitchButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainSwitchButton;
}
-(UIButton *)cameraCaptureButton{
    if (_cameraCaptureButton==nil) {
        _cameraCaptureButton = [[UIButton alloc] init];
        [_cameraCaptureButton setTag:1];
        [_cameraCaptureButton setImage:[UIImage imageNamed:@"btn_kuaimen.png"] forState:UIControlStateNormal];
        [_cameraCaptureButton setImage:[UIImage imageNamed:@"btn_kuaimen.png"] forState:UIControlStateSelected];
              [_cameraCaptureButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraCaptureButton;
}
-(UIButton *)switchCameraButton{
    if (_switchCameraButton==nil) {
        _switchCameraButton = [[UIButton alloc] init];
        [_switchCameraButton setTag:2];
        [_switchCameraButton setImage:[UIImage imageNamed:@"fanzhuan_black.png"] forState:UIControlStateNormal];
        [_switchCameraButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraButton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
      [self addSubview:self.mainSwitchButton];
      [self addSubview:self.cameraCaptureButton];
      [self addSubview:self.switchCameraButton];
      [self.mainSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.mas_left).offset(DefaultButton_WIDTH/2.5);
          make.top.equalTo(self.mas_centerY);
          make.width.height.mas_equalTo(DefaultButton_WIDTH-DefaultButton_WIDTH/2);
      }];
      [self.cameraCaptureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.centerX.equalTo(self.mas_centerX);
                 make.top.equalTo(self.mas_centerY).with.offset(-30);
                 make.width.height.mas_equalTo(DefaultButton_WIDTH);
             }];
      [self.switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.right.equalTo(self.mas_right).offset(-DefaultButton_WIDTH/2.5);
                 make.top.equalTo(self.mas_centerY);
                 make.width.height.mas_equalTo(DefaultButton_WIDTH-DefaultButton_WIDTH/2);
             }];
}

-(void)onButtonClick:(UIButton *)button{
    if (self.onClickBlock) {
       self.onClickBlock(button.tag);
    }
     
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
UIView *hitView = [super hitTest:point withEvent:event];
if(hitView == self){
return nil;
}
return hitView;
}

@end

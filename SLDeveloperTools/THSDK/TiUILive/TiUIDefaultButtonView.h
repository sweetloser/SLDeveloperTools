//
//  TiUIDefaultButtonView.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiUIDefaultButtonView : UIView

@property(nonatomic, strong) UIButton *mainSwitchButton;
@property(nonatomic, strong) UIButton *cameraCaptureButton;
@property(nonatomic, strong) UIButton *switchCameraButton;

@property(nonatomic,copy)void(^onClickBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END

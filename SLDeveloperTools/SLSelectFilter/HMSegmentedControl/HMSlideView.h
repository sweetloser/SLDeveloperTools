//
//  HMSlideView.h
//  BXlive
//
//  Created by bxlive on 2019/4/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HMSliderType) {
    //美颜
    HMFilterSliderTypeColor             = 1,// 美白
    HMFilterSliderTypeBlur              = 2,// 磨皮
    HMFilterSliderTypeEyeLarge          = 3,// 大眼
    HMFilterSliderTypeThinFace          = 4,// 瘦脸
    //增强
    HMFilterSliderTypeRed               = 5,// 红润
    HMFilterSliderTypeChin              = 6,// 下巴
    HMFilterSliderTypeForehead          = 7,// 额头
    HMFilterSliderTypeNose              = 8,// 鼻子
    
};

@protocol HMSlideViewDelegate <NSObject>

- (void)slideViewValueChangedWithType:(HMSliderType)type value:(CGFloat)value;

@end

@interface HMSlideView : UIView

@property (nonatomic, assign) HMSliderType type;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat defaultValue;

@property (nonatomic, weak) id<HMSlideViewDelegate> delegate;

@end



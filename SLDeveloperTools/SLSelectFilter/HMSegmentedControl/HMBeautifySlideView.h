//
//  HMBeautifySlideView.h
//  BXlive
//
//  Created by bxlive on 2019/4/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSlideView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HMBeautifySlideViewDelegate <NSObject>

- (void)slideViewValueChangedWithType:(HMSliderType)type value:(CGFloat)value;

@end


@interface HMBeautifySlideView : UIView

@property (nonatomic, weak) id<HMBeautifySlideViewDelegate> delegate;

@property(nonatomic,strong)NSDictionary *dataDict;


-(void)resetParams;

-(instancetype)initWithFrame:(CGRect)frame leftType:(NSInteger)leftType;

@end

NS_ASSUME_NONNULL_END

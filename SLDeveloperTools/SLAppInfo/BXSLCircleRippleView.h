//
//  BXSLCircleRippleView.h
//  BXlive
//
//  Created by bxlive on 2018/10/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXSLCircleRippleView : UIView

@property (nonatomic, assign) BOOL isAnimation;

- (void)startAnimation;

- (void)stopAnimation;

@end

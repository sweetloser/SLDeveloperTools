//
//  DSLoadingView.h
//  BXlive
//
//  Created by bxlive on 2019/2/28.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXLoadingView : UIView

//显示方法
+ (instancetype)showInView:(UIView *)view width:(CGFloat)width height:(CGFloat)height;

//隐藏方法
+ (void)hide:(BXLoadingView *)loadingView;

@end

NS_ASSUME_NONNULL_END

//
//  BXNoNetworkView.h
//  BXlive
//
//  Created by bxlive on 2018/9/4.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SL_NotNetworkNeedRefreshBlock)(void);

@interface BXNoNetworkView : UIView

@property (copy, nonatomic)SL_NotNetworkNeedRefreshBlock needRefresh;

- (instancetype)initWithHeight:(CGFloat)height;

@end

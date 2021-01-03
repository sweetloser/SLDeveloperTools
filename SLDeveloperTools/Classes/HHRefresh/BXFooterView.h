//
//  BXFooterView.h
//  BXlive
//
//  Created by bxlive on 2018/10/18.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXFooterView : UIView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@property (copy, nonatomic) void (^contentSizeDidChange)(void);
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;

/** 记录scrollView刚开始的inset */
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;

@end

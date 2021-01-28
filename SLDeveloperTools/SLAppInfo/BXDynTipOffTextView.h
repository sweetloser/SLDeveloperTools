//
//  BXDynTipOffTextView.h
//  BXlive
//
//  Created by mac on 2020/7/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GHPlaceholderTextView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ReturnContentTextDelegate;

@interface BXDynTipOffTextView : UIView
@property(nonatomic, weak)id<ReturnContentTextDelegate>delegate;
//@property(nonatomic, strong)GHPlaceholderTextView *textView;

@property(nonatomic, strong)UITextView *textView;
@end

NS_ASSUME_NONNULL_END

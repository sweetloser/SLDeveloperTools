//
//  BXTextScrollView.h
//  BXlive
//
//  Created by bxlive on 2019/4/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXTextScrollView : UIView

@property(nonatomic, assign) NSString    *text;
@property(nonatomic, strong) UIColor     *textColor;
@property(nonatomic, strong) UIFont      *font;

- (void)startAnimation;
- (void)pause;
- (void)resume;

- (void)resetView;

@end

NS_ASSUME_NONNULL_END

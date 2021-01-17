//
//  BXAttentRecommView.h
//  BXlive
//
//  Created by bxlive on 2019/2/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXAttentRecommView : UIView

@property(nonatomic,copy) void(^changeConnentPeople)(void);

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END

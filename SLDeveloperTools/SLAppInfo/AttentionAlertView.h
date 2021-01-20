//
//  AttentionAlertView.h
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttentionAlertView : UIView
@property(nonatomic,copy)void(^DidClickBlock)(void);

-(instancetype)initWithFrame:(CGRect)frame;

-(void)showWithView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

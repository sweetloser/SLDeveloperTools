//
//  BXDynTipOffAlertView.h
//  BXlive
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXDynTipOffAlertView : UIView
@property(nonatomic,copy)void(^determineBlock)(NSString *user_id, NSInteger tag);

-(instancetype)initWithFrame:(CGRect)frame user_id:(NSString *)user_id;

-(void)showWithView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

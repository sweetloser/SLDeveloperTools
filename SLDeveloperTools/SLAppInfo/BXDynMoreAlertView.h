//
//  BXDynMoreAlertView.h
//  BXlive
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynamicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynMoreAlertView : UIView
@property(nonatomic,copy)void(^determineBlock)(NSString *user_id, NSInteger tag);
@property(nonatomic, strong)BXDynamicModel *model;

-(instancetype)initWithFrame:(CGRect)frame model:(BXDynamicModel *)model;


-(void)showWithView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

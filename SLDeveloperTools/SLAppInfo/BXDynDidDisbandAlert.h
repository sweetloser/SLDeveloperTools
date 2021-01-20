//
//  BXDynDidDisbandAlert.h
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynCircleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynDidDisbandAlert : UIView
@property(nonatomic, strong)BXDynCircleModel *model;
@property(nonatomic,copy)void(^DidClickBlock)();

-(instancetype)initWithFrame:(CGRect)frame;

-(void)showWithView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

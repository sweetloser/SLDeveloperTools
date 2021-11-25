//
//  QuickRechargeView.h
//  BXlive
//
//  Created by bxlive on 2018/9/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickRechargeView : UICollectionReusableView

@property(nonatomic,strong)UILabel *chargeLabel;

@property(nonatomic,copy)void(^closeView)(void);


@end

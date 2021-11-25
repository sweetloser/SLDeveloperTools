//
//  QuickRechargeFootView.h
//  BXlive
//
//  Created by 刘超 on 2020/6/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuickRechargeFootView : UICollectionReusableView

@property (nonatomic,copy)void(^typeblocl)(NSInteger type);

@property (nonatomic,copy)void(^payblock)(void);

@property(nonatomic,strong)UILabel *chargeLabel;

@end

NS_ASSUME_NONNULL_END

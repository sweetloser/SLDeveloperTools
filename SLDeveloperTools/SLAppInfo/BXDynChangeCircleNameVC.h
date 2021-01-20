//
//  BXDynChangeCircleNameVC.h
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXDynCircleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynChangeCircleNameVC : BaseVC
@property(nonatomic, strong)BXDynCircleModel *model;
@property (nonatomic, copy) void(^ChangeName)(NSString *circle_name);
@end

NS_ASSUME_NONNULL_END

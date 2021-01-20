//
//  BXDynTipOffPeopleVC.h
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXDynamicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynTipOffPeopleVC : BaseVC
@property(nonatomic, strong)BXDynamicModel *model;
@property(nonatomic, strong)NSString *reporttype;
@property(nonatomic, strong)NSString *user_id;
@property(nonatomic, strong)NSString *username;
@end

NS_ASSUME_NONNULL_END

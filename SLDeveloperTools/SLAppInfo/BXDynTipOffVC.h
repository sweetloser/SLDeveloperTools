//
//  BXDynTipOffVC.h
//  BXlive
//
//  Created by mac on 2020/7/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXDynamicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynTipOffVC : BaseVC
@property(nonatomic, strong)BXDynamicModel *model;
@property(nonatomic, strong)NSString *reporttype;
@property(nonatomic, strong)NSString *reportmsg_id;
@end

NS_ASSUME_NONNULL_END

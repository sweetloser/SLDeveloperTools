//
//  BXDynAddCircleVC.h
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynAddCircleVC : BaseVC
@property(nonatomic,copy)void(^SelCircleBlock)(NSString *circle_id, NSString *circle_name);
@end

NS_ASSUME_NONNULL_END

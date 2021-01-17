//
//  BXDynTitleListModel.h
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynTitleListModel : BaseObject
@property(nonatomic, strong)NSString *child_id;
@property(nonatomic, strong)NSString *child_name;
@property(nonatomic, strong)NSString *sel_tip;
@end

NS_ASSUME_NONNULL_END

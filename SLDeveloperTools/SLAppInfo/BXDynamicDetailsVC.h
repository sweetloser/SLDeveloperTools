//
//  BXDynamicDetailsVC.h
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXDynamicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynamicDetailsVC : BaseVC
-(instancetype)initWithType:(NSString *)type model:(BXDynamicModel *)model;
@property(nonatomic, strong)NSString *dynType;
@property(nonatomic, strong)BXDynamicModel *model;
@end

NS_ASSUME_NONNULL_END

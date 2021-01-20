//
//  BXDynCheckCircleVC.h
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXDynCircleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynCheckCircleVC : BaseVC
@property(nonatomic, strong)UIImageView *backImageView;
@property(nonatomic, strong)UIImageView *coverImageView;
@property(nonatomic, strong)BXDynCircleModel *model;
@end

NS_ASSUME_NONNULL_END

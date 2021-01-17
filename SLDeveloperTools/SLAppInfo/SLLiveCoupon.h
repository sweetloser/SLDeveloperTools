//
//  SLLiveCoupon.h
//  BXlive
//
//  Created by sweetloser on 2020/12/15.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLLiveCoupon : BaseObject

@property (nonatomic,copy)NSString *at_least;
@property (nonatomic,copy)NSString *discount;
@property (nonatomic,copy)NSString *coupon_name;
@property (nonatomic,copy)NSNumber *coupon_type_id;
@property (nonatomic,copy)NSNumber *end_time;
@property (nonatomic,copy)NSNumber *fetched;
@property (nonatomic,copy)NSNumber *fixed_term;
@property (nonatomic,copy)NSNumber *goods_type;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSNumber *is_show;
@property (nonatomic,copy)NSNumber *max_fetch;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSNumber *site_id;
@property (nonatomic,copy)NSString *site_name;
@property (nonatomic,copy)NSNumber *status;
@property (nonatomic,copy)NSNumber *reward;
@property (nonatomic,copy)NSNumber *validity_type;

@end

NS_ASSUME_NONNULL_END

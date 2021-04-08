//
//  BXdynSystemplusModel.h
//  BXlive
//
//  Created by mac on 2020/7/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXdynSystemplusModel : BaseObject
@property(nonatomic, strong)NSString *id;
@property(nonatomic, strong)NSString *goods_id;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *img;
@property(nonatomic, strong)NSString *price;
@property(nonatomic, strong)NSString *discount_price;
@property(nonatomic, strong)NSString *coupon_price;
@property(nonatomic, strong)NSString *commission_rate;
@property(nonatomic, strong)NSString *commission;
@property(nonatomic, strong)NSString *shop_type;
@property(nonatomic, strong)NSString *volume;
@property(nonatomic, strong)NSString *comfrom;
@property(nonatomic, strong)NSString *full_reduction;
@property(nonatomic, strong)NSString *roomid;
@property(nonatomic, strong)NSString *jump;
@property(nonatomic, strong)NSString *is_live;

@end


NS_ASSUME_NONNULL_END

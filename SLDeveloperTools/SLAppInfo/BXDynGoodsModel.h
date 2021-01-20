//
//  BXDynGoodsModel.h
//  BXlive
//
//  Created by mac on 2020/8/5.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynGoodsModel : BaseObject
@property(nonatomic, strong)NSString *id;
@property(nonatomic, strong)NSString *goods_id;
@property(nonatomic, strong)NSString *goods_name;
@property(nonatomic, strong)NSString *goods_type;//0:第三方 1:自营
@property(nonatomic, strong)NSString *mansong_name;//满减秒杀
@property(nonatomic, strong)NSString *coupon;//券价格
@property(nonatomic, strong)NSString *sales;//销量
@property(nonatomic, strong)NSString *pic_cover;//封面
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *img;
@property(nonatomic, strong)NSString *price;//原价
@property(nonatomic, strong)NSString *discount_price;//折扣价
@property(nonatomic, strong)NSString *coupon_price;//券价（0表示没券）
@property(nonatomic, strong)NSString *commission_rate;//比率
@property(nonatomic, strong)NSString *commission;//分享赚金额
@property(nonatomic, strong)NSString *shop_type;
@property(nonatomic, strong)NSString *volume;//销量
@end

NS_ASSUME_NONNULL_END

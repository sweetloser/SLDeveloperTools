//
//  SLLiveActivityGoods.h
//  BXlive
//
//  Created by sweetloser on 2020/12/11.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLLiveActivityGoods_Detail : NSObject

@property(nonatomic, copy) NSString *discount_price;
@property(nonatomic, copy) NSNumber *coupon_price;
@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *shop_type;
@property(nonatomic, copy) NSString *title;

@end

@interface SLLiveActivityGoods_ActivityInfo : NSObject

@property(nonatomic, copy) NSNumber *start_time;
@property(nonatomic, copy) NSNumber *end_time;
@property(nonatomic, copy) NSNumber *promotion_type;

@end

@interface SLLiveActivityGoods : NSObject

@property(nonatomic, strong)SLLiveActivityGoods_Detail *detail;
@property(nonatomic, copy) NSNumber *top_time;
@property(nonatomic, copy) NSNumber *add_time;
@property(nonatomic, copy) NSNumber *live_status;
@property(nonatomic, copy) NSNumber *table_id;
@property(nonatomic, copy) NSNumber *content;
@property(nonatomic, copy) NSNumber *goods_type;
@property(nonatomic, copy) NSNumber *goods_id;
@property(nonatomic, strong) SLLiveActivityGoods_ActivityInfo *goods_activty;

@end

NS_ASSUME_NONNULL_END

//
//  LCGoodsDetailGoodsSkusItem.h
//  BXlive
//
//  Created by Lay Chan on 2020/10/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCGoodsDetailGoodsSkusItem : NSObject

@property (nonatomic, copy) NSString *sku_id;

@property (nonatomic, copy) NSString *sku_name;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *market_price;

@property (nonatomic, copy) NSString *discount_price;

@property (nonatomic, copy) NSString *promotion_type;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

///库存
@property (nonatomic, copy) NSString *stock;

@property (nonatomic, copy) NSString *sku_image;

@property (nonatomic, copy) NSString *sku_images;

@property (nonatomic, strong) NSArray *skus;

@property (nonatomic, assign) int skuNum;

@end

NS_ASSUME_NONNULL_END

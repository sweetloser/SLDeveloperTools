//
//  LCGoodsDetailGoodsSKUItem.h
//  BXlive
//
//  Created by Lay Chan on 2020/10/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCGoodsDetailGoodsSKUItem : NSObject

@property (nonatomic, copy) NSString *spec_id;

@property (nonatomic, copy) NSString *spec_name;

@property (nonatomic, copy) NSString *spec_value_id;

@property (nonatomic, copy) NSString *spec_value_name;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, copy) NSString *sku_id;

@property (nonatomic, strong) NSArray *items;

@end

NS_ASSUME_NONNULL_END

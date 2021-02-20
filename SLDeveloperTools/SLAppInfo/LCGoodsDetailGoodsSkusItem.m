//
//  LCGoodsDetailGoodsSkusItem.m
//  BXlive
//
//  Created by Lay Chan on 2020/10/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "LCGoodsDetailGoodsSkusItem.h"

@implementation LCGoodsDetailGoodsSkusItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"skus" :@"goods_spec_format"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"skus":@"LCGoodsDetailGoodsSKUItem"};
}

@end

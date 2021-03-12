//
//  LCGoodsDetailGoodsSKUItem.m
//  BXlive
//
//  Created by Lay Chan on 2020/10/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "LCGoodsDetailGoodsSKUItem.h"

@implementation LCGoodsDetailGoodsSKUItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"items" :@"value"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"items":@"LCGoodsDetailGoodsSKUItem"};
}

@end

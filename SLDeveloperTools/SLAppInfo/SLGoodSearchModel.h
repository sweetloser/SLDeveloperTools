//
//  SLGoodSearchModel.h
//  BXlive
//
//  Created by sweetloser on 2020/5/8.
//  Copyright © 2020 cat. All rights reserved.
//
/**
{
    seller_id : 2451699564,
    volume : 88,
    has_coupon : 0,  //优惠券
    shop_name : 济南常青藤图书专营店,
    gallery_imgs : https://img.alicdn.com/i1/2451699564/O1CN018aOmnv2KWMSvt2nCU_!!0-item_pic.jpg,https://img.alicdn.com/i2/2451699564/TB2j7rSnr4npuFjSZFmXXXl4FXa_!!2451699564.jpg,https://img.alicdn.com/i4/2451699564/TB2vuo7lb8kpuFjy0FcXXaUhpXa_!!2451699564.jpg,
    discount_price : 31.85,
    img : https://img.alicdn.com/bao/uploaded/i3/2451699564/O1CN014p8W4b2KWMZGsu2xv_!!0-item_pic.jpg,
    title : 正版 图解HTTP HTTP协议入门教程书 Web前端开发图书 计算机程序设计 图灵程序设计丛书 nginx服务器精解 https安全通道解析,
    price : 31.85,
    shop_type : B,
    goods_id : 537168752521,
    short_title : 正版图解http http协议入门安全通道,
    coupon_price : 0,
    commission_rate : 1.35,
    commission : 0.43,//佣金
    item_url : https://detail.tmall.com/item.htm?id=537168752521
}
*/
#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLGoodSearchModel : BaseObject
@property (nonatomic, copy) NSNumber *update_time;
@property (nonatomic, copy) NSNumber *coupon_total;
@property (nonatomic, copy) NSNumber *is_top;
@property (nonatomic, copy) NSNumber *table_id;
@property (nonatomic, copy) NSString *serv_score;
@property (nonatomic, copy) NSString *coupon_url;
@property (nonatomic, copy) NSNumber *is_brand;
@property (nonatomic, copy) NSString *serv_percent;
@property (nonatomic, copy) NSNumber *is_new;
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *commission_rate;
@property (nonatomic, copy) NSNumber *sort;
@property (nonatomic, copy) NSString *gallery_imgs;
@property (nonatomic, copy) NSNumber *shop_id;
@property (nonatomic, copy) NSNumber *coupon_start_time;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, copy) NSNumber *is_tqg;
@property (nonatomic, copy) NSString *desc_score;
@property (nonatomic, copy) NSString *shop_type;
@property (nonatomic, copy) NSString *coupon_condition;
@property (nonatomic, copy) NSNumber *create_time;
@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSNumber *goods_type;
@property (nonatomic, copy) NSString *item_url;
@property (nonatomic, copy) NSString *desc_percent;
@property (nonatomic, copy) NSString *ship_score;
@property (nonatomic, copy) NSString *discount_price;
@property (nonatomic, copy) NSString *coupon_price;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSNumber *add_type;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSNumber *sku_id;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *commission;
@property (nonatomic, copy) NSString *ship_percent;
@property (nonatomic, copy) NSString *cate_name;
@property (nonatomic, copy) NSNumber *has_coupon;
@property (nonatomic, copy) NSString *short_title;
@property (nonatomic, copy) NSNumber *is_overseas;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSNumber *coupon_surplus;
@property (nonatomic, copy) NSNumber *add_user_id;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *videl_url;
@property (nonatomic, copy) NSNumber *is_chaoshi;
@property (nonatomic, copy) NSNumber *seller_id;
@property (nonatomic, copy) NSNumber *is_jhs;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSNumber *coupon_end_time;
@property (nonatomic, copy) NSNumber *collect_num;
@property (nonatomic, copy) NSNumber *cate_id;
@property (nonatomic, copy) NSNumber *is_add;
@property (nonatomic, copy) NSNumber *is_recommand;
@property (nonatomic, copy) NSNumber *is_collect;
@end


NS_ASSUME_NONNULL_END

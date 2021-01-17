//
//  SLLiveGoodsModel.h
//  BXlive
//
//  Created by sweetloser on 2020/5/29.
//  Copyright © 2020 cat. All rights reserved.
//
/*
 
 status : 1,
 img : http://img14.360buyimg.com/ads/jfs/t1/114821/26/7979/179334/5ec7ce44E31633bd2/b932ee8a185de40e.jpg,
 discount_price : 4458.00,
 id : 22,
 price : 4458.00,
 title : 华为p40 5G手机（白条6期免息） 亮黑色 8+128G全网通,
 shop_type : J,
 has_coupon : 1,
 shop_name : 炜东电商旗舰店,
 short_title :
 */

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
     top_time : 0,
     content : ,
     sort : 999,
     live_status : 0,
     add_time : 1590713677,
     room_id : 11305,
     detail : {
     discount_price : 4458.00,
     img : http://img14.360buyimg.com/ads/jfs/t1/114821/26/7979/179334/5ec7ce44E31633bd2/b932ee8a185de40e.jpg,
     shop_type : J,
     title : 华为p40 5G手机（白条6期免息） 亮黑色 8+128G全网通
 }*/

@interface SLLiveGoodsDetailModel : BaseObject
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *shop_type;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *discount_price;
@property(nonatomic,copy)NSString *coupon_price;
@property(nonatomic,copy)NSString *short_title;
@end

@interface SLLiveGoodsActivity : BaseObject
@property(nonatomic,copy)NSNumber *start_time;
@property(nonatomic,copy)NSNumber *end_time;
@property(nonatomic,copy)NSNumber *promotion_type;

@end

@interface SLLiveGoodsModel : BaseObject
@property(nonatomic,copy)NSNumber *top_time;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSNumber *sort;
@property(nonatomic,copy)NSNumber *live_status;
@property(nonatomic,copy)NSNumber *add_time;
@property(nonatomic,copy)NSNumber *room_id;
@property(nonatomic,strong)SLLiveGoodsDetailModel *detail;
@property(nonatomic,strong)SLLiveGoodsActivity *goods_activty;
@property(nonatomic,copy)NSNumber *goods_type;
@property(nonatomic,copy)NSNumber *goods_id;
@property(nonatomic,copy)NSNumber *table_id;



@end

NS_ASSUME_NONNULL_END

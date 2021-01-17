//
//  TMB2B2CHTTPRequest.m
//  BXlive
//
//  Created by mac on 2020/10/28.
//  Copyright © 2020 cat. All rights reserved.
//

#import "TMShopHTTPRequest.h"
#import "NewHttpManager.h"
@implementation TMShopHTTPRequest
+(void)WaitPayOrderInfoWithCart_ids:(NSString *)cart_ids
                             sku_id:(NSString *)sku_id
                                num:(NSString *)num
                         is_balance:(NSString *)is_balance
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void (^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Ordercreate/getWaitPayOrderInfo" parameters:@{@"cart_ids":[self stringNoNil:cart_ids], @"sku_id":[self stringNoNil:sku_id], @"num":[self stringNoNil:num], @"is_balance":[self stringNoNil:is_balance], @"app_type":@"ios",@"app_type_name":@"app"} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+(void)CalOrderDataInfoWithCart_ids:(NSString *)cart_ids
                             sku_id:(NSString *)sku_id
                                num:(NSString *)num
                         is_balance:(NSString *)is_balance
                      buyer_message:(NSString *)buyer_message
                           delivery:(NSString *)delivery
                             coupon:(NSString *)coupon
                    platform_coupon:(NSString *)platform_coupon
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Ordercreate/calOrderData" parameters:@{@"cart_ids":[self stringNoNil:cart_ids], @"sku_id":[self stringNoNil:sku_id], @"num":[self stringNoNil:num], @"is_balance":[self stringNoNil:is_balance], @"app_type":@"ios",@"app_type_name":@"app",@"buyer_message":[self stringNoNil:buyer_message],@"delivery":[self stringNoNil:delivery], @"coupon":[self stringNoNil:coupon],@"platform_coupon_id":[self stringNoNil:platform_coupon]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)OrderCreateWithCart_ids:(NSString *)cart_ids
                        sku_id:(NSString *)sku_id
                           num:(NSString *)num
                    is_balance:(NSString *)is_balance
                 buyer_message:(NSString *)buyer_message
                      delivery:(NSString *)delivery
                        coupon:(NSString *)coupon
                member_address:(NSString *)member_address
            platform_coupon_id:(NSString *)platform_coupon_id
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Ordercreate/create" parameters:@{@"cart_ids":[self stringNoNil:cart_ids], @"sku_id":[self stringNoNil:sku_id], @"num":[self stringNoNil:num], @"is_balance":[self stringNoNil:is_balance], @"app_type":@"ios",@"app_type_name":@"app",@"buyer_message":[self stringNoNil:buyer_message],@"coupon":[self stringNoNil:coupon],@"delivery":[self stringNoNil:delivery],@"member_address":[self stringNoNil:member_address],@"platform_coupon_id":[self stringNoNil:platform_coupon_id]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)GetOrderListWithOrder_status:(NSString *)order_status
                               page:(NSString *)page
                          page_size:(NSString *)page_size
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Order/getLists" parameters:@{@"order_status":[self stringNoNil:order_status],@"page":[self stringNoNil:page],@"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)GetOrderDetailWithOrder_id:(NSString *)order_id
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Order/getDetail" parameters:@{@"order_id":[self stringNoNil:order_id]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)CloseOrderWithOrder_id:(NSString *)order_id
                cancle_reason:(NSString *)cancle_reason
                      content:(NSString *)content
                      Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Order/close" parameters:@{@"order_id":[self stringNoNil:order_id],@"cancle_reason":[self stringNoNil:cancle_reason],@"content":[self stringNoNil:content]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)DeleteOrderWithOrder_id:(NSString *)order_id
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Order/delete" parameters:@{@"order_id":[self stringNoNil:order_id]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)getCloseOrderReasonListSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                              Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Order/getCloseReasonList" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)TakeDeliveryOrderWithOrder_id:(NSString *)order_id
                             Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                             Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Order/takeDelivery" parameters:@{@"order_id":[self stringNoNil:order_id]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)RefundOrderWithOrder_goods_id:(NSString *)order_goods_id
                         refund_type:(NSString *)refund_type
                        refund_reson:(NSString *)refund_reson
                       refund_remark:(NSString *)refund_remark
                             Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                             Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Orderrefund/createRefundOrder" parameters:@{@"order_goods_id":[self stringNoNil:order_goods_id],@"refund_type":[self stringNoNil:refund_type],@"refund_reson":[self stringNoNil:refund_reson],@"refund_remark":[self stringNoNil:refund_remark]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)getRefundReasonListSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Orderrefund/getReasonList" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)RefundGoodsDeliveryWithOrder_goods_id:(NSString *)order_goods_id
                        refund_delivery_name:(NSString *)refund_delivery_name
                          refund_delivery_no:(NSString *)refund_delivery_no
                               refund_remark:(NSString *)refund_remark
                                     Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                     Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Orderrefund/refundGoodsDelivery" parameters:@{@"order_goods_id":[self stringNoNil:order_goods_id],@"refund_delivery_name":[self stringNoNil:refund_delivery_name],@"refund_delivery_no":[self stringNoNil:refund_delivery_no],@"refund_remark":[self stringNoNil:refund_remark]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)GetCartListSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Cart/getCartList" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}


+(void)GetCartShopInfoWithSite_id:(NSString *)site_id
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Cart/getCartShopInfo" parameters:@{@"site_id":[self stringNoNil:site_id]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)EditCartNumWithCart_id:(NSString *)cart_id
                          num:(NSString *)num
                      Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Cart/editCart" parameters:@{@"cart_id":[self stringNoNil:cart_id],@"num":[self stringNoNil:num]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)ClearCartSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Cart/clear" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)DeleteCartCart_id:(NSString *)cart_id
                 Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Cart/delete" parameters:@{@"cart_id":[self stringNoNil:cart_id]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}


+(void)AddCartSite_id:(NSString *)site_id
               sku_id:(NSString *)sku_id
                  num:(NSString *)num
              Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
              Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Cart/add2Cart" parameters:@{@"cart_id":[self stringNoNil:site_id],@"sku_id":[self stringNoNil:sku_id],@"num":[self stringNoNil:num]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)UploadEvaluateVideoWithArrayVideo:(NSArray *)videoArray
                          IsShowProgress:(BOOL)isShow
                                 Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                 Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] UploadFilePOST:@"bxapi/Upload/evaluatevideo" parameters:nil FileArray:videoArray IsShowProgress:(BOOL)isShow success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

//评价上传图片
+(void)UploadEvaluateImageWithArrayImage:(NSArray *)ImageArray
                          IsShowProgress:(BOOL)isShow
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                 Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] UploadFilePOST:@"bxapi/Upload/evaluateimg" parameters:nil FileArray:ImageArray IsShowProgress:(BOOL)isShow success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)AdvGetListWithKeyword:(NSString *)keyword
                     Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                     Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Adv/getList" parameters:@{@"keyword":[self stringNoNil:keyword]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}
//添加商品页->直播电商推荐
+(void)GetRecommandLiveGoodsSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"livegoods/api/Goodslivesku/getRecommandGoodsLists" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)GetRecommandGoodsListsWithis_playform_recommand:(NSString *)is_playform_recommand
                                          is_recommand:(NSString *)is_recommand
                                               site_id:(NSString *)site_id
                                                  page:(NSString *)page
                                             page_size:(NSString *)page_size
                                               Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                               Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Goodssku/getRecommandGoodsLists" parameters:@{@"is_playform_recommand":[self stringNoNil:is_playform_recommand],@"is_recommand":[self stringNoNil:is_recommand],@"site_id":[self stringNoNil:site_id],@"page":[self stringNoNil:page],@"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)NavGetListsWithpage:(NSString *)page
                 page_size:(NSString *)page_size
                   Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Nav/getLists" parameters:@{@"page":[self stringNoNil:page],@"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)GoodscategoryTreeWithlevel:(NSString *)level
                     is_recommand:(NSString *)is_recommand
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Goodscategory/getTree" parameters:@{@"level":[self stringNoNil:level],@"is_recommand":[self stringNoNil:is_recommand]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)GetStatListWithDay:(NSString *)day
                 goods_id:(NSString *)goods_id
                  Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"livegoods/api/Goodslivesku/getStatList" parameters:@{@"day":[self stringNoNil:day],@"goods_id":[self stringNoNil:goods_id]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}


+(void)GetGoodsDetailWithSku_id:(NSString *)sku_id
                        Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                        Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"livegoods/api/Goodslivesku/getGoodsDetail" parameters:@{@"sku_id":[self stringNoNil:sku_id]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)GoodsskuGetGoodsListsWithpage:(NSString *)page
                           page_size:(NSString *)page_size
                             site_id:(NSString *)site_id
                             keyword:(NSString *)keyword
                         category_id:(NSString *)category_id
                      category_level:(NSString *)category_level
                            brand_id:(NSString *)brand_id
                           min_price:(NSString *)min_price
                           max_price:(NSString *)max_price
                    is_free_shipping:(NSString *)is_free_shipping
                              is_own:(NSString *)is_own
                               order:(NSString *)order
                                sort:(NSString *)sort
                    shop_category_id:(NSString *)shop_category_id
                        is_recommand:(NSString *)is_recommand
                             Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                             Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Goodssku/getGoodsLists" parameters:@{@"page":[self stringNoNil:page],@"page_size":[self stringNoNil:page_size],@"site_id":[self stringNoNil:site_id],@"keyword":[self stringNoNil:keyword],@"category_id":[self stringNoNil:category_id],@"category_level":[self stringNoNil:category_level],@"brand_id":[self stringNoNil:brand_id],@"min_price":[self stringNoNil:min_price],@"max_price":[self stringNoNil:max_price],@"is_free_shipping":[self stringNoNil:is_free_shipping],@"is_own":[self stringNoNil:is_own],@"order":[self stringNoNil:order],@"sort":[self stringNoNil:sort],@"shop_category_id":[self stringNoNil:shop_category_id],@"is_recommand":[self stringNoNil:is_recommand]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


+(void)GetMyFouncsGrassWithPage_index:(NSString *)page_index
                            page_size:(NSString *)page_size
                              Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                              Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/grass/getMyFouncs" parameters:@{@"page_index":[self stringNoNil:page_index],@"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}
+(void)PlantingGrassCommentWithFcmid:(NSString *)fcmid
                            content:(NSString *)content
                               imgs:(NSString *)imgs
                           privateid:(NSString *)privateid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/comment/CommentMsg" parameters:@{@"content":[self stringNoNil:content],@"fcmid":[self stringNoNil:fcmid],@"imgs":[self stringNoNil:imgs],@"privateid":[self stringNoNil:privateid]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

//种草进行留言评论
+(void)PlantingGrassEvaluateMsgWithCommentid:(NSString *)commentid
                                     content:(NSString *)content
                                       touid:(NSString *)touid
                                     Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                     Failure:(void(^)(NSError *error))failure;{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/evaluate/evaluateMsg" parameters:@{@"content":[self stringNoNil:content],@"commentid":[self stringNoNil:commentid],@"touid":[self stringNoNil:touid]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)PlantingGrassCommentLikeWithCommentid:(NSString *)commentid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/comment/commentLive" parameters:@{@"commentid":[self stringNoNil:commentid]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}
//种草评论进行点赞/取消
+(void)PlantingGrassevaluateLikeWithCommentmsgid:(NSString *)commentmsgid
                                         Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                         Failure:(void(^)(NSError *error))failure;{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/evaluate/evaluateLive" parameters:@{@"commentmsgid":[self stringNoNil:commentmsgid]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}
//种草进行评论
+(void)PlantingGrassCommentListWithFcmid:(NSString *)fcmid
                              page_index:(NSString *)page_index
                               page_size:(NSString *)page_size
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                 Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/comment/commentList" parameters:@{@"fcmid":[self stringNoNil:fcmid],@"page_index":[self stringNoNil:page_index],@"page_size":[self stringNoNil:page_size]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)PlantingGrassCommentDeleteWithCommentid:(NSString *)commentid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/comment/commentdel" parameters:@{@"commentid":[self stringNoNil:commentid]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)PlantingGrassEvaluateDeleteWithEvalid:(NSString *)evalid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/evaluate/evaluateDel" parameters:@{@"evalid":[self stringNoNil:evalid]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}



+(void)PlantingGrassCommentDetailWithCommentid:(NSString *)commentid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/comment/commentDetail" parameters:@{@"commentid":[self stringNoNil:commentid]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)PlantingGrassTopicListWithTopic_id:(NSString *)topic_id
                                  Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                  Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/topic/topicgoList" parameters:@{@"topic_id":[self stringNoNil:topic_id]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}
+(void)CreateOrderRechargeWithRecharge_id:(NSString *)recharge_id
                                  Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                  Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"memberrecharge/api/Ordercreate/create" parameters:@{@"recharge_id":[self stringNoNil:recharge_id],@"app_type":@"app",@"app_type_name":@"ios"} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)CreateOrderPayWithPay_type:(NSString *)pay_type
                     Out_trade_no:(NSString *)out_trade_no
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Pay/getPay" parameters:@{@"pay_type":[self stringNoNil:pay_type],@"out_trade_no":[self stringNoNil:out_trade_no]} success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)myWalletSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
               Failure:(void(^)(NSError *error))failure{
    [[NewHttpManager sharedNetManager] AmwayPost:@"fenxiao/api/Withdraw/mywallet" parameters:nil success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        BOOL flag = NO;
        if (![code integerValue]) {
            flag = YES;
        }
        success(responseObject,flag,nil);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+ (NSString *)stringNoNil:(NSString *)str {
    if (str) {
        return str;
    } else {
        return @"";
    }
}

@end

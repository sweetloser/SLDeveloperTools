//
//  TMB2B2CHTTPRequest.h
//  BXlive
//
//  Created by mac on 2020/10/28.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface TMShopHTTPRequest : NSObject



//确认订单
+(void)WaitPayOrderInfoWithCart_ids:(NSString *)cart_ids
                        sku_id:(NSString *)sku_id
                             num:(NSString *)num
                     is_balance:(NSString *)is_balance
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

//订单信息计算
+(void)CalOrderDataInfoWithCart_ids:(NSString *)cart_ids
                             sku_id:(NSString *)sku_id
                                num:(NSString *)num
                         is_balance:(NSString *)is_balance
                      buyer_message:(NSString *)buyer_message
                           delivery:(NSString *)delivery
                             coupon:(NSString *)coupon
                    platform_coupon:(NSString *)platform_coupon
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;
//创建订单
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
                       Failure:(void(^)(NSError *error))failure;

//获取订单列表
+(void)GetOrderListWithOrder_status:(NSString *)order_status
                               page:(NSString *)page
                          page_size:(NSString *)page_size
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//获取订单详情
+(void)GetOrderDetailWithOrder_id:(NSString *)order_id
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//取消/关闭订单
+(void)CloseOrderWithOrder_id:(NSString *)order_id
                cancle_reason:(NSString *)cancle_reason//取消原因(1： "价格有点贵", 2： "规格/款式/数量拍错",3："收货地址拍错",4： "暂时不需要了",5： "其他",)
                      content:(NSString *)content
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//删除订单
+(void)DeleteOrderWithOrder_id:(NSString *)order_id
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;


//获取取消订单列表
+(void)getCloseOrderReasonListSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                              Failure:(void(^)(NSError *error))failure;

//确认收货订单
+(void)TakeDeliveryOrderWithOrder_id:(NSString *)order_id
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//申请退款
+(void)RefundOrderWithOrder_goods_id:(NSString *)order_goods_id
                      refund_type:(NSString *)refund_type
                      refund_reson:(NSString *)refund_reson
                      refund_remark:(NSString *)refund_remark
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;


//获取退款原因列表
+(void)getRefundReasonListSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

//退货退款
+(void)RefundGoodsDeliveryWithOrder_goods_id:(NSString *)order_goods_id
                        refund_delivery_name:(NSString *)refund_delivery_name
                          refund_delivery_no:(NSString *)refund_delivery_no
                      refund_remark:(NSString *)refund_remark
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//用户购物车列表
+(void)GetCartListSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                  Failure:(void(^)(NSError *error))failure;

//获取购物车满减活动和佣金
+(void)GetCartShopInfoWithSite_id:(NSString *)site_id
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                          Failure:(void(^)(NSError *error))failure;

//修改购物车商品数量
+(void)EditCartNumWithCart_id:(NSString *)cart_id
                          num:(NSString *)num
                      Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure;

//清空购物车
+(void)ClearCartSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                      Failure:(void(^)(NSError *error))failure;

//删除指定购物车
+(void)DeleteCartCart_id:(NSString *)cart_id
                 Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 Failure:(void(^)(NSError *error))failure;

//添加购物车
+(void)AddCartSite_id:(NSString *)site_id
               sku_id:(NSString *)sku_id
                  num:(NSString *)num
                 Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                 Failure:(void(^)(NSError *error))failure;

//评价上传视频
+(void)UploadEvaluateVideoWithArrayVideo:(NSArray *)videoArray
                          IsShowProgress:(BOOL)isShow
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;

//评价上传图片
+(void)UploadEvaluateImageWithArrayImage:(NSArray *)ImageArray
                          IsShowProgress:(BOOL)isShow
                       Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                       Failure:(void(^)(NSError *error))failure;


//添加商品页->推荐商品->滚动图片
+(void)AdvGetListWithKeyword:(NSString *)keyword
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//添加商品页->直播电商推荐
+(void)GetRecommandLiveGoodsSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//添加商品页->推荐商品->推荐
+(void)GetRecommandGoodsListsWithis_playform_recommand:(NSString *)is_playform_recommand
                                          is_recommand:(NSString *)is_recommand
                                               site_id:(NSString *)site_id
                                                  page:(NSString *)page
                                             page_size:(NSString *)page_size
                                               Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                               Failure:(void(^)(NSError *error))failure;
//添加商品页->推荐商品->导航栏
+(void)NavGetListsWithpage:(NSString *)page
                 page_size:(NSString *)page_size
                   Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   Failure:(void(^)(NSError *error))failure;


//添加商品页->推荐商品->获取商城主分类导航栏
+(void)GoodscategoryTreeWithlevel:(NSString *)level
                     is_recommand:(NSString *)is_recommand
                   Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   Failure:(void(^)(NSError *error))failure;

//商品推广
+(void)GetStatListWithDay:(NSString *)day
                     goods_id:(NSString *)goods_id
                   Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   Failure:(void(^)(NSError *error))failure;

//商品推广-->商品详情
+(void)GetGoodsDetailWithSku_id:(NSString *)sku_id
                   Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                   Failure:(void(^)(NSError *error))failure;

//添加商品页->推荐商品->商品列表
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
                             Failure:(void(^)(NSError *error))failure;


//我关注的种草
+(void)GetMyFouncsGrassWithPage_index:(NSString *)page_index
                            page_size:(NSString *)page_size
                              Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                              Failure:(void(^)(NSError *error))failure;


//种草进行评论
+(void)PlantingGrassCommentWithFcmid:(NSString *)fcmid
                            content:(NSString *)content
                               imgs:(NSString *)imgs
                           privateid:(NSString *)privateid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//种草进行留言评论
+(void)PlantingGrassEvaluateMsgWithCommentid:(NSString *)commentid
                            content:(NSString *)content
                               touid:(NSString *)touid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//种草评论进行点赞/取消
+(void)PlantingGrassCommentLikeWithCommentid:(NSString *)commentid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//种草评论留言进行点赞/取消
+(void)PlantingGrassevaluateLikeWithCommentmsgid:(NSString *)commentmsgid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//种草评论列表
+(void)PlantingGrassCommentListWithFcmid:(NSString *)fcmid
                              page_index:(NSString *)page_index
                               page_size:(NSString *)page_size
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//删除评论
+(void)PlantingGrassCommentDeleteWithCommentid:(NSString *)commentid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//删除留言评论
+(void)PlantingGrassEvaluateDeleteWithEvalid:(NSString *)evalid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

//评论详情
+(void)PlantingGrassCommentDetailWithCommentid:(NSString *)commentid
                            Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                            Failure:(void(^)(NSError *error))failure;

+(void)PlantingGrassTopicListWithTopic_id:(NSString *)topic_id
                                  Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                  Failure:(void(^)(NSError *error))failure;


//创建充值订单
+(void)CreateOrderRechargeWithRecharge_id:(NSString *)recharge_id
                                  Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                  Failure:(void(^)(NSError *error))failure;

//创建支付订单
+(void)CreateOrderPayWithPay_type:(NSString *)pay_type
                     Out_trade_no:(NSString *)out_trade_no
                          Success:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
                                  Failure:(void(^)(NSError *error))failure;



//我的钱包
+(void)myWalletSuccess:(void(^)(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models))success
               Failure:(void(^)(NSError *error))failure;

@end


NS_ASSUME_NONNULL_END

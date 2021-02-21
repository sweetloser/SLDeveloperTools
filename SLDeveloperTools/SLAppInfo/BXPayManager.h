//
//  BXPayManager.h
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WXApi.h>
#import <WechatAuthSDK.h>

#import <AlipaySDK/AlipaySDK.h>


/*
 
 //先获取微信支付参数
 //...
 
 BXPayManager *manager = [BXPayManager getInstance];
 [manager wechatPayWithAppId:@"" partnerId:@"" prepayId:@"" package:@"" nonceStr:@"" timeStamp:@"" sign:@"" respBlock:^(NSInteger respCode, NSString *respMsg) {
 
 //处理支付结果
 
 }];
 }
 
 //先获取支付宝支付参数
 //...
 
 BXPayManager *manager = [BXPayManager getInstance];
 [manager aliPayOrder:@"" scheme:@"" respBlock:^(NSInteger respCode, NSString *respMsg) {
 
 //处理支付结果
 
 }];
 
 
 
 */



/*
 respCode:
 0    -    支付成功
 -1   -    支付失败
 -2   -    支付取消
 -3   -    未安装App(适用于微信)
 -99  -    未知错误
 */
typedef void (^BXPayManagerRespBlock)(NSInteger respCode, NSString *respMsg);


/*
 ApplePay设备和系统支持状态
 */
typedef NS_ENUM(NSInteger, DSApplePaySupportStatus)
{
    kDSApplePaySupport,                    //完全支持
    kDSApplePayDeviceOrVersionNotSupport,  //设备或系统不支持
    kDSApplePayUnknown                     //未知状态
};



@interface BXPayManager : NSObject <WXApiDelegate>

+ (BXPayManager *)getInstance;


//***************微信*****************//

/*
 微信支付结果回调
 */
@property (nonatomic, strong)BXPayManagerRespBlock wechatRespBlock;

/*
 检查是否安装微信
 */
+ (BOOL)isWXAppInstalled;

/*
 注册微信appId
 */
+ (BOOL)wechatRegisterAppWithAppId:(NSString *)appId;

/*
 处理微信通过URL启动App时传递回来的数据
 */
+ (BOOL)wechatHandCKpenURL:(NSURL *)url;

/*
 发起微信支付
 */
- (void)wechatPayWithAppId:(NSString *)appId
                 partnerId:(NSString *)partnerId
                  prepayId:(NSString *)prepayId
                   package:(NSString *)package
                  nonceStr:(NSString *)nonceStr
                 timeStamp:(NSString *)timeStamp
                      sign:(NSString *)sign
                 respBlock:(BXPayManagerRespBlock)block;








//***************支付宝*****************//

/*
 支付宝支付结果回调
 */
@property (nonatomic, strong)BXPayManagerRespBlock alipayRespBlock;

/*
 处理支付宝通过URL启动App时传递回来的数据
 */
+ (BOOL)alipayHandCKpenURL:(NSURL *)url;

/*
 发起支付宝支付
 */
- (void)aliPayOrder:(NSString *)order
             scheme:(NSString *)scheme
          respBlock:(BXPayManagerRespBlock)block;




@end


//
//  DSPayManager.m
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//
#import "SLAppInfoMacro.h"
#import "BXPayManager.h"
@implementation BXPayManager

+ (BXPayManager *)getInstance {
    static BXPayManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[BXPayManager alloc] init];
        
    });
    
    return instance;
}

//微信
+ (BOOL)isWXAppInstalled {
    return [WXApi isWXAppInstalled];
}
+ (BOOL)wechatRegisterAppWithAppId:(NSString *)appId {

    BOOL isOk = [WXApi registerApp:appId universalLink:SL_UNIVERSAL_LINK];
    return isOk;
}
+ (BOOL)wechatHandCKpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[BXPayManager getInstance]];
}
- (void)wechatPayWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign respBlock:(BXPayManagerRespBlock)block {
    self.wechatRespBlock = block;
    
    if([WXApi isWXAppInstalled]) {
        PayReq *req = [[PayReq alloc] init];
        req.openID = appId;
        req.partnerId = partnerId;
        req.prepayId = prepayId;
        req.package = package;
        req.nonceStr = nonceStr;
        req.timeStamp = (UInt32)timeStamp.integerValue;
        req.sign = sign;
        
        [WXApi sendReq:req completion:^(BOOL success) {
            NSLog(@"吊起支付成功");
        }];
    }else {
        if(self.wechatRespBlock) {
            self.wechatRespBlock(-3, @"未安装微信");
        }
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp {
    if([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case 0:
            {
                if(self.wechatRespBlock) {
                    self.wechatRespBlock(0, @"支付成功");
                }
                
                NSLog(@"支付成功");
                break;
            }
            case -1:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-1, @"支付失败");
                }
                
                NSLog(@"支付失败");
                break;
            }
            case -2:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-2, @"支付取消");
                }
                
                NSLog(@"支付取消");
                break;
            }
                
            default:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-99, @"未知错误");
                }
            }
                break;
        }
    }
    
    self.wechatRespBlock = nil;
    
}
//微信






//支付宝
+ (BOOL)alipayHandCKpenURL:(NSURL *)url
{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        BXPayManager *manager = [BXPayManager getInstance];
        NSNumber *code = resultDic[@"resultStatus"];
        
        if(code.integerValue==9000)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-99, @"未知错误");
            }
        }
        
    }];
    
    return YES;
}
- (void)aliPayOrder:(NSString *)order scheme:(NSString *)scheme respBlock:(BXPayManagerRespBlock)block
{
    self.alipayRespBlock = block;
    
    __weak __typeof(&*self)ws = self;
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        NSNumber *code = resultDic[@"resultStatus"];
        
        if(code.integerValue==9000)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-99, @"未知错误");
            }
        }
        
    }];
}
//支付宝





@end


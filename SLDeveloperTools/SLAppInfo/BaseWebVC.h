//
//  BaseWebVC.h
//  BXlive
//
//  Created by bxlive on 2017/5/3.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BaseVC.h"
#import <WebKit/WebKit.h>

@interface BaseWebVC : BaseVC
@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) WKUserContentController *userContentController;
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic,copy) NSString *loadUrl;

@property (assign, nonatomic)BOOL isHiddenNav;
- (void)createData;
- (void)back;
-(void)uploadWithType:(NSString *)type;

-(void)goGoodsDetail:(NSString *)sku_id;

-(void)goSeckillGoodsDetail:(NSString *)kill_id;

-(void)goToShop:(NSString *)shop_id;

-(void)openAccount;

-(void)openRecharge;

-(void)goToCouponList;

-(void)goToWithdraw:(NSString *)draw_type;

-(void)goToKefu:(NSString *)data_type;

- (void)toRecharge;
- (void)goToWithUrl:(NSString *)url;



@end

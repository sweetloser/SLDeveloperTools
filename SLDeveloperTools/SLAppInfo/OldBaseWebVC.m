//
//  BaseWebVC.m
//  BXlive
//
//  Created by bxlive on 2017/5/3.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "OldBaseWebVC.h"
#import <CoreServices/UTType.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "BXLiveUser.h"
#import "BXAppInfo.h"
#import "SLAppInfoConst.h"
#import "SLAppInfoMacro.h"

#import <YYWebImage/YYWebImage.h>
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import <Aspects/Aspects.h>
#import <SobotKit/ZCSobot.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
//#import <WXApi.h>
//#import <WXApiObject.h>
//#import "QuickRechargePopView.h"
//#import "BXImagePickerManager.h"
//#import <Aspects.h>
//#import "ShareManager.h"
#import <WKWebViewJavascriptBridge.h>

static NSString * const kWXAppID = @"";

@interface OldBaseWebVC ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (strong, nonatomic) WKWebViewJavascriptBridge *bridge;



//@property (strong, nonatomic) BXImagePickerManager *manager;



@end

@implementation OldBaseWebVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:[UIColor sl_colorWithHex:0xDFE9E9]]];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:WhiteBgTitleColor, NSFontAttributeName:CBFont(20)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:PageBackgroundColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:PageBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:MainTitleColor, NSFontAttributeName:CBFont(20)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self isMemberOfClass:[OldBaseWebVC class]]) {
        [self createData];
    }
    [self createNav];
}
-(void)createNav{
    

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.view.backgroundColor = [UIColor clearColor];
    
    
}

- (void)back{
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }else{
        [self backToPreviousVC:@"pop"];
    }
}

- (void)backToPreviousVC:(NSString *)type {
//    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"OOXX"];
    [self removeJSFunction];
    if ([type isEqualToString:@"pop"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - ***** 进度条
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 3.0)];
        _progressView.progressTintColor = sl_webProgressTintColor;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark - ***** UI创建
- (void)createData {
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    if (@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.wkWebView.backgroundColor = [UIColor whiteColor];
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView setCustomUserAgent:@"dsbrowser_ios"];
    [self.view addSubview:self.wkWebView];
    
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrl]];
    [self.wkWebView loadRequest:request];
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    __weak WKWebView *wkwebView = self.wkWebView;
    // 添加下拉刷新控件
    BXRefreshHeader *header = [BXRefreshHeader headerWithRefreshingBlock:^{
        [wkwebView reload];
    }];
    self.wkWebView.scrollView.mj_header = header;
    
    [self registJSFunction];
    
}

//注册js方法，js调用oc
- (void)registJSFunction {
    
    //商品详情
    [self.bridge registerHandler:@"goGoodsDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self goGoodsDetail:[NSString stringWithFormat:@"%@", [data description]]];
    }];
    //秒杀商品详情
    [self.bridge registerHandler:@"goSeckillGoodsDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self goSeckillGoodsDetail:[NSString stringWithFormat:@"%@", [data description]]];
    }];
    
    //返回
    [self.bridge registerHandler:@"getfinish" handler:^(id data, WVJBResponseCallback responseCallback) {
            
    }];
    
    //进入店铺
    [self.bridge registerHandler:@"goToShop" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self goToShop:data];
    }];
    
    //绑定账号
    [self.bridge registerHandler:@"openAccount" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self openAccount];
    }];
    
    //充值
    [self.bridge registerHandler:@"openRecharge" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self openRecharge];
    }];
    //提现
    [self.bridge registerHandler:@"goToWithdraw" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self goToWithdraw:data];
    }];
    
    //联系客服
    [self.bridge registerHandler:@"customerKefu" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self goToKefu:data];
    }];
    
    //进入优惠券
    [self.bridge registerHandler:@"goMyCoupon" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self goToCouponList];
    }];
    
    
    //相
    [self.bridge registerHandler:@"createGuildPullImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self uploadWithType:data];
    }];
    
    
    [self.bridge registerHandler:@"getPayWxDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self smallShopPay:data];
    }];
    
    //导航栏返回
    [self.bridge registerHandler:@"navigateBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self backToPreviousVC:@"pop"];
    }];
    
    [self.bridge registerHandler:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isDictionary]) {
            [self shareWithTitle:data[@"title"] descr:data[@"descr"] thumb:data[@"thumb"] url:data[@"url"] share_key:data[@"share_key"]];
        }
    }];
    [self.bridge registerHandler:@"getVersion" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback) {
            // 反馈给JS
            NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            responseCallback(@{@"vcode":@"", @"version":currentVersion});
        }
    }];
    
    [self.bridge registerHandler:@"getUser" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"aagetUser");
        responseCallback(@{@"user_id":BXLiveUser.currentBXLiveUser.user_id});
    }];
    
    [self.bridge registerHandler:@"getDeviceInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"adasdasda");
    }];
    
    [self.bridge registerHandler:@"goTo" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isDictionary]) {
            NSString *url = data[@"url"];
            [self goToWithUrl:url];
        }
    }];

    [self.bridge registerHandler:@"openWxAPP" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isDictionary]) {
            [self openWxAPP:data[@"userName"] path:data[@"path"] miniProgramType:[data[@"miniProgramType"] integerValue]];
        }
    }];
}
- (void)shareWithTitle:(NSString *)title descr:(NSString *)descr thumb:(NSString *)thumb url:(NSString *)url share_key:(NSString *)share_key{
//    [ShareManager shareWithShareType:nil targetId:nil title:title descr:descr thumb:thumb url:url share_key:share_key currentVC:self shareCompletion:^(NSString *share_channel, NSError *error) {
//
//        }];
}


-(void)openWxAPP:(NSString *)userName path:(NSString *)path miniProgramType:(NSInteger )miniProgramType {
    
//    [WXApi registerApp:kWXAppID universalLink:@""];
//    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
//    launchMiniProgramReq.userName = userName;  //拉起的小程序的username
//    launchMiniProgramReq.path = path;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
//    launchMiniProgramReq.miniProgramType = miniProgramType; //拉起小程序的类型
//    [WXApi sendReq:launchMiniProgramReq completion:nil];
}

- (void)toRecharge {
//    QuickRechargePopView *pop = [[QuickRechargePopView alloc]initWithShareObject];
//    [pop show:self.navigationController.view];
}

- (void)goToWithUrl:(NSString *)url {
//    [BXLocalAgreement loadUrl:url fromVc:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:BXLoadURL object:nil userInfo:@{@"vc":self,@"url":url}];
}

//移除js方法
- (void)removeJSFunction {
    
    
    
    {
        [self.bridge removeHandler:@"goGoodsDetail"];
        
        [self.bridge removeHandler:@"goSeckillGoodsDetail"];
        
        [self.bridge removeHandler:@"getfinish"];
        
        [self.bridge removeHandler:@"goToShop"];
        
        [self.bridge removeHandler:@"openAccount"];
        
        [self.bridge removeHandler:@"openRecharge"];
        
        [self.bridge removeHandler:@"goToWithdraw"];
        
        [self.bridge removeHandler:@"customerKefu"];
        
        [self.bridge removeHandler:@"goMyCoupon"];
    }
    [self.bridge removeHandler:@"navigateBack"];
    
    [self.bridge removeHandler:@"openAccount"];
    
    [self.bridge removeHandler:@"share"];
    
    [self.bridge removeHandler:@"getVersion"];
    
    [self.bridge removeHandler:@"getUser"];
    
    [self.bridge removeHandler:@"uploadFile"];
    
    [self.bridge removeHandler:@"recharge"];
    
    [self.bridge removeHandler:@"goTo"];
    
    [self.bridge removeHandler:@"openWxAPP"];
    
    [self.bridge removeHandler:@"createGuildPullImage"];
    

    
//    开启小店调用支付
    [self.bridge removeHandler:@"getPayWxDetail"];
    
    
    
    
}

#pragma mark 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",message.name);
    NSLog(@"%@",[message.body description]);
    if ([message.name isEqualToString:@"navigateBack"]) {
        
        [self backToPreviousVC:[message.body description]];
        
    }else if([message.name isEqualToString:@"share"]) {
        
        if ([message.body isDictionary]) {
            NSDictionary *data = (NSDictionary *)message.body;
            [self shareWithTitle:data[@"title"] descr:data[@"descr"] thumb:data[@"thumb"] url:data[@"url"] share_key:data[@"share_key"]];
        }
        
    }else if([message.name isEqualToString:@"getVersion"]) {
        
    }else if([message.name isEqualToString:@"getUser"]) {
        
    }else if([message.name isEqualToString:@"uploadFile"]) {
        
    }else if([message.name isEqualToString:@"recharge"]) {
        
    }else if([message.name isEqualToString:@"goTo"]) {
        
    }else if([message.name isEqualToString:@"openWxAPP"]) {
        
    }else if([message.name isEqualToString:@"createGuildPullImage"]) {
        
        [self uploadWithType:[NSString stringWithFormat:@"%@", [message.body description]]];
        
    }else if([message.name isEqualToString:@"getPayWxDetail"]) {
        [self smallShopPay:message.body];
        
    }else if([message.name isEqualToString:@"goGoodsDetail"]) {
        
    }
    else if([message.name isEqualToString:@"openAccount"]) {
        [self openAccount];
    }
    else if([message.name isEqualToString:@"goToShop"]) {
        [self goToShop:[NSString stringWithFormat:@"%@", [message.body description]]];
    }
    else if([message.name isEqualToString:@"openRecharge"]) {
        [self openRecharge];
    }
    else if([message.name isEqualToString:@"goToWithdraw"]) {
        [self goToWithdraw:[NSString stringWithFormat:@"%@", [message.body description]]];
    }
    else if([message.name isEqualToString:@"customerKefu"]) {
        [self goToKefu:[NSString stringWithFormat:@"%@", [message.body description]]];
    }else if([message.name isEqualToString:@"goSeckillGoodsDetail"]) {
        [self goSeckillGoodsDetail:[NSString stringWithFormat:@"%@", [message.body description]]];
    }else if([message.name isEqualToString:@"goMyCoupon"]) {
        [self goToCouponList];
    }
    
    
}
-(void)smallShopPay:(id)params{
    
}
-(void)goToCouponList{
    
}
-(void)uploadWithType:(NSString *)type{
    
}
-(void)goSeckillGoodsDetail:(NSString *)kill_id{
    
}
-(void)goGoodsDetail:(NSString *)sku_id{
    
}
-(void)goToShop:(NSString *)shop_id{
    
}
-(void)openAccount{
    
}
-(void)openRecharge{
    
}
-(void)goToWithdraw:(NSString *)draw_type{
    
}
-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
         
         NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
         
         completionHandler(NSURLSessionAuthChallengeUseCredential,card);
         
     }
}
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"确定",@"Sure", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"确定",@"Sure", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"取消",@"Sure", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    if ([[URL absoluteString] isEqualToString:@"https://www.sobot.com/chat/h5/index.html?sysNum=aa5402a408e040c3abc2bb268649c6f3"]||[[URL absoluteString] isEqualToString:@"tel:400-188-7008"]){
        [ZCChatController aspect_hookSelector:@selector(loadView) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            ZCChatController *chatController = aspectInfo.instance;
            chatController.fd_prefersNavigationBarHidden = YES;
        } error:NULL];
        
        [ZCChatController aspect_hookSelector:@selector(preferredStatusBarStyle) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo) {
            UIStatusBarStyle barStyle = UIStatusBarStyleLightContent;
            NSInvocation *invocation = aspectInfo.originalInvocation;
            [invocation setReturnValue:&barStyle];
        } error:NULL];
        
        [ZCUIBaseController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            ZCUIBaseController *baseController = aspectInfo.instance;
            baseController.fd_prefersNavigationBarHidden = YES;
        } error:NULL];
        
        [NSClassFromString(@"ZCVideoViewController") aspect_hookSelector:@selector(prefersStatusBarHidden) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo) {
            BOOL barHidden = YES;
            NSInvocation *invocation = aspectInfo.originalInvocation;
            [invocation setReturnValue:&barHidden];
        } error:NULL];
        
        // 启动
        ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
        // 企业编号 必填
        initInfo.app_key = ZC_KEY;
        // 用户id，用于标识用户，建议填写 (注意：userId不要写死，否则获取的历史记录相同)
//        initInfo.isEnableAutoTips = YES;
        initInfo.title_type = @"1";
        initInfo.face = [BXLiveUser currentBXLiveUser].avatar;
        initInfo.custom_title = [BXLiveUser currentBXLiveUser].nickname;
        initInfo.user_nick = [BXLiveUser currentBXLiveUser].nickname;
        initInfo.partnerid = [BXLiveUser currentBXLiveUser].user_id;
        //配置UI
        ZCKitInfo *uiInfo=[ZCKitInfo new];
        // 是否显示转人工按钮
        uiInfo.isShowTansfer = YES;
//        uiInfo.isShowNickName = YES;
        uiInfo.navcBarHidden = YES;
        //设置启动参数
        [[ZCLibClient getZCLibClient] setLibInitInfo:initInfo];
        
        
        ZCChatController * chat = [[ZCChatController alloc] initWithInitInfo:uiInfo];
        chat.isPush= YES;
        [self.navigationController pushViewController:chat animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    //加载完成
//    WS(weakSelf);
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.title"] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSString *title = [NSString stringWithFormat:@"%@",response];
//            if (self.isHiddenNav) {
//            }else{
                self.navigationItem.title = title;

//            }
        }
    }];
    NSString *js = [NSString stringWithFormat:@"getToken(%@)", [BXAppInfo appInfo].access_token];
    [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable res, NSError * _Nullable error) {
        NSLog(@"%@", res);
    }];
    [self.wkWebView.scrollView.mj_header endRefreshing];
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.wkWebView = nil;
}

//-(void)onResp:(BaseResp *)resp {
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


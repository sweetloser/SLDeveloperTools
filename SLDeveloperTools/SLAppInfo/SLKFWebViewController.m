//
//  WKWebViewController.m
//  webview-test
//
//  Created by tagaxi on 10/26/17.
//  Copyright © 2017 JackYin. All rights reserved.
//

#import "SLKFWebViewController.h"
#import <WebKit/WebKit.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
static NSString *const CSUserDefaultsGuestID = @"CSUserDefaultsGuestID";

@interface SLKFWebViewController ()<WKUIDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate>

@property (nonatomic,strong)WKWebView *webView;

@end

@implementation SLKFWebViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    /**
     *  此文档仅供参考
     *
     *  1.请注意在你们的接口后面拼接 device=ios 字段才可以正常使用。
     *  2.请注意内部调用相册，拍摄功能，需要你添加相机，相册，麦克风三个权限。
     *  3.JS交互方法: 其中"writeData"方法为必写方法，旨在加载时候request加载cookie使用
     *  4.咨询地址后面拼接header=none，可隐藏导航栏，从而自定义导航栏
     */
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.title = @"WebView";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWkWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"back"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"writeData"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"back"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"writeData"];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)initWkWebView{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    configuration.userContentController = userContentController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 10.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:configuration];
    
    // 此处假设你们接入的网址为 https://master.71baomu.com/code/app/10013223/1
    // 则应该加上device=ios字段,如 https://master.71baomu.com/code/app/10013223/1?device=ios
    // 如需隐藏导航栏，则地址为 https://master.71baomu.com/code/app/10013223/1?device=ios&header=none
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?device=ios",self.url]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 添加cookie
    NSString *guestID = [[NSUserDefaults standardUserDefaults] objectForKey:CSUserDefaultsGuestID];
    if (guestID && [guestID isKindOfClass:[NSString class]]) {
        [request addValue:[NSString stringWithFormat:@"guest_id=%@",guestID] forHTTPHeaderField:@"Cookie"];
    }
    
    [self.webView loadRequest:request];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
/**
 * JS 调用 OC 触发此方法
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"back"]) {
        NSLog(@"点击了返回按钮");
        // do something
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([message.name isEqualToString:@"writeData"]){
        NSString *guestID = (NSString *)message.body;
        if (guestID && [guestID isKindOfClass:[NSString class]]) {
            /**
             * 此处为访客的ID，可与你们的账号进行对应保存，添加cookie时候把本地对应的guestID取出来
             * 比如你们的账号是accountA,那么可以保存@{@"accountA",guestID},而非guestID,取的时候也应该按照账号取出guestID,放入cookie
             */
            [[NSUserDefaults standardUserDefaults] setObject:guestID forKey:CSUserDefaultsGuestID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成");
}

#pragma mark - 处理点击相册崩溃或者不弹出问题
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    if (self.presentedViewController) {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

@end

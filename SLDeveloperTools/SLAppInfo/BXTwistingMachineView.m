//
//  BXTwistingMachineView.m
//  BXlive
//
//  Created by bxlive on 2019/1/17.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXTwistingMachineView.h"
#import <WebKit/WebKit.h>
#import "BaseWebVC.h"
#import "BXLiveUser.h"
@interface BXTwistingMachineView () <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *roomId;
@property (weak, nonatomic) UINavigationController *nav;

@end

@implementation BXTwistingMachineView

- (instancetype)initWithUrl:(NSString *)url roomId:(NSString *)roomId vc:(UINavigationController *)nav {
    self = [super init];
    if (self) {
        _url = url;
        _roomId = roomId;
        _nav = nav;
        
        NSString *loadUrl = [self getloadUrlWithUrl:_url roomId:roomId];
//        NSLog(@"网址:%@",loadUrl);
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.opaque = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
        [self addSubview:_webView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:loadUrl]];
        [_webView loadRequest:request];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _webView.frame = self.bounds;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *loadUrl = [self getloadUrlWithUrl:_url roomId:_roomId];
    if ([navigationAction.request.URL.absoluteString isEqualToString:loadUrl]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        loadUrl = navigationAction.request.URL.absoluteString;
        NSURL *url = [NSURL URLWithString:loadUrl];
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        for (NSURLQueryItem *item in urlComponents.queryItems) {
            [parameter setValue:item.value forKey:item.name];
        }
        
        NSString *active_type = parameter[@"active_type"];
        if (active_type && [active_type integerValue] == 1) {
            CGFloat height = [parameter[@"view_height"] floatValue];
            if (_toDetail) {
                _toDetail(loadUrl, height);
            }
        } else {
            if (_nav) {
                BaseWebVC *webVC = [[BaseWebVC alloc]init];
                webVC.loadUrl = loadUrl;
                [_nav pushViewController:webVC animated:YES];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (NSString *)getloadUrlWithUrl:(NSString *)url roomId:(NSString *)roomId {
    NSString *loadUrl = url;
    
    //已经拼接了参数。
    if ([loadUrl containsString:@"&"]) {
        return loadUrl;
    }
    
    if ([loadUrl containsString:@"?"]) {
        loadUrl = [NSString stringWithFormat:@"%@&room_id=%@&user_id=%@",loadUrl,roomId,[BXLiveUser currentBXLiveUser].user_id];
    } else {
        loadUrl = [NSString stringWithFormat:@"%@?room_id=%@&user_id=%@",loadUrl,roomId,[BXLiveUser currentBXLiveUser].user_id];
    }
    return loadUrl;
}

@end

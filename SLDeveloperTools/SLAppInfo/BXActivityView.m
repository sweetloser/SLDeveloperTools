//
//  BXActivityView.m
//  BXlive
//
//  Created by bxlive on 2019/3/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXActivityView.h"
#import <WebKit/WebKit.h>
#import "../SLMacro/SLMacro.h"
#import "BXLiveUser.h"

@interface BXActivityView () <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation BXActivityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if ([super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.opaque = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
        [self addSubview:_webView];
    }
    return self;
}

- (void)setActivity:(BXActivity *)activity {
    _activity = activity;
    
    if (activity) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self getloadUrlWithUrl:activity.slider_url]]];
        [_webView loadRequest:request];
        
        NSArray *positions = [activity.position componentsSeparatedByString:@","];
        CGFloat width = 0;
        CGFloat height = 0;
        if (positions.count == 4) {
            width = [positions[2] floatValue];
            height = [positions[3] floatValue];
        }
        self.frame = CGRectMake(16, 64 + __kTopAddHeight + 20, width, height);
        
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _webView.frame = self.bounds;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *loadUrl = [self getloadUrlWithUrl:_activity.slider_url];
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
            if (_toWebVC) {
                _toWebVC(loadUrl);
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (NSString *)getloadUrlWithUrl:(NSString *)url {
    NSString *loadUrl = url;
    if ([loadUrl containsString:@"?"]) {
        loadUrl = [NSString stringWithFormat:@"%@&user_id=%@&video_id=%@",loadUrl,[BXLiveUser currentBXLiveUser].user_id,_activity.video_id];
    } else {
        loadUrl = [NSString stringWithFormat:@"%@?user_id=%@&video_id=%@",loadUrl,[BXLiveUser currentBXLiveUser].user_id,_activity.video_id];
    }
    return loadUrl;
}

@end

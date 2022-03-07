//
//  BXSLTwistingMachineVC.m
//  BXlive
//
//  Created by bxlive on 2019/1/2.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLTwistingMachineVC.h"
#import "UIApplication+ActivityViewController.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"


@interface BXSLTwistingMachineVC () <WKNavigationDelegate>

@end

@implementation BXSLTwistingMachineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPop];
    [self  createData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willDismissPopupController:) name:kWillDismissPopupController object:nil];
}

- (void)initPop {
    self.view.backgroundColor = CHHCOLOR_D(0x2c1152);
    self.contentSizeInPopup = CGSizeMake(__kWidth, __kWidth / _heightRate + __kBottomAddHeight);
    self.popupController.navigationBarHidden = YES;
}

-(void)createData{
    UIImageView *bgIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kWidth * 1167.0 / 750)];
    bgIv.image = CImage(@"twistingMachine");
    [self.view addSubview:bgIv];
    
    [super createData];
    self.progressView.hidden = YES;
    self.wkWebView.sd_resetLayout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).topSpaceToView(self.view, 0);
    self.wkWebView.opaque = NO;
    self.wkWebView.backgroundColor = [UIColor clearColor];
    self.wkWebView.scrollView.backgroundColor = [UIColor clearColor];
    self.wkWebView.scrollView.bounces = NO;
    self.wkWebView.scrollView.mj_header = nil;
    self.wkWebView.hidden = YES;
}

- (void)toRecharge {
    [self.popupController dismissWithCompletion:^{
//        UIViewController *vc = [[UIApplication sharedApplication] activityViewController];
//        QuickRechargePopView *pop = [[QuickRechargePopView alloc]initWithShareObject];
//
//        if (vc.tabBarController && !vc.tabBarController.tabBar.hidden) {
//            [pop show:vc.tabBarController.view];
//        } else {
//            [pop show:vc.view];
//        }
    }];
}

- (void)goToWithUrl:(NSString *)url {
    [self.popupController dismissWithCompletion:^{
        [super goToWithUrl:url];
    }];
}

- (void)removeJS {
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"OOXX"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(removeJSFunction)];
#pragma clang diagnostic pop
    
}

#pragma mark - 心愿单 - 帮ta实现
-(void)wishGift:(NSDictionary *)giftDict{
    [self.popupController dismiss];
    if (self.wishGiftBlock) {
        self.wishGiftBlock(giftDict);
    }
}


-(void)backBtnClick{
    [self removeJS];
    [self.popupController popToRootViewControllerAnimated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.wkWebView.hidden = NO;
}

#pragma - mark NSNotification
- (void)willDismissPopupController:(NSNotification *)noti {
    [self removeJS];
}

@end

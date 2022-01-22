//
//  DSTaskCenterVC.m
//  BXlive
//
//  Created by bxlive on 2019/5/28.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXTaskCenterVC.h"
#import "BXRefreshHeader.h"
#import <Masonry/Masonry.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "SLDeveloperTools.h"

@interface BXTaskCenterVC ()<UIScrollViewDelegate,WKNavigationDelegate>
@property(nonatomic, strong)UIButton *backbutton;
@property (strong, nonatomic) UILabel *viewTitlelabel;
@end

@interface MyCenterRefresh : BXRefreshHeader
@property(nonatomic, strong)UIImageView *topImage;
@end
@implementation BXTaskCenterVC

-(UIStatusBarStyle)preferredStatusBarStyle {
    //返回白色
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(__kTopAddHeight + 64);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.loadUrl = [NSString stringWithFormat:@"%@",self.urlString];
    
    UIImageView *topimage = [[UIImageView alloc]init];
    topimage.image = CImage(@"person_taskcenter_topview");
    [self.view addSubview:topimage];
    [topimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(__kTopAddHeight + 64);
    }];
    
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.scrollView.delegate = self;
    self.wkWebView.backgroundColor = SLClearColor;
//    self.wkWebView.scrollView.bounces = NO;
    
    __weak WKWebView *wkwebView = self.wkWebView;
    // 添加下拉刷新控件
    MyCenterRefresh *header = [MyCenterRefresh headerWithRefreshingBlock:^{
        [wkwebView reload];
    }];

    self.wkWebView.scrollView.mj_header = header;
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(__kTopAddHeight + 64);
        make.height.mas_equalTo(3);
    }];
    
    _viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.textColor = [UIColor whiteColor];
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = SLMFont(18);
    [self.view addSubview:_viewTitlelabel];
    [_viewTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(__ScaleWidth(72/4*6));
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self.view.mas_centerX);

    }];

    _backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backbutton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [_backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backbutton];
    [_backbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.height.mas_equalTo(44);
    }];
}
-(void)createNav{

}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    //加载完成
    WS(weakSelf);
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.title"] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSString *title = [NSString stringWithFormat:@"%@",response];

            weakSelf.viewTitlelabel.text = title;
        }
    }];
    [self.wkWebView.scrollView.mj_header endRefreshing];
}
-(void)goToWithUrl:(NSString *)url{
    [[NSNotificationCenter defaultCenter] postNotificationName:BXLoadURL object:nil userInfo:@{@"vc":self,@"url":url}];
}


@end

@implementation MyCenterRefresh

- (void)prepare
{
    [super prepare];
    self.backgroundColor = SLClearColor;
    _topImage = [[UIImageView alloc]init];
    _topImage.image = CImage(@"person_taskcenter_topview");
    [self addSubview:_topImage];
    
    [self addSubview:self.logoView];
    [self addSubview:self.titleLb];
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    _topImage.frame = CGRectMake(0, -600, self.mj_w, 660);
}
@end

//
//  BXDynCheckCircleVC.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCheckCircleVC.h"
#import "BXDynCircleHeaderView.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <YYCategories/YYCategories.h>
#import "SLAppInfoMacro.h"

@interface BXDynCheckCircleVC ()
@property (nonatomic , strong) UIView * navView;
@property(nonatomic, strong)UIButton *checkBtn;
@end

@implementation BXDynCheckCircleVC
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    icon_dyn_cirlce_add_detail
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initHeaderView];
    [self setNavView];
    
    _checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_checkBtn setTitle:@"圈子审核中" forState:UIControlStateNormal];
    _checkBtn.backgroundColor = UIColorHex(#FF2D52);
    _checkBtn.layer.masksToBounds = YES;
    _checkBtn.layer.cornerRadius = 25;
    [_checkBtn addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _checkBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    [self.view addSubview:_checkBtn];
    [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(50);
    }];
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    

    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_white") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];

    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];

}
-(void)initHeaderView{
  BXDynCircleHeaderView  *_circleHeaderView = [[BXDynCircleHeaderView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 300)];
    _circleHeaderView.backgroundColor = [UIColor cyanColor];
    _circleHeaderView.model = self.model;
    _circleHeaderView.isHiddenPart = YES;
    [self.view addSubview:_circleHeaderView];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 12;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_circleHeaderView.mas_bottom).offset(-10);
        make.bottom.left.right.mas_equalTo(0);
    }];
}
-(void)backClick{
    [self pop];
}
-(void)checkClick{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

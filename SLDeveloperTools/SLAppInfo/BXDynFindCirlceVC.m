//
//  BXDynFindCirlceVC.m
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynFindCirlceVC.h"
#import "BXAttentionVC.h"
//#import "BXHomepageVC.h"
#import "BXSLSearchVC.h"
#import "BXPagerMainScrollView.h"
//#import "BaseTabBarController.h"
//#import "AppDelegate.h"
//#import "BXHomeDynamic.h"
#import "JXGradientView.h"
#import "BXDynFindCircleHomeVC.h"
#import "BXDynFindCircleMyVC.h"
#import "BXDynCreateCircleVC.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "BXLiveUser.h"
#import "SLAppInfoConst.h"

@interface BXDynFindCirlceVC () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic , strong) UIView * navView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
//@property (nonatomic, strong) BXHomepageVC *homepageVC;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) BOOL isLogin;

@end

@implementation BXDynFindCirlceVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {

        return UIStatusBarStyleDefault;
    }
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    };
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
   
    _titles = @[@"发现圈子", @"我的"];
    _isLogin = [BXLiveUser isLogin];
    [self initViews];
    [self addObserver];
}

- (void)initViews {
//    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
//    self.navView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.navView];
    
//     CGFloat width = (SCREEN_WIDTH/2.0 - 120/2.f)/2.0;
    _categoryView = [[JXCategoryTitleView alloc] init];
    _categoryView.titles = _titles;
//    _categoryView.cellSpacing = 40;
//    _categoryView.cellWidth = 120/2.f;
//    _categoryView.averageCellSpacingEnabled = yes;
//    _categoryView.contentEdgeInsetLeft = 100;
//    _categoryView.contentEdgeInsetRight = width;
    _categoryView.frame = CGRectMake(100, 20 + __kTopAddHeight, __kWidth - 200, 44);
    _categoryView.titleFont = CBFont(16);
    _categoryView.titleColor = UIColorHex(#8C8C8C);
    _categoryView.titleSelectedColor = UIColorHex(#282828);
    _categoryView.titleSelectedFont = CBFont(18);
    _categoryView.titleColorGradientEnabled = YES;
    _categoryView.titleLabelZoomEnabled = YES;
    _categoryView.titleLabelZoomScale = 1.3;
    _categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
    _categoryView.selectedAnimationEnabled = YES;
    _categoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    JXGradientView *gradientView = [JXGradientView new];
    gradientView.gradientLayer.endPoint = CGPointMake(1, 0);
    gradientView.gradientLayer.colors = @[(__bridge id)UIColorHex(FF2D52).CGColor, (__bridge id)UIColorHex(FF2D52).CGColor];
    gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gradientView.layer.masksToBounds = YES;
    gradientView.layer.cornerRadius = 2;
    [lineView addSubview:gradientView];
    lineView.indicatorWidth = 25;
    lineView.indicatorHeight = 2;
    lineView.indicatorCornerRadius = 2;
    self.categoryView.indicators = @[lineView];
    
    [self.view addSubview:_categoryView];

    _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    _listContainerView.frame = CGRectMake(0, 0, __kWidth, __kHeight);
    [self.view addSubview:_listContainerView];
    self.categoryView.listContainer = _listContainerView;
    
    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
    [self.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];


    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    [backBtn addTarget:self action:@selector(backAct) forControlEvents:BtnTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setImage:CImage(@"icon_dyn_cirlce_add") forState:BtnNormal];
    [addBtn addTarget:self action:@selector(addAct) forControlEvents:BtnTouchUpInside];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginAction) name:kDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogoutAction) name:kDidLogoutNotification object:nil];
}

- (void)backAct {
    [self pop];
}

-(void)addAct{
    BXDynCreateCircleVC *vc = [BXDynCreateCircleVC new];
    [self pushVc:vc];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.view bringSubviewToFront:_categoryView];
}

#pragma mark - JXCategoryViewDelegate
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    if (index && !_isLogin) {
//        [BXCodeLoginVC toLoginViewControllerWithNav:self.navigationController];
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":self.navigationController}];
        return NO;
    }
    return YES;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
//    if (index == 2) {
//        _categoryView.titleColor = UIColorHex(#8C8C8C);
//        _categoryView.titleSelectedColor = [UIColor blackColor];
//    }else{
//        _categoryView.titleColor = [TextBrightestColor colorWithAlphaComponent:.65];
//        _categoryView.titleSelectedColor = TextBrightestColor;
//    }
   
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
  

}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
    

    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    if (!_isLogin) {
//        [BXCodeLoginVC toLoginViewControllerWithNav:self.navigationController];
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2Login object:nil userInfo:@{@"nav":self.navigationController}];
        return;
    }
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (UIScrollView *)scrollViewInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    UIScrollView *scrollView = [[BXPagerMainScrollView alloc]init];
    return scrollView;
}

-(id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 1) {
        BXDynFindCircleMyVC<JXCategoryListContentViewDelegate> *vc = [[BXDynFindCircleMyVC alloc]init];
        [self addChildViewController:vc];
        return vc;
    } else{
        BXDynFindCircleHomeVC<JXCategoryListContentViewDelegate> *vc = [[BXDynFindCircleHomeVC alloc]init];
        [self addChildViewController:vc];
        return vc;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

#pragma - mark NSNotification
- (void)didLoginAction {
    _isLogin = YES;
}

- (void)didLogoutAction {
    [_categoryView selectItemAtIndex:0];
    [_listContainerView didClickSelectedItemAtIndex:0];
    _isLogin = NO;
}

@end

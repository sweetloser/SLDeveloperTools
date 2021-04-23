//
//  BXSLSearchResultVC.m
//  BXlive
//
//  Created by bxlive on 2019/3/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchResultVC.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryTitleView.h"
#import "JXGradientView.h"
#import "BXSLSearchingVC.h"
#import "BXSLSearchAllVC.h"
#import "BXSLSearchVideoVC.h"
#import "BXSLSearchUserVC.h"
#import "BXSLSearchLiveVC.h"
#import "BXSLSearchManager.h"
//#import "SLSearchDynamicVC.h"
//#import "BXDynGlobleVC.h"
#import <CTMediatorSLDynamic/CTMediator+SLDynamic.h>

#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "SLAppInfoConst.h"
#import "BXAppInfo.h"

@interface BXSLSearchResultVC () <UITextFieldDelegate, YHSearchingVCDelegate, JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,JXCategoryTitleViewDataSource>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, strong) NSMutableArray *childVcs;

@property (nonatomic, assign) NSInteger index;

@end

@implementation BXSLSearchResultVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    _childVcs = [NSMutableArray array];
    [self addSearchBar];
    [self initChildVcs];
    [self initViews];
    [self.categoryView reloadData];
    if (_searchText) {
        [BXSLSearchManager addSearchHistoryWithSearchText:_searchText];
    }
}

- (void)addSearchBar {
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 64 + __kTopAddHeight)];
    [self.view addSubview:navBar];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:BtnNormal];
    backBtn.frame = CGRectMake(__ScaleWidth(12), 20 + __kTopAddHeight + 6, 32, 32);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(pop) forControlEvents:BtnTouchUpInside];
    [navBar addSubview:backBtn];
    
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 39, 34)];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuo_icon_sousuo"]];
    iconIv.contentMode = UIViewContentModeCenter;
    iconIv.frame = CGRectMake(16, 9, 16, 16);
    [leftview addSubview:iconIv];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(__ScaleWidth(41), 20 + __kTopAddHeight + 5, __ScaleWidth(294), 34)];
    textField.textColor =  sl_textColors;
    textField.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
    textField.layer.cornerRadius = 17;
    textField.layer.masksToBounds = YES;
    textField.font = SLPFFont(14);
    textField.leftView = leftview;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜一搜" attributes:@{NSForegroundColorAttributeName:sl_textSubColors}];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.text = _searchText;
    [navBar addSubview:textField];
    UIButton *clearBtn =[textField valueForKey:@"_clearButton"];
    [clearBtn setImage:CImage(@"login_clear") forState:BtnNormal];
    
    _textField = textField;
    
    self.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
    
}

- (void)initViews {
    if ([[BXAppInfo appInfo].is_dynamic_open intValue] == 0) {
        self.titles = @[@"综合",@"视频",@"用户",@"直播"];
    }else{
        self.titles = @[@"综合",@"视频",@"用户",@"直播",@"动态"];
    }
    
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.titleSelectedColor = sl_normalColors;
    self.categoryView.titleColor = sl_textSubColors;
    self.categoryView.titleFont = SLPFFont(16);
    self.categoryView.titleSelectedFont = SLBFont(16);
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.frame = CGRectMake(0,  64 + __kTopAddHeight, self.view.bounds.size.width, 44);
    
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    JXGradientView *gradientView = [JXGradientView new];
    gradientView.gradientLayer.endPoint = CGPointMake(1, 0);
    gradientView.gradientLayer.colors = @[(__bridge id)sl_normalColors.CGColor, (__bridge id)sl_normalColors.CGColor];
    gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gradientView.layer.masksToBounds = YES;
    gradientView.layer.cornerRadius = 1;
    [lineView addSubview:gradientView];
    lineView.indicatorColor = sl_normalColors;
    lineView.indicatorWidth = __ScaleWidth(34);
    lineView.indicatorHeight = 2;
    lineView.indicatorCornerRadius = 1;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.delegate = self;
    self.categoryView.titleDataSource = self;
    [self.view addSubview:self.categoryView];
    
    _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0, 44 +  64 + __kTopAddHeight, __kWidth, self.view.bounds.size.height - 44 - 64 - __kTopAddHeight);
    self.categoryView.listContainer = _listContainerView;
    [self.view addSubview:self.listContainerView];
    self.categoryView.titles = self.titles;
    [self.listContainerView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

//#pragma mark - JXCategoryTitleViewDataSource
//
//-(CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView widthForTitle:(NSString *)title{
//    return self.view.width / 5;
//}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

-(id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    BaseVC<JXCategoryListContentViewDelegate> *vc = nil;
    vc = self.childVcs[index];
    _index = index;
    [self addChildViewController:vc];
    return vc;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


- (void)initChildVcs {
//    WS(ws);
//    BXSLSearchAllVC *allVc = [[BXSLSearchAllVC alloc] init];
//    allVc.searchResultVC = self;
//    allVc.moreDetail = ^(NSInteger index) {
//       [ws.categoryView selectItemAtIndex:index];
//    };
    //    allVc.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
    if ([[BXAppInfo appInfo].is_dynamic_open intValue] == 0) {
        WS(ws);
        BXSLSearchAllVC *allVc = [[BXSLSearchAllVC alloc] init];
        allVc.searchResultVC = self;
        allVc.moreDetail = ^(NSInteger index) {
            [ws.categoryView selectItemAtIndex:index];
        };
        allVc.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
        [_childVcs addObject:allVc];
    }else{
        UIViewController *allVc = [[CTMediator sharedInstance] BXDynGlobleVC_ViewControllerWithDyntype:@"6" searchResultVC:self];
//        BXDynGlobleVC *allVc = [[BXDynGlobleVC alloc] init];
//        allVc.dyntype = @"6";//类型6 综合
//        allVc.searchResultVC = self;
        [_childVcs addObject:allVc];
    }

    
//    视频
    BXSLSearchVideoVC *videoVc = [[BXSLSearchVideoVC alloc]init];
    videoVc.searchResultVC = self;
    videoVc.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
    [_childVcs addObject:videoVc];
//    用户
    BXSLSearchUserVC *userVc = [[BXSLSearchUserVC alloc]init];
    userVc.searchResultVC = self;
    userVc.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
    [_childVcs addObject:userVc];
    
//    直播
    BXSLSearchLiveVC *liveVc = [[BXSLSearchLiveVC alloc]init];
    liveVc.searchResultVC = self;
    liveVc.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
    [_childVcs addObject:liveVc];
     
//    动态
//    SLSearchDynamicVC *dynamicVc = [[SLSearchDynamicVC alloc] init];
//    dynamicVc.searchResultVC = self;
//    dynamicVc.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
    
    if ([[BXAppInfo appInfo].is_dynamic_open intValue] == 0) {
        
    }else{
        UIViewController *dynamicVc = [[CTMediator sharedInstance] BXDynGlobleVC_ViewControllerWithDyntype:@"5" searchResultVC:self];
//        BXDynGlobleVC *dynamicVc = [[BXDynGlobleVC alloc] init];
//        dynamicVc.dyntype = @"5";//类型5 搜索
//        dynamicVc.searchResultVC = self;
        dynamicVc.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
        [_childVcs addObject:dynamicVc];
    }
    

}



#pragma - mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BXSLSearchingVC *vc = [[BXSLSearchingVC alloc]init];
    vc.type = 1;
    vc.searchText = _searchText;
    vc.delegate = self;
    vc.view.frame = self.view.frame;
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    return NO;
}

#pragma - mark YHSearchingVCDelegate
- (void)cancelSearch {
    self.textField.x = 16;
    self.textField.width = SearchTextFieldNormalWidth;
    [UIView animateWithDuration:.5 animations:^{
        self.textField.x = 50;
    }];
}

- (void)searchText:(NSString *)text {
    if (!IsEquallString(text, _searchText)) {
        _searchText = text;
        _textField.text = text;
        
        [BXSLSearchManager addSearchHistoryWithSearchText:_searchText];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNeedSearchNotification object:nil userInfo:@{@"searchText":_searchText, @"type":[NSString stringWithFormat:@"%ld",(long)_index]}];
    }
}



@end

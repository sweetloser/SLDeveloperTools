//
//  BXDynRollCircleCategory.m
//  BXlive
//
//  Created by mac on 2020/8/3.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynRollCircleCategory.h"
#import "JXCategoryTitleView.h"
#import "JXGradientView.h"
#import "BXDynCircleHeaderView.h"
#import "BXDynGlobleVC.h"
#import "BXDynCircleHomeVC.h"
#import "BXDynCircleVideoVC.h"
//#import "DynSharePopViewManager.h"
#import "BXLiveUser.h"
#import "BXOPenIssueDyn.h"
#import "BaseNavVC.h"
#import "BXDynTipOffVC.h"
#import "BXDynCircleModel.h"
#import "BXDynamicModel.h"
#import "AttentionAlertView.h"
#import "BXDynFindCirlceVC.h"
#import "BXDynCirlcePeopleManagerVC.h"
#import "BXDynCircleManagerVC.h"
#import "BXDynDidDisbandAlert.h"
#import "BXPagerMainScrollView.h"
#import "HttpMakeFriendRequest.h"
#import <YYCategories/YYCategories.h>
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "SLAppInfoMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoConst.h"

@interface BXDynRollCircleCategory ()<JXCategoryViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) BXDynCircleHeaderView *circleHeaderView;


@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) BXDynCircleHomeVC *circleVC;

@property (nonatomic , strong) UIView * navView;

@property(nonatomic, strong)UIButton *takeTopicBtn;

@property(nonatomic, strong)UIButton *reportBtn;

@property(nonatomic, strong)UIButton *moreBtn;

@property(nonatomic, strong)UIButton *peopleBtn;

@property(nonatomic, strong)UIButton *cirlceSetBtn;

@property(nonatomic, strong)UIButton *backBtn;

@property(nonatomic, strong)UIButton *ShareBtn;

@property(nonatomic,assign)BOOL isMid;

@property(nonatomic, strong)UIView *slTemView;

@end

@implementation BXDynRollCircleCategory
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}
//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    };
//}
-(void)getCircledetailData{
    WS(weakSelf);
    [HttpMakeFriendRequest DetailCircleWithcircle_id:self.model.circle_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            if (flag) {
                BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
                [model updateWithJsonDic:jsonDic[@"data"]];
                weakSelf.model = model;
                weakSelf.circleHeaderView.model = model;
                [weakSelf upNavView];
            }
            else{
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
            }
        } Failure:^(NSError * _Nonnull error) {
            [BGProgressHUD showInfoWithMessage:@"获取圈子详情失败"];
        }];
}
-(void)upNavView{
    if ([[NSString stringWithFormat:@"%@", self.model.ismy] isEqualToString:@"1"]) {
        _moreBtn.hidden = YES;
        _cirlceSetBtn.hidden = NO;
    }else{
        _moreBtn.hidden = NO;
        _cirlceSetBtn.hidden = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = [[NSMutableArray alloc]initWithObjects:@"综合", @"视频", nil];
    [self initHeaderView];
    [self initJXView];
    [self initNavView];
    
    _takeTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_takeTopicBtn setImage:CImage(@"icon_dyn_cirlce_takein") forState:UIControlStateNormal];
    [_takeTopicBtn addTarget:self action:@selector(takeTopicAtc) forControlEvents:UIControlEventTouchUpInside];
    _takeTopicBtn.layer.masksToBounds = YES;
    _takeTopicBtn.layer.cornerRadius = 25;
    [self.view addSubview:_takeTopicBtn];
    [_takeTopicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-33);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(50);
    }];
    [self getCircledetailData];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCircledetailData) name:DynamdicCircleChangeModelNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendCircleFollowStatus:) name:DynamdicCircleFollowStatusNotification object:nil];
}
-(void)initNavView{
    
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  __kWidth, 64+__kTopAddHeight)];
//    self.navView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.navView];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_white") forState:BtnNormal];
//    nav_icon_back_black
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];
    
    _ShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ShareBtn setImage:CImage(@"dyn_issue_share_whiteBack") forState:BtnNormal];
//    dyn_issue_share
    [self.navView addSubview:_ShareBtn];
    [_ShareBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:CImage(@"icon_dyn_cirlce_more") forState:BtnNormal];
    _moreBtn.contentMode=UIViewContentModeScaleAspectFill;
    _moreBtn.clipsToBounds=YES;
    [self.navView addSubview:_moreBtn];
    [_moreBtn addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.hidden = YES;
    _cirlceSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cirlceSetBtn setImage:CImage(@"icon_dyn_cirlce_set") forState:BtnNormal];
    _cirlceSetBtn.contentMode=UIViewContentModeScaleAspectFill;
    _cirlceSetBtn.clipsToBounds=YES;
    [self.navView addSubview:_cirlceSetBtn];
    [_cirlceSetBtn addTarget:self action:@selector(circleSetAct) forControlEvents:UIControlEventTouchUpInside];
    _cirlceSetBtn.hidden = YES;
    
    _peopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_peopleBtn setImage:CImage(@"icon_dyn_cirlce_manager_people") forState:BtnNormal];
    //icon_dyn_cirlce_manager_people_black
    _peopleBtn.contentMode=UIViewContentModeScaleAspectFill;
    _peopleBtn.clipsToBounds=YES;
    [self.navView addSubview:_peopleBtn];
    [_peopleBtn addTarget:self action:@selector(peoplemanagerAct) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-17));
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(21);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    
    [_cirlceSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-14));
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(21);
        make.centerY.mas_equalTo(_moreBtn.mas_centerY);
    }];
    
    [_ShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_moreBtn.mas_left).offset(-20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(21);
        make.centerY.mas_equalTo(_moreBtn.mas_centerY);
    }];
    
    [_peopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_ShareBtn.mas_left).offset(-20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(21);
        make.centerY.mas_equalTo(_moreBtn.mas_centerY);
    }];
    
    
    _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reportBtn.backgroundColor = [UIColor whiteColor];
    _reportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [_reportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _reportBtn.layer.masksToBounds = YES;
    _reportBtn.layer.cornerRadius = 5;
    [_reportBtn addTarget:self action:@selector(tipOffAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reportBtn];
    [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(__ScaleWidth(-17));
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(96);
        make.height.mas_equalTo(40);
    }];
    _reportBtn.hidden = YES;
    

    
}

-(void)initHeaderView{
    _circleHeaderView = [[BXDynCircleHeaderView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 300 + __kTopAddHeight)];
    _circleHeaderView.backgroundColor = [UIColor cyanColor];

//    [self.view addSubview:_circleHeaderView];
}
-(void)initJXView{
    
//    _categoryView = [[JXCategoryTitleView alloc] init];
//    _categoryView.titles = _titles;
//    _categoryView.frame = CGRectMake(0, 10 + _circleHeaderView.frame.size.height + _circleHeaderView.frame.origin.y, __kWidth - 200, 44);
//    _categoryView.titleFont = CBFont(16);
//    _categoryView.titleColor = UIColorHex(#8C8C8C);
//    _categoryView.titleSelectedColor = UIColorHex(#282828);
//    _categoryView.titleColorGradientEnabled = YES;
//    _categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
//    _categoryView.selectedAnimationEnabled = YES;
//    self.categoryView.cellWidth = 40;
//    self.categoryView.contentEdgeInsetLeft = 24;
//    _categoryView.delegate = self;
//
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    JXGradientView *gradientView = [JXGradientView new];
//    gradientView.gradientLayer.endPoint = CGPointMake(1, 0);
//    gradientView.gradientLayer.colors = @[(__bridge id)UIColorHex(FF2D52).CGColor, (__bridge id)UIColorHex(FF2D52).CGColor];
//    gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    gradientView.layer.masksToBounds = YES;
//    gradientView.layer.cornerRadius = 2;
//    [lineView addSubview:gradientView];
//    lineView.indicatorWidth = 25;
//    lineView.indicatorHeight = 2;
//    lineView.indicatorCornerRadius = 2;
//    self.categoryView.indicators = @[lineView];
//
//    [self.view addSubview:_categoryView];
//
//    _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
//    _listContainerView.frame = CGRectMake(0, 10 + _circleHeaderView.frame.size.height + _circleHeaderView.frame.origin.y + 45, __kWidth, __kHeight - (10 + _circleHeaderView.frame.size.height + _circleHeaderView.frame.origin.y + 45));
//    [self.view addSubview:_listContainerView];
//    self.categoryView.listContainer = _listContainerView;
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, 40)];
     self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F9FC"];
     self.categoryView.titles = self.titles;
     self.categoryView.delegate = self;
     self.categoryView.backgroundColor = UIColorHex(FFFFFF);
     self.categoryView.titleSelectedColor = UIColorHex(282828);

     self.categoryView.titleColor = UIColorHex(8C8C8C);
     self.categoryView.titleFont = SLPFFont(16);

     self.categoryView.cellWidth = 40;
     self.categoryView.contentEdgeInsetLeft = 24;

     self.categoryView.titleColorGradientEnabled = YES;
//    [self.view addSubview:self.categoryView];
     
     JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
     JXGradientView *gradientView = [JXGradientView new];
     gradientView.gradientLayer.endPoint = CGPointMake(1, 0);//FF2D52
     gradientView.gradientLayer.colors = @[(__bridge id)UIColorHex(FF2D52).CGColor, (__bridge id)UIColorHex(FF2D52).CGColor];
     gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     gradientView.layer.masksToBounds = YES;
     gradientView.layer.cornerRadius = 1;
     [lineView addSubview:gradientView];
     lineView.indicatorWidth = 40;
     lineView.indicatorHeight = 2;
     lineView.indicatorCornerRadius = 1;
     self.categoryView.indicators = @[lineView];
     
     _pagerView = [self preferredPagingView];
     self.pagerView.mainTableView.gestureDelegate = self;
     [self.categoryView selectItemAtIndex:1];

     [self.view addSubview:self.pagerView];
//     WS(weakSelf);
//     [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.left.right.bottom.mas_equalTo(0);
//         make.top.equalTo(weakSelf.categoryView.mas_bottom);
//     }];
     self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    
    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
    [self.pagerView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.pagerView.frame = self.view.bounds;

    
}
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    _reportBtn.hidden = YES;
    if (offsetY > 236+40) {
        if (self.isMid == NO) {
            self.categoryView.frame = CGRectMake(__ScaleWidth(215/2.0), __kTopAddHeight + 20, __ScaleWidth(160), 40);
            self.navView.hidden = YES;
            self.isMid = YES;
            
            for (UIView *subV in self.slTemView.subviews) {
                if ([subV isKindOfClass:[UIButton class]]) {
                    subV.hidden = NO;
                    if (_moreBtn.hidden && subV.tag == 1) {
                        subV.hidden = YES;
                    }
                    if (_cirlceSetBtn.hidden && subV.tag == 2) {
                        subV.hidden = YES;
                    }
                }
            }
        
        }
        
    }else {
        if (self.isMid == YES) {
            self.categoryView.frame = CGRectMake(0, 0, __ScaleWidth(160), 40);
            self.navView.hidden = NO;
            self.isMid = NO;
            
            for (UIView *subV in self.slTemView.subviews) {
                if ([subV isKindOfClass:[UIButton class]]) {
                    subV.hidden = YES;
                }
            }
            

        }
    }
    [self.circleHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
}

- (JXPagerView *)preferredPagingView {
    JXPagerView *pagerView = [[JXPagerView alloc] initWithDelegate:self];
//    pagerView.pinSectionHeaderVerticalOffset = 64 + __kTopAddHeight;
    pagerView.pinSectionHeaderVerticalOffset = 0;
    pagerView.mainTableView.estimatedRowHeight = 0;
    pagerView.mainTableView.estimatedSectionHeaderHeight = 0;
    pagerView.mainTableView.estimatedSectionFooterHeight = 0;
    pagerView.listContainerView.initListPercent = NO;
//    pagerView.mainTableView.scrollEnabled = NO;
    pagerView.listContainerView.scrollView.bounces = NO;
//    pagerView.mainTableView.separatorInset = UIEdgeInsetsMake(0, __ScaleWidth(12), 0, __ScaleWidth(12));
    return pagerView;
}
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return (NSUInteger)(300 + __kTopAddHeight);
}

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.circleHeaderView;
}
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
//    if (self.isMid) {
    return __kTopAddHeight + 64;
//    }else{
//        return 40;
//    }
//    return 0.01;
}
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
//    return self.categoryView;
    UIView *temView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __kTopAddHeight + 64)];
    self.categoryView.frame = CGRectMake(0, 0, 160, 40);
    [temView addSubview:self.categoryView];
    temView.backgroundColor = [UIColor whiteColor];
    self.slTemView = temView;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [temView addSubview:backBtn];
    
    UIButton *ShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ShareBtn setImage:CImage(@"dyn_issue_share") forState:BtnNormal];
//    dyn_issue_share
    [temView addSubview:ShareBtn];
    [ShareBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:CImage(@"icon_dyn_cirlce_more_black") forState:BtnNormal];
    moreBtn.contentMode=UIViewContentModeScaleAspectFill;
    moreBtn.clipsToBounds=YES;
    moreBtn.tag = 1;
    [temView addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cirlceSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cirlceSetBtn setImage:CImage(@"icon_dyn_cirlce_set_black") forState:BtnNormal];
    cirlceSetBtn.contentMode=UIViewContentModeScaleAspectFill;
    cirlceSetBtn.clipsToBounds=YES;
    cirlceSetBtn.tag = 2;
    [temView addSubview:cirlceSetBtn];
    [cirlceSetBtn addTarget:self action:@selector(circleSetAct) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *peopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [peopleBtn setImage:CImage(@"icon_dyn_cirlce_manager_people_black") forState:BtnNormal];
    peopleBtn.contentMode=UIViewContentModeScaleAspectFill;
    peopleBtn.clipsToBounds=YES;
    [temView addSubview:peopleBtn];
    [peopleBtn addTarget:self action:@selector(peoplemanagerAct) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-17));
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(21);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    
    [cirlceSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-14));
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(21);
        make.centerY.mas_equalTo(moreBtn.mas_centerY);
    }];
    
    [ShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(moreBtn.mas_left).offset(-20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(21);
        make.centerY.mas_equalTo(moreBtn.mas_centerY);
    }];
    
    [peopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ShareBtn.mas_left).offset(-20);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(21);
        make.centerY.mas_equalTo(moreBtn.mas_centerY);
    }];
    if (_moreBtn.hidden) {
        moreBtn.hidden = YES;
        cirlceSetBtn.hidden = NO;
    }else{
        moreBtn.hidden = NO;
        cirlceSetBtn.hidden = YES;
    }
    
    
    for (UIView *subV in temView.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            subV.hidden = YES;
        }
    }
    
    return temView;
//    if (self.isMid == NO) {
//
//    }else{
//        UIView *temView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __kTopAddHeight + 64)];
//        self.categoryView.frame = CGRectMake(__ScaleWidth(120), __kTopAddHeight + 20, __kWidth - __ScaleWidth(240), 44);
//        [temView addSubview:self.categoryView];
//        temView.backgroundColor = [UIColor whiteColor];
//        return temView;
//    }
//    return  [[UIView alloc]init];
}
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
//    return 1;
    return self.titles.count;
}


- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        
        BXDynCircleHomeVC *wvc = [[BXDynCircleHomeVC alloc]init];
        wvc.model = self.model;
        _circleVC = wvc;
        return wvc;
    }else{
        BXDynCircleVideoVC *pvc = [[BXDynCircleVideoVC alloc]init];
        pvc.model = self.model;
         pvc.nav = self.navigationController;
        return pvc;
    }
    
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //    if (self.noVideoPromptView) {
    //        if (index) {
    //            self.noVideoPromptView.isHaveVideo = YES;
    //        } else {
    //            self.noVideoPromptView.isHaveVideo = [[BXLiveUser currentBXLiveUser].video_num integerValue];
    //        }
    //    }
}
#pragma mark - JXPagerMainTableViewGestureDelegate
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return NO;
    }
    
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }

//    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    return YES;
}


- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

//- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
//  
//
//}
//
//- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
//    [self.listContainerView didClickSelectedItemAtIndex:index];
//    
//
//    
//}
//
//- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
//
//    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
//}
//
//#pragma mark - JXCategoryListContainerViewDelegate
//- (UIScrollView *)scrollViewInlistContainerView:(JXCategoryListContainerView *)listContainerView {
//    UIScrollView *scrollView = [[BXPagerMainScrollView alloc]init];
//    return scrollView;
//}
//
//-(id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
//    if (index == 0) {
//        BXDynCircleHomeVC *wvc = [[BXDynCircleHomeVC alloc]init];
//        wvc.model = self.model;
//        _circleVC = wvc;
//        return wvc;
//    }else{
//        BXDynCircleVideoVC *pvc = [[BXDynCircleVideoVC alloc]init];
//        pvc.model = self.model;
//        pvc.nav = self.navigationController;
//        return pvc;
//    }
//}


-(void)circleSetAct{
    WS(weakSelf);
//    BXDynFindCirlceVC *vc = [[BXDynFindCirlceVC alloc]init];
    BXDynCircleManagerVC *vc = [[BXDynCircleManagerVC alloc]init];
    vc.model = self.model;
    vc.ChangeModel = ^(BXDynCircleModel * _Nonnull model) {
        weakSelf.circleHeaderView.model = model;
    };
    vc.DissolveCircle = ^{
        BXDynDidDisbandAlert *alert = [[BXDynDidDisbandAlert alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
        alert.model = weakSelf.model;
        alert.DidClickBlock = ^{
            [weakSelf pop];
        };
        [alert showWithView:weakSelf.view];
    };
    [self pushVc:vc];
}
-(void)peoplemanagerAct{
    BXDynCirlcePeopleManagerVC *vc = [[BXDynCirlcePeopleManagerVC alloc]init];
    vc.model = self.model;
    [self pushVc:vc];
}
-(void)takeTopicAtc{
    if (![[NSString stringWithFormat:@"%@", self.model.myfollow] isEqualToString:@"1"]) {
        [BGProgressHUD showInfoWithMessage:@"还未关注该圈子哦"];
        return;
    }
    WS(weakSelf);
    BXOPenIssueDyn *showVC = [[BXOPenIssueDyn alloc] init];
    showVC.IssueSuccess = ^{
        [weakSelf.circleVC TableDragWithDown];
    };
    showVC.circleModel = self.model;
    BaseNavVC *nav = [[BaseNavVC alloc]initWithRootViewController:showVC];
    nav.modalPresentationStyle =  UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)AddClick{
    if ([BXLiveUser isLogin]) {
//        [DynSharePopViewManager shareWithVideoId:self.model.circle_id user_Id:@"" likeNum:@"" is_zan:@"" is_collect:@"" is_follow:@"" vc:self type:1 share_type:@"dynamic"];
    }else{
//        [BXCodeLoginVC toLoginViewControllerWithNav:self.navigationController];
    }
}
-(void)reportClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        _reportBtn.hidden = NO;
    }
    else{
        _reportBtn.hidden = YES;
    }
    
}
-(void)tipOffAct{
    BXDynTipOffVC *vc = [[BXDynTipOffVC alloc]init];
    BXDynamicModel *model = [BXDynamicModel new];
    model.msgdetailmodel.nickname = self.model.nickname;
    model.msgdetailmodel.content = self.model.circle_describe;
    vc.reporttype = @"3";
    vc.reportmsg_id = self.model.circle_id;
    vc.model = model;
    [self pushVc:vc];
}
-(void)backClick{
    [self pop];
}
-(void)dealloc{
    
}
-(void)sendCircleFollowStatus:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *status = info[@"extend_circlfollowed"];
    self.model.myfollow = status;

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

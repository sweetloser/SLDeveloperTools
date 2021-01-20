//
//  BXDynCircleCategoryVC.m
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleCategoryVC.h"
#import "JXCategoryView.h"
#import "JXCategoryTitleView.h"
#import "JXGradientView.h"
#import "BXDynCircleHeaderView.h"
#import "BXDynGlobleVC.h"
#import "BXDynTopicHomeVC.h"
#import "BXDynTopicVideoVC.h"
//#import "DynSharePopViewManager.h"
#import "BXLiveUser.h"
#import "BXOPenIssueDyn.h"
#import "BaseNavVC.h"
#import "BXDynTipOffVC.h"
#import "BXDynCircleModel.h"
#import "AttentionAlertView.h"
#import "BXDynFindCirlceVC.h"
#import "BXDynCirlcePeopleManagerVC.h"
#import "BXDynCircleManagerVC.h"
#import "BXDynDidDisbandAlert.h"
#import "HttpMakeFriendRequest.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoMacro.h"

@interface BXDynCircleCategoryVC ()<JXCategoryViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) BXDynCircleHeaderView *circleHeaderView;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic , strong) UIView * navView;

@property(nonatomic, strong)UIButton *takeTopicBtn;

@property(nonatomic, strong)UIButton *reportBtn;

@property(nonatomic, strong)UIButton *moreBtn;

@property(nonatomic, strong)UIButton *peopleBtn;

@property(nonatomic, strong)UIButton *cirlceSetBtn;

@end

@implementation BXDynCircleCategoryVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = [[NSMutableArray alloc]initWithObjects:@"最新动态", @"视频", nil];
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
    BXDynDidDisbandAlert *alert = [[BXDynDidDisbandAlert alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    alert.model = [BXDynCircleModel new];
    alert.DidClickBlock = ^{
        
    };
    [alert showWithView:self.view];
}
-(void)initNavView{
    
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
//    self.navView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.navView];
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"icon_return_white") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];
    
    UIButton *ShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_issueBtn setImage:CImage(@"nav_icon_news_black") forState:BtnNormal];
    [ShareBtn setImage:CImage(@"dyn_issue_share_whiteBack") forState:BtnNormal];
    [self.navView addSubview:ShareBtn];
    [ShareBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:CImage(@"icon_dyn_cirlce_more") forState:BtnNormal];
    _moreBtn.contentMode=UIViewContentModeScaleAspectFill;
    _moreBtn.clipsToBounds=YES;
    [self.navView addSubview:_moreBtn];
    [_moreBtn addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _cirlceSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cirlceSetBtn setImage:CImage(@"icon_dyn_cirlce_set") forState:BtnNormal];
    _cirlceSetBtn.contentMode=UIViewContentModeScaleAspectFill;
    _cirlceSetBtn.clipsToBounds=YES;
    [self.navView addSubview:_cirlceSetBtn];
    [_cirlceSetBtn addTarget:self action:@selector(circleSetAct) forControlEvents:UIControlEventTouchUpInside];
    
    _peopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_peopleBtn setImage:CImage(@"icon_dyn_cirlce_manager_people") forState:BtnNormal];
    _peopleBtn.contentMode=UIViewContentModeScaleAspectFill;
    _peopleBtn.clipsToBounds=YES;
    [self.navView addSubview:_peopleBtn];
    [_peopleBtn addTarget:self action:@selector(peoplemanagerAct) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(12));
        make.width.height.mas_equalTo(16);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-17));
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(10);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    
    [_cirlceSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-17));
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(17);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    
    [ShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_moreBtn.mas_left).offset(-17);
        make.width.height.mas_equalTo(16);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    
    [_peopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ShareBtn.mas_left).offset(-17);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
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
    
    if (_isOwn) {
        _moreBtn.hidden = YES;
        _cirlceSetBtn.hidden = NO;
        _peopleBtn.hidden = NO;
    }else{
        _moreBtn.hidden = NO;
        _cirlceSetBtn.hidden = YES;
        _peopleBtn.hidden = YES;
    }
    
}
-(void)initHeaderView{
    _circleHeaderView = [[BXDynCircleHeaderView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 336)];
    _circleHeaderView.backgroundColor = [UIColor cyanColor];
    _circleHeaderView.model = [BXDynCircleModel new];
    WS(weakSelf);
    _circleHeaderView.DidClickCircle  = ^(NSInteger type) {
        if (type == 0) {
            AttentionAlertView *alert = [[AttentionAlertView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
            alert.DidClickBlock = ^{
                
            };
            [alert showWithView:weakSelf.view];
        }
    };
}
-(void)initJXView{
    

    //    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, HeightForHeaderInSection)];
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
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
//    CGFloat offsetY = scrollView.contentOffset.y;
//
//    _.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:_alpha];
    [self.circleHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
}

- (JXPagerView *)preferredPagingView {
    JXPagerView *pagerView = [[JXPagerView alloc] initWithDelegate:self];
    pagerView.pinSectionHeaderVerticalOffset = 64 + __kTopAddHeight;
    pagerView.mainTableView.estimatedRowHeight = 0;
    pagerView.mainTableView.estimatedSectionHeaderHeight = 0;
    pagerView.mainTableView.estimatedSectionFooterHeight = 0;
    pagerView.listContainerView.initListPercent = NO;
//    pagerView.mainTableView.separatorInset = UIEdgeInsetsMake(0, __ScaleWidth(12), 0, __ScaleWidth(12));
    return pagerView;
}
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
//    return (NSUInteger)(self.coverHeight + self.contentHeight);
    return (NSUInteger)(336 + __kTopAddHeight);
}

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
//    return self.headerView;
    return self.circleHeaderView;
}
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 44;
//    return 0.01;
}


- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
//    return self.categoryView;
    UIView *temView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.categoryView.frame = CGRectMake(0, 0, 160, 44);
    [temView addSubview:self.categoryView];
    temView.backgroundColor = [UIColor whiteColor];
    return temView;
//    return  [[UIView alloc]init];
}
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
//    return 1;
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        
        BXDynTopicHomeVC *wvc = [[BXDynTopicHomeVC alloc]init];
        return wvc;
    }else{
        BXDynTopicVideoVC *pvc = [[BXDynTopicVideoVC alloc]init];
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


-(void)circleSetAct{
//    BXDynFindCirlceVC *vc = [[BXDynFindCirlceVC alloc]init];
    BXDynCircleManagerVC *vc = [[BXDynCircleManagerVC alloc]init];
    [self pushVc:vc];
}
-(void)peoplemanagerAct{
    BXDynCirlcePeopleManagerVC *vc = [[BXDynCirlcePeopleManagerVC alloc]init];
    [self pushVc:vc];
}
-(void)takeTopicAtc{
    BXOPenIssueDyn *showVC = [[BXOPenIssueDyn alloc] init];
    BaseNavVC *nav = [[BaseNavVC alloc]initWithRootViewController:showVC];
    nav.modalPresentationStyle =  UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)AddClick{
    if ([BXLiveUser isLogin]) {
//        [DynSharePopViewManager shareWithVideoId:@"" user_Id:@"" likeNum:@"" is_zan:@"" is_collect:@"" is_follow:@"" vc:self type:1 share_type:@"dynamic"];
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
    vc.reporttype = @"3";
//    vc.reportmsg_id = self.mo;
    [self pushVc:vc];
}
-(void)backClick{
    [self pop];
}
@end

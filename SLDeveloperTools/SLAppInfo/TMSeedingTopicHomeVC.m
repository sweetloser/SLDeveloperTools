//
//  TMSeedingTopicHomeVC.m
//  BXlive
//
//  Created by mac on 2020/11/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "TMSeedingTopicHomeVC.h"
#import "JXCategoryTitleView.h"
#import "JXGradientView.h"
#import "BXDynTopicHeaderView.h"
#import "BXDynGlobleVC.h"

#import "TMSeedingTopicListVC.h"
#import "TMSeedingTopicVideoVC.h"
#import "SLAppInfoMacro.h"
#import <Masonry/Masonry.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <YYCategories/YYCategories.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMaskTools/SLMaskTools.h"
//#import "DynSharePopViewManager.h"
#import "NewHttpManager.h"
#import "BXLiveUser.h"
#import "BXOPenIssueDyn.h"
#import "BaseNavVC.h"
#import "BXPagerMainScrollView.h"
#import "HttpMakeFriendRequest.h"
@interface TMSeedingTopicHomeVC ()<JXCategoryViewDelegate>

@property (nonatomic, strong) BXDynTopicHeaderView *topicHeaderView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

//@property (nonatomic, strong) TMSeedingTopicListVC *topicVC;

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic , strong) UIView * navView;

@property(nonatomic, strong)UIButton *takeTopicBtn;

@property (nonatomic, assign) BOOL isLogin;

@property(nonatomic,assign)BOOL isMid;

@property(nonatomic, strong)UIView *slTemView;

@end

@implementation TMSeedingTopicHomeVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = [[NSMutableArray alloc]initWithObjects:@"综合", @"视频", nil];
     _isLogin = [BXLiveUser isLogin];
    [self initHeaderView];
    [self initJXView];
    [self initNavView];
    [self getData];
//    _takeTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_takeTopicBtn setImage:CImage(@"icon_dyn_topic_takein") forState:UIControlStateNormal];
//    [_takeTopicBtn addTarget:self action:@selector(takeTopicAtc) forControlEvents:UIControlEventTouchUpInside];
//    _takeTopicBtn.layer.masksToBounds = YES;
//    _takeTopicBtn.layer.cornerRadius = 25;
//    [self.view addSubview:_takeTopicBtn];
//    [_takeTopicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-33);
//        make.width.mas_equalTo(160);
//        make.height.mas_equalTo(50);
//    }];
}
-(void)initNavView{
    
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];

    [self.view addSubview:self.navView];
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_white") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];
    
    UIButton *_issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_issueBtn setImage:CImage(@"nav_icon_news_black") forState:BtnNormal];
    [_issueBtn setImage:CImage(@"dyn_issue_share_whiteBack") forState:BtnNormal];
    [self.navView addSubview:_issueBtn];
    [_issueBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [_issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-12));
        make.width.height.mas_equalTo(18.5);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    
    
    
}
-(void)initHeaderView{
    WS(weakSelf);
    _topicHeaderView = [[BXDynTopicHeaderView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 230 + __kTopAddHeight)];

    _topicHeaderView.DidClickTopic = ^(BXDynTopicModel * _Nonnull model) {
        if (weakSelf.DidClickTopic) {
            weakSelf.DidClickTopic(model);
        }
    };
    _topicHeaderView.AttentClickTopic = ^{
        [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/topic/followTopic" parameters:@{@"topic_id":weakSelf.topic_id} success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    weakSelf.topicHeaderView.attImageView.image =  [UIImage imageNamed:@"icon_dyn_cirlce_attented"];
                }else{
                    weakSelf.topicHeaderView.attImageView.image =  [UIImage imageNamed:@"icon_dyn_cirlce_attent"];
                }
            }
            [BGProgressHUD showInfoWithMessage:responseObject[@"message"]];
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    };

}
-(void)getData{
    WS(weakSelf);
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/topic/getTopdetail" parameters:@{@"topic_id":_topic_id} success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            BXDynTopicModel *model = [BXDynTopicModel new];
            [model updateWithJsonDic:responseObject[@"data"]];
            weakSelf.topicHeaderView.model = model;
        }else{
            [BGProgressHUD showInfoWithMessage:responseObject[@"message"]];
        }

    } failure:^(NSError * _Nonnull error) {
        
    }];
}
-(void)initJXView{

    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
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
//
//    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
    [self.pagerView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pagerView.frame = self.view.bounds;

}
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 166+40) {
        if (self.isMid == NO) {
            self.categoryView.frame = CGRectMake(__ScaleWidth(215/2.0),  20, __ScaleWidth(160), 40);
            self.navView.hidden = YES;
            self.isMid = YES;
            
            for (UIView *subV in self.slTemView.subviews) {
                if ([subV isKindOfClass:[UIButton class]]) {
                    subV.hidden = NO;
                    
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
    [self.topicHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
}

- (JXPagerView *)preferredPagingView {
    JXPagerView *pagerView = [[JXPagerView alloc] initWithDelegate:self];
    pagerView.pinSectionHeaderVerticalOffset = 0;
    pagerView.mainTableView.estimatedRowHeight = 0;
    pagerView.mainTableView.estimatedSectionHeaderHeight = 0;
    pagerView.mainTableView.estimatedSectionFooterHeight = 0;
    pagerView.listContainerView.initListPercent = NO;

    return pagerView;
}
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {

    return (NSUInteger)(230 + __kTopAddHeight);
}

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {

    return self.topicHeaderView;
}
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return __kTopAddHeight + 64;
//    return 0.01;
}


- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    UIView *temView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __kTopAddHeight + 64)];
    self.categoryView.frame = CGRectMake(0, 0, 160, 40);
    [temView addSubview:self.categoryView];
    temView.backgroundColor = [UIColor whiteColor];
    self.slTemView = temView;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:CImage(@"back_black") forState:BtnNormal];
//    nav_icon_back_black
    backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [temView addSubview:backBtn];
    
    UIButton *ShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ShareBtn setImage:CImage(@"dyn_issue_share") forState:BtnNormal];
//    dyn_issue_share
    [temView addSubview:ShareBtn];
    [ShareBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [ShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(__ScaleWidth(-12));
        make.width.height.mas_equalTo(18.5);
        make.top.mas_equalTo(20 + 12);
    }];


    for (UIView *subV in temView.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            subV.hidden = YES;
        }
    }
    
    return temView;

}
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
//    return 1;
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {

        TMSeedingTopicListVC *wvc = [[TMSeedingTopicListVC alloc]init];
//        self.topicVC = wvc;
        wvc.topic_id = _topic_id;
        return wvc;
    }else{
        TMSeedingTopicVideoVC *pvc = [[TMSeedingTopicVideoVC alloc]init];
        pvc.nav = self.navigationController;
        pvc.topic_id = _topic_id;
        return pvc;
    }

}




#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {

}



#pragma mark - JXPagerMainTableViewGestureDelegate
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    if([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return NO;
    }

    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }

    return YES;
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


-(void)takeTopicAtc{
//    WS(weakSelf);
//    NSLog(@"%@", self.listContainerView);
//    BXOPenIssueDyn *showVC = [[BXOPenIssueDyn alloc] init];
//    showVC.IssueSuccess = ^{
//        [weakSelf.topicVC TableDragWithDown];
//    };
//    showVC.topicModel = self.model;
//    BaseNavVC *nav = [[BaseNavVC alloc]initWithRootViewController:showVC];
//    nav.modalPresentationStyle =  UIModalPresentationFullScreen;
//    [self presentViewController:nav animated:YES completion:nil];
}

-(void)AddClick{
    if ([BXLiveUser isLogin]) {
//        [DynSharePopViewManager shareWithVideoId:self.topic_id user_Id:@"" likeNum:@"" is_zan:@"" is_collect:@"" is_follow:@"" vc:self type:1 share_type:@"PlantingGrass"];
    }else{
//        [BXCodeLoginVC toLoginViewControllerWithNav:self.navigationController];
    }
}
-(void)backClick{
    [self pop];
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

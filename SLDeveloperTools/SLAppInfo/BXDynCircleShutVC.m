//
//  BXDynCircleShutVC.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCircleShutVC.h"
#import "BXDynCircleShutCell.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynMemberModel.h"
#import "NSObject+Tag.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <ZFPlayer/ZFPlayer.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLMacro/SLMacro.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLCategory/SLCategory.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"
#import "SLAppInfoMacro.h"
#import "NewHttpManager.h"


@interface BXDynCircleShutVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *MemberArray;
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;

@property (nonatomic, assign) NSInteger page;

@end

@implementation BXDynCircleShutVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}
-(void)viewDidAppear:(BOOL)animated {
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
#pragma mark - 下拉刷新
- (void)TableDragWithDown {
    self.page = 0;
    [self getData];

}
#pragma mark - 加载更多
- (void)loadMoreData
{
    self.page = self.MemberArray.ds_Tag;
    [self getData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
    if (point.y > 0 ) {
        return;
    }
    if (scrollView.contentOffset.y <= 0) {
        return;
    }
    if (scrollView.contentOffset.y + scrollView.frame.size.height + kFooterRefreshSpace > scrollView.contentSize.height) {
        if (scrollView.isNoMoreData || scrollView.isNoNetwork) {
            return;
        }
        if (!scrollView.isRefresh) {
            scrollView.isRefresh = YES;
            [self loadMoreData];
        }
    }
}
-(void)getData{
    
    WS(weakSelf);
    [HttpMakeFriendRequest GetEstoppelMemberWithpage_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"10" circle_id:self.model.circle_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        if (flag) {
            if (!self.page) {
                   [self.MemberArray removeAllObjects];
                   self.MemberArray.ds_Tag = 0;
                   self.tableView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                   self.tableView.isNoMoreData = NO;
               }
            NSArray *dataArray1 = jsonDic[@"data"][@"data"];
            if (dataArray1 && dataArray1.count) {
                for (NSDictionary *dic in dataArray1) {
                    BXDynMemberModel *model = [[BXDynMemberModel alloc]init];
                    [model updateWithJsonDic:dic];
                    [weakSelf.MemberArray addObject:model];
                }
                self.MemberArray.ds_Tag++;
            }
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        [self.tableView headerEndRefreshing];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
        [self.tableView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
        [self.tableView headerEndRefreshing];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _MemberArray = [[NSMutableArray alloc]init];

    [self setNavView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView addHeaderWithTarget:self action:@selector(TableDragWithDown)];
    [self.tableView endRefreshingWithNoMoreData];
    [self.tableView headerBeginRefreshing];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-__kBottomAddHeight);
        
    }];
    [BGProgressHUD showLoadingAnimation];
    [self getData];

}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"成员管理";
    _viewTitlelabel.textColor = UIColorHex(#282828);
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];

    
    [_viewTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navView);
        make.width.mas_equalTo(__ScaleWidth(72/4*6));
        make.height.mas_equalTo(25);
        make.centerY.equalTo(_navView.mas_bottom).offset(-22);
    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];


}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.MemberArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *piccell = @"cell1";
    BXDynCircleShutCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
    if (cell == nil){
        cell = [[BXDynCircleShutCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
    }
  
    cell.model = self.MemberArray[indexPath.row];
    cell.DidShutClick  = ^{
        [self shutAct:self.MemberArray[indexPath.row]];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.bounds.size.width tableView:_tableView];

}

#pragma mark - TableViewDidClickViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
-(void)backClick{
    [self pop];
}
-(void)shutAct:(BXDynMemberModel *)model{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest ActEstoppelWithcircle_id:model.circle_id uid:model.user_id status:@"0" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        if (flag) {
            for (int i = 0; i < self.MemberArray.count; i++) {
                if (model == self.MemberArray[i]) {
                    [self.MemberArray removeObjectAtIndex:i];
                    [self.tableView reloadData];
                    return;
                }
            }
        }
        
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}

#pragma - mark DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if ([NewHttpManager isNetWorkConnectionAvailable]) {
        return nil;
    } else {
        WS(ws);
        BXNoNetworkView *noNetworkView = [[BXNoNetworkView alloc]initWithHeight:290];
        noNetworkView.needRefresh = ^{
            [ws TableDragWithDown];
        };
        return noNetworkView;
    }
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页面状态"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"这里还没有内容哦~";
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [attributes setObject:MinorColor forKey:NSForegroundColorAttributeName];
    [attributes setValue:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributeString;
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

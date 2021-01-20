//
//  BXDynTopicSquareVC.m
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTopicSquareVC.h"
#import "BXDynTopicSquareCell.h"
#import "BXDynSearchTopicVC.h"
#import "BXDynTopicModel.h"
#import "HttpMakeFriendRequest.h"
#import "NSObject+Tag.h"
#import "BXDynSynTopicCategoryVC.h"
#import <ZFPlayer/ZFPlayer.h>
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "SLAppInfoMacro.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>


@interface BXDynTopicSquareVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *issueBtn;

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@end

@implementation BXDynTopicSquareVC

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
#pragma mark - 下拉刷新
- (void)TableDragWithDown {
    self.page = 0;
    [self getData];

}
#pragma mark - 加载更多
- (void)loadMoreData
{
    self.page = self.dataArray.ds_Tag;
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
    [HttpMakeFriendRequest GetTopicListWithpage_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"50" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        if (flag) {
            if (!self.page) {
                [self.dataArray removeAllObjects];
                self.dataArray.ds_Tag = 0;
                self.tableview.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                self.tableview.isNoMoreData = NO;
            }
            NSArray *dataArray1 = jsonDic[@"data"][@"data"];
            if (dataArray1 && [dataArray1 isArray]) {
                for (NSDictionary *dic in dataArray1) {
                    BXDynTopicModel *model = [[BXDynTopicModel alloc]init];
                    [model updateWithJsonDic:dic];
                    [self.dataArray addObject:model];
                }
                self.dataArray.ds_Tag++;
            }
            else {
                weakSelf.tableview.isNoMoreData = YES;
            }
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        [self.tableview headerEndRefreshing];
        self.tableview.isRefresh = NO;
        self.tableview.isNoNetwork = NO;
        [self.tableview reloadData];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
//        [BGProgressHUD showInfoWithMessage:@"获取列表失败"];
        [self.tableview headerEndRefreshing];
        self.tableview.isRefresh = NO;
        self.tableview.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavView];
    self.dataArray = [[NSMutableArray alloc]init];
    _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = [[UIView alloc]init];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview addHeaderWithTarget:self action:@selector(TableDragWithDown)];
     [self.tableview endRefreshingWithNoMoreData];
    [self.view addSubview:self.tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset( - __kBottomAddHeight);
    }];
    [BGProgressHUD showLoadingAnimation];
    [self getData];
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"话题广场";
    _viewTitlelabel.textColor = UIColorHex(#282828);
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];

    _issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_issueBtn setImage:CImage(@"icon_search_2_black") forState:BtnNormal];
    _issueBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.navView addSubview:_issueBtn];
    [_issueBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];

}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableview];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BXDynTopicSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil){
        cell = [[BXDynTopicSquareCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.huatiLabel.text = [self.dataArray[indexPath.row] topic_name];
    cell.huatiNumLabel.text = [NSString stringWithFormat:@"%@条动态",[self.dataArray[indexPath.row] dynamic]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    BXDynSynTopicCategoryVC *vc = [[BXDynSynTopicCategoryVC alloc]init];
    vc.model = self.dataArray[indexPath.row];
    vc.DidClickTopic = ^(BXDynTopicModel * _Nonnull model) {
        weakSelf.dataArray[indexPath.row] = model;
        [weakSelf.tableview reloadData];
    };
    [self pushVc:vc];
}
-(void)AddClick{
    BXDynSearchTopicVC *vc = [[BXDynSearchTopicVC alloc]init];
    [self pushVc:vc];
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

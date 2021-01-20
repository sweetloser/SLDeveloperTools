//
//  BXDynCirlcePeopleManagerVC.m
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCirlcePeopleManagerVC.h"
#import "BXDynPeopleManagerCell.h"
#import "BXDynPeopleCommonCell.h"
#import "BXDynCircleShutVC.h"
#import "BXDynCircelOperAlert.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynMemberModel.h"
#import "NSObject+Tag.h"
#import "BXDynTipOffPeopleVC.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLMacro/SLMacro.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"
#import "../SLCategory/SLCategory.h"
#import "NewHttpManager.h"
#import "SLAppInfoMacro.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <ZFPlayer/ZFPlayer.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
@interface BXDynCirlcePeopleManagerVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate, PeopleManagerDelegate, CommonManagerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *MangerDic;
@property (nonatomic,strong)NSMutableArray *MangerArray;
@property (nonatomic,strong)NSMutableArray *MemberArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;
@property(nonatomic, strong)BXDynCircelOperAlert *OperationAlert;
@end

@implementation BXDynCirlcePeopleManagerVC
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
    [self getManagerData];

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
    [HttpMakeFriendRequest GetCommonMemberWithpage_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"10" circle_id:self.model.circle_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
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
-(void)getManagerData{
    WS(weakSelf);
    [HttpMakeFriendRequest CircleMemeberManagerWithcircle_id:self.model.circle_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
                [BGProgressHUD hidden];
        if (flag) {
            [weakSelf.MangerArray removeAllObjects];
            NSArray *array = jsonDic[@"data"];
            for (NSDictionary *dic in array) {
                
                BXDynMemberModel *model = [[BXDynMemberModel alloc]init];
                [model updateWithJsonDic:dic];
                [weakSelf.MangerArray addObject:model];
            }
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        [self.tableView reloadData];

    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _MangerArray = [[NSMutableArray alloc]init];
    _MemberArray = [[NSMutableArray alloc]init];
    _MangerDic = [[NSMutableDictionary alloc]init];
    
    // Do any additional setup after loading the view.
    [self setNavView];
    
    [self shutView];

    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(TableDragWithDown)];
     [self.tableView endRefreshingWithNoMoreData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(82);
        make.bottom.mas_equalTo(-__kBottomAddHeight);
        
    }];
    [BGProgressHUD showLoadingAnimation];
    [self getManagerData];
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
-(void)shutView{
    UIView *shutupView = [[UIView alloc]init];
    UITapGestureRecognizer *shuttap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        BXDynCircleShutVC *vc = [[BXDynCircleShutVC alloc]init];
        vc.model = self.model;
        [self pushVc:vc];
    }];
    [shutupView addGestureRecognizer:shuttap];
    shutupView.userInteractionEnabled = YES;
    shutupView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shutupView];
    [shutupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(62);
    }];
    
    UIImageView *shutImageView = [[UIImageView alloc]init];
    shutImageView.image = CImage(@"icon_dyn_cirlce_shutup");
    [shutupView addSubview:shutImageView];
    [shutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shutupView.mas_left).offset(12);
        make.centerY.mas_equalTo(shutupView.centerY);
        make.width.height.mas_equalTo(42);
    }];
    
    UILabel *shutlabel = [[UILabel alloc]init];
    shutlabel.text = @"禁言中";
    shutlabel.textColor = [UIColor blackColor];
    shutlabel.font = [UIFont systemFontOfSize:16];
    [shutupView addSubview:shutlabel];
    [shutlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shutImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(shutImageView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *downlabel = [[UILabel alloc]init];
    downlabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.96 alpha:1.00];
    [self.view addSubview:downlabel];
    [downlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(shutupView.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    
}
-(void)backClick{
    [self pop];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.MangerArray.count;
    }
    if (section == 1) {
        return self.MemberArray.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
            static NSString *piccell = @"cell1";
            BXDynPeopleManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
            if (cell == nil){
                cell = [[BXDynPeopleManagerCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
            }
            cell.model = self.MangerArray[indexPath.row];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

    }
    else{
        static NSString *piccell = @"cell3";
        BXDynPeopleCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
        if (cell == nil){
            cell = [[BXDynPeopleCommonCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
        }
        
        cell.model = self.MemberArray[indexPath.row];
        cell.delegate =self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.bounds.size.width tableView:_tableView];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerview = [[UIView alloc]init];
        headerview.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 200, 40)];
        label.text = @"创始人、管理员";
        label.textAlignment = 0;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        [headerview addSubview:label];
        return headerview;
    }
    else{
        UIView *headerview = [[UIView alloc]init];
        headerview.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 200, 40)];
        label.text = @"成员";
        label.textAlignment = 0;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        [headerview addSubview:label];
        return headerview;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 10)];
        label.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.96 alpha:1.00];
        return label;
    }
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;;
}
#pragma mark - TableViewDidClickViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma - mark DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if ([NewHttpManager isNetWorkConnectionAvailable]) {
        return nil;
    } else {
        
        BXNoNetworkView *noNetworkView = [[BXNoNetworkView alloc]initWithHeight:290];
        noNetworkView.needRefresh = ^{
        };
        return noNetworkView;
    }
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


#pragma - mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)DidClickMore:(BXDynMemberModel *)model{
    NSString *mypower = [NSString stringWithFormat:@"%@", self.model.mycirclepower];
    NSString *otherpower = [NSString stringWithFormat:@"%@", model.power];
    WS(weakSelf);
    if ([mypower isEqualToString:@"0"]) {
        self.OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"举报", @"取消"]];
        self.OperationAlert.DidOpeClick = ^(NSInteger tag) {
            if (tag == 0) {
                [weakSelf ReportAct:model];
            }
//            if (tag == 1) {
//                [weakSelf BlacklistAct:model];
//            }
        };
        [self.OperationAlert showWithView:self.view];
    }
    
    if ([mypower isEqualToString:@"1"]) {
        
        if ([otherpower isEqualToString:@"0"]) {
            self.OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"设置为管理员", @"禁言", @"驱逐",@"举报",@"取消"]];
            self.OperationAlert.DidOpeClick = ^(NSInteger tag) {
                if (tag == 0) {
                    [weakSelf SetManagerAct:model];
                }
                if (tag == 1) {
                    [weakSelf ShutAct:model];
                }
                if (tag == 2) {
                    [weakSelf ExpelAct:model];
                }
                if (tag == 3) {
                    [weakSelf ReportAct:model];
                }
//                if (tag == 4) {
//                    [weakSelf BlacklistAct:model];
//                }
            };
            [self.OperationAlert showWithView:self.view];
        }
        
        if ([otherpower isEqualToString:@"2"]) {
            self.OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"设置为普通成员", @"禁言", @"驱逐",@"举报", @"取消"]];
            self.OperationAlert.DidOpeClick = ^(NSInteger tag) {
                if (tag == 0) {
                    [weakSelf SetCommonAct:model];
                }
                if (tag == 1) {
                    [weakSelf ShutAct:model];
                }
                if (tag == 2) {
                    [weakSelf ExpelAct:model];
                }
                if (tag == 3) {
                    [weakSelf ReportAct:model];
                }
//                if (tag == 4) {
//                    [weakSelf BlacklistAct:model];
//                }
            };
            [self.OperationAlert showWithView:self.view];
        }

    }
    
    if ([mypower isEqualToString:@"2"]) {
        
        if ([otherpower isEqualToString:@"0"]) {
            self.OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"禁言", @"驱逐",@"举报", @"取消"]];
            self.OperationAlert.DidOpeClick = ^(NSInteger tag) {
                if (tag == 0) {
                    [weakSelf ShutAct:model];
                }
                if (tag == 1) {
                    [weakSelf ExpelAct:model];
                }
                if (tag == 2) {
                    [weakSelf ReportAct:model];
                }
//                if (tag == 3) {
//                    [weakSelf BlacklistAct:model];
//                }
            };
            [self.OperationAlert showWithView:self.view];
        }
        
        if ([otherpower isEqualToString:@"1"] || [otherpower isEqualToString:@"2"]) {
            self.OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"举报", @"取消"]];
            self.OperationAlert.DidOpeClick = ^(NSInteger tag) {
                if (tag == 0) {
                    [weakSelf ReportAct:model];
                }
//                if (tag == 1) {
//                    [weakSelf BlacklistAct:model];
//                }
            };
            [self.OperationAlert showWithView:self.view];
        }

    }
}

#pragma 拉黑
-(void)BlacklistAct:(BXDynMemberModel *)model{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest setFilterWithfilter_id:model.user_id msgType:@"3" filter_type:@"1" filter_msg_id:@"" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}
#pragma 举报
-(void)ReportAct:(BXDynMemberModel *)model{
    BXDynTipOffPeopleVC *vc = [[BXDynTipOffPeopleVC alloc]init];
    vc.username = model.nickname;
    vc.reporttype = @"9";
    vc.user_id = model.user_id;
    [self pushVc:vc];
}

#pragma 禁言
-(void)ShutAct:(BXDynMemberModel *)model{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest ActEstoppelWithcircle_id:model.circle_id uid:model.user_id status:@"1" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        if (flag) {
            for (int i = 0; i < self.MangerArray.count; i++) {
                if (model == self.MangerArray[i]) {
                    [self.MangerArray removeObjectAtIndex:i];
                    [self.tableView reloadData];
                    return;
                }
            }
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

#pragma 驱逐
-(void)ExpelAct:(BXDynMemberModel *)model{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest ActSetExpelWithcircle_id:model.circle_id uid:model.user_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        if (flag) {
            for (int i = 0; i < self.MangerArray.count; i++) {
                if (model == self.MangerArray[i]) {
                    [self.MangerArray removeObjectAtIndex:i];
                    [self.tableView reloadData];
                    return;
                }
            }
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

#pragma 设置为管理员
-(void)SetManagerAct:(BXDynMemberModel *)model{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest ActSetAdminWithcircle_id:model.circle_id uid:model.user_id power:@"2" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
//            [self.MangerArray addObject:model];
//            [self.MemberArray removeObject:model];
//            [self.tableView reloadData];
            [self getData];
            [self getManagerData];
        }
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}

#pragma 设置为普通用户
-(void)SetCommonAct:(BXDynMemberModel *)model{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest ActSetAdminWithcircle_id:model.circle_id uid:model.user_id power:@"0" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
//            [self.MemberArray addObject:model];
//            [self.MangerArray removeObject:model];
//            [self.tableView reloadData];
            [self getData];
            [self getManagerData];
        }
        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}
/// 过滤信息
/// @param filter_id 用户id
/// @param msgType 消息类型 2动态 3圈子 6表白
/// @param filter_type 过滤类型 1全部 2单消息
/// @param filter_msg_id 指定单消息id
/// @param success 成功
/// @param failure 失败
@end

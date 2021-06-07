//
//  BXDynAiTeVC.m
//  BXlive
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynAiTeVC.h"
#import "BXDynAiTeCell.h"
#import "BXLiveUser.h"
#import "BXAttentFollowModel.h"
#import "DynAiTeFriendModel.h"
#import "HttpMakeFriendRequest.h"
#import "NSObject+Tag.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Masonry/Masonry.h>
#import <ZFPlayer/ZFPlayer.h>
#import <SDAutoLayout/SDAutoLayout.h>

@interface BXDynAiTeVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray *tempArray;

@end

@implementation BXDynAiTeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    [self.tableView addHeaderWithTarget:self action:@selector(TableDragWithDown)];
    [self.tableView headerBeginRefreshing];
    [self.tableView endRefreshingWithNoMoreData];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
        
    }];

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
#pragma mark - 请求数据
- (void)getData{
    if ([self.friendType isEqualToString:@"1"]) {
        [HttpMakeFriendRequest AteylConnectWithpage_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"50" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            [self.tableView headerEndRefreshing];
            if(flag)
            {
                if (!self.page) {
                    [self.dataArray removeAllObjects];
                    self.dataArray.ds_Tag = 0;
                    self.tableView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                    self.tableView.isNoMoreData = NO;
                }
                NSArray *followArray = jsonDic[@"data"][@"data"];
                if (followArray.count) {
                    for (NSDictionary *fdict in followArray) {
                        DynAiTeFriendModel *model = [[DynAiTeFriendModel alloc]init];
                        [model updateWithJsonDic:fdict];
                        [self.dataArray addObject:model];
                    }
                    self.dataArray.ds_Tag++;
                }else{
                    self.tableView.isNoMoreData = YES;
                }
            } else{
                [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
            }
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            self.tableView.isRefresh = NO;
            self.tableView.isNoNetwork = NO;
        } Failure:^(NSError * _Nonnull error) {
            [self.tableView headerEndRefreshing];
            self.tableView.isRefresh = NO;
            self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
        }];
    }
    if ([self.friendType isEqualToString:@"2"]) {
        [HttpMakeFriendRequest MyFocuseWithpage_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"100" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            [BGProgressHUD hidden];
            [self.tableView headerEndRefreshing];
            if(flag)
            {
                if (!self.page) {
                    [self.dataArray removeAllObjects];
                    self.dataArray.ds_Tag = 0;
                    self.tableView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                    self.tableView.isNoMoreData = NO;
                }
                NSArray *followArray = jsonDic[@"data"][@"data"];
                if (followArray.count) {
                    for (NSDictionary *fdict in followArray) {
                        DynAiTeFriendModel *model = [[DynAiTeFriendModel alloc]init];
                        [model updateWithJsonDic:fdict];
                        [self.dataArray addObject:model];
                    }
                     self.dataArray.ds_Tag++;
                }else{
                    self.tableView.isNoMoreData = YES;
                }
            } else{
                [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
            }
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            self.tableView.isRefresh = NO;
            self.tableView.isNoNetwork = NO;
        } Failure:^(NSError * _Nonnull error) {
            [BGProgressHUD hidden];
            [self.tableView headerEndRefreshing];
            self.tableView.isRefresh = NO;
            self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
        }];
    }
    if ([self.friendType isEqualToString:@"3"]) {
    [HttpMakeFriendRequest FocuseMeWithpage_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"100" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [self.tableView headerEndRefreshing];
        if(flag)
        {
            if (!self.page) {
                [self.dataArray removeAllObjects];
                self.dataArray.ds_Tag = 0;
                self.tableView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                self.tableView.isNoMoreData = NO;
            }
            NSArray *followArray = jsonDic[@"data"][@"data"];
            if (followArray.count) {
                for (NSDictionary *fdict in followArray) {
                    DynAiTeFriendModel *model = [[DynAiTeFriendModel alloc]init];
                    [model updateWithJsonDic:fdict];
                    [self.dataArray addObject:model];
                }
                 self.dataArray.ds_Tag++;
            }else{
                self.tableView.isNoMoreData = YES;
            }
        } else{
            [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
        }
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
    } Failure:^(NSError * _Nonnull error) {
        [self.tableView headerEndRefreshing];
        self.tableView.hidden = NO;
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
    }];
    }
//    [[NewHttpRequestPort sharedNewHttpRequestPort] FriendsGetFriends:@{@"offset":@"20",@"length":@"20"} Success:^(id responseObject) {
//        [BGProgressHUD hidden];
//        [self.tableView headerEndRefreshing];
//        if([responseObject[@"code"] integerValue] == 0)
//        {
//            if (!self.offset)
//            {
//                [self.dataArray removeAllObjects];
//            }
//            NSArray *followArray = responseObject[@"data"][@"follows"];
//            if (followArray.count) {
//                for (NSDictionary *fdict in followArray) {
//                    BXAttentFollowModel *model = [BXAttentFollowModel objectWithDictionary:fdict];
//                    [self.dataArray addObject:model];
//                }
//            }else{
//                self.tableView.isNoMoreData = YES;
//            }
//        } else{
//            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
//        }
////        self.tableView.hidden = NO;
//        [self.tableView reloadData];
//        self.tableView.isRefresh = NO;
//        self.tableView.isNoNetwork = NO;
//    } Failure:^(NSError *error) {
//        [self.tableView headerEndRefreshing];
//        self.tableView.isRefresh = NO;
//        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
//    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *piccell = @"cell1";
    BXDynAiTeCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
    if (cell == nil){
        cell = [[BXDynAiTeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
    }

    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.bounds.size.width tableView:_tableView];

    

}
#pragma mark - TableViewDidClickViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynAiTeFriendModel *model = self.dataArray[indexPath.row];
    if ([self.aite_type isEqualToString:@"express"]) {
        if (self.ExpressFriendBlock) {
            self.ExpressFriendBlock([_dataArray[indexPath.row] user_id], [NSString stringWithFormat:@"@%@ ",[_dataArray[indexPath.row] nickname]]);
        }
          return;
    }
    
    
    if (self.friendArray.count) {
        for (int i = 0; i< self.friendArray.count; i++) {
            NSString *friendid = [NSString stringWithFormat:@"%@",[self.friendArray[i] objectForKey:@"user_id"]];
            NSString *seluser_id = [NSString stringWithFormat:@"%@", [_dataArray[indexPath.row] user_id]];
            if ([seluser_id isEqualToString:friendid]) {
                [BGProgressHUD showInfoWithMessage:@"您已@过该好友了"];
                return;
            }
        }
    }
    
    if ([model.is_aite_selected isEqualToString:@"1"]) {
        model.is_aite_selected = @"0";
        if (self.SelFriendBlock) {
            self.SelFriendBlock([_dataArray[indexPath.row] user_id], [NSString stringWithFormat:@"@%@ ",[_dataArray[indexPath.row] nickname]], NO);
        }
    }else{
        model.is_aite_selected = @"1";
        if (self.SelFriendBlock) {
            self.SelFriendBlock([_dataArray[indexPath.row] user_id], [NSString stringWithFormat:@"@%@ ",[_dataArray[indexPath.row] nickname]], YES);
        }
    }
    [self.tableView reloadData];
    
    
//    if (self.SelFriendBlock) {
//        self.SelFriendBlock([_dataArray[indexPath.row] user_id], [NSString stringWithFormat:@"@%@ ",[_dataArray[indexPath.row] nickname]], YES);
//    }

}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
-(void)listDidAppear{
    if (self.dataArray.count) {
        for (int i = 0; i < self.dataArray.count; i++) {
            DynAiTeFriendModel *model = self.dataArray[i];
            if ([model.is_aite_selected isEqualToString:@"1"]) {
                
            }
        }
        
    }
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

@end

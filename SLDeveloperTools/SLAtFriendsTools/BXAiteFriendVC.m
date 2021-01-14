//
//  BXAiteFriendVC.m
//  BXlive
//
//  Created by bxlive on 2019/5/9.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAiteFriendVC.h"
#import "BXAiteFriendCell.h"
#import "BXAttentFollowModel.h"
#import "BXAiteFriendSearchVC.h"
#import "BaseNavVC.h"
#import "../SLMaskTools/SLMaskTools.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLAppInfo/SLAppInfo.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"


@interface BXAiteFriendVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *followsArray;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic , strong) NSMutableArray *tempArray;
@end

@implementation BXAiteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tempArray = [NSMutableArray array];
    [self initNavView];
    [self createTableView];
    [BGProgressHUD showLoadingAnimation];
    self.tableView.hidden = YES;
    [self TableDragWithDown];
}

#pragma mark - 懒加载
- (NSMutableArray *)followsArray{
    if (!_followsArray) {
        _followsArray = [NSMutableArray array];
    }
    return _followsArray;
}

- (void)TableDragWithDown
{
    self.offset = 0;
    [self createData];
}

#pragma mark - 加载更多
- (void)loadMoreData
{
    self.offset = self.followsArray.count;
    [self createData];
}

#pragma mark - 请求数据
- (void)createData{
    [[NewHttpRequestPort sharedNewHttpRequestPort] FriendsGetFriends:@{@"offset":[NSString stringWithFormat:@"%ld",(long)self.offset],@"length":@"20"} Success:^(id responseObject) {
        [BGProgressHUD hidden];
        [self.tableView headerEndRefreshing];
        if([responseObject[@"code"] integerValue] == 0)
        {
            if (!self.offset)
            {
                [self.followsArray removeAllObjects];
            }
            NSArray *followArray = responseObject[@"data"][@"follows"];
            if (followArray.count) {
                for (NSDictionary *fdict in followArray) {
                    BXAttentFollowModel *model = [BXAttentFollowModel objectWithDictionary:fdict];
                    [self.followsArray addObject:model];
                }
            }else{
                self.tableView.isNoMoreData = YES;
            }
        } else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
    } Failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
    
}

- (void)initNavView{
    //自定义导航栏
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 64+__kTopAddHeight)];
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    //删除按钮&标题
    UIView *dtView = [[UIView alloc]initWithFrame:CGRectMake(0, 20+__kTopAddHeight, __kWidth, 44)];
    dtView.backgroundColor = [UIColor clearColor];
    [navView addSubview:dtView];
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 10, 24, 24)];
    [deleteBtn setImage:[UIImage imageNamed:@"pop_icon_guanbi"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [dtView addSubview:deleteBtn];
    UILabel *titleLabel = [UILabel initWithFrame:CGRectZero text:@"选择好友" size:16 color:[UIColor whiteColor] alignment:NSTextAlignmentCenter lines:1 shadowColor:[UIColor clearColor]];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [dtView addSubview:titleLabel];
    titleLabel.sd_layout.centerXEqualToView(dtView).centerYEqualToView(dtView).widthIs(150).heightIs(44);
}

- (void)deleteBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 创建表单视图
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.topSpaceToView(self.view, 64+__kTopAddHeight).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
    UIButton *search = [UIButton buttonWithFrame:CGRectZero Title:@"搜索ID或昵称" Font:CFont(14) Color:MinorColor Image:CImage(@"icon_search_1") Target:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    search.backgroundColor = PageSubBackgroundColor;
    [headView addSubview:search];
    search.sd_layout.leftSpaceToView(headView, 16).rightSpaceToView(headView, 16).centerYEqualToView(headView).heightIs(34);
    search.imageView.sd_layout.leftSpaceToView(search, 9).centerYEqualToView(search).widthIs(18).heightEqualToWidth();
    search.titleLabel.sd_layout.leftSpaceToView(search.imageView,5).centerYEqualToView(search).heightIs(20).rightSpaceToView(search, 10);
    search.sd_cornerRadius = @(17);
    [self.tableView endRefreshingWithNoMoreData];
}
-(void)searchBtnClick{
    WS(ws);
    
    BXAiteFriendSearchVC *friend = [[BXAiteFriendSearchVC alloc] init];
    friend.friendArray = self.friendArray;
    [friend setSelectTextArray:^(NSMutableArray * _Nonnull array) {
        NSDictionary *dict;
        if (array.count) {
            dict = array[0];
            [ws.tempArray addObject:dict];
            ws.selectTextArray(ws.tempArray);
            [ws dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    BaseNavVC *nav = [[BaseNavVC alloc] initWithRootViewController:friend];
    nav.modalPresentationStyle =  UIModalPresentationFullScreen;
    [self presentViewController:nav animated:NO completion:nil];
}
#pragma mark - UITableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.followsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.followsArray.count) {
        return 40;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BXAiteFriendCell *cell = [BXAiteFriendCell cellWithTableView:tableView];
    cell.model = self.followsArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BXAttentFollowModel *model =  self.followsArray[indexPath.row];
    [self selectModel:model];
}

-(void)selectModel:(BXAttentFollowModel *)model{
    NSLog(@"%@",self.friendArray);
    if (self.friendArray.count>0) {
        BOOL ishave = NO;
        for (NSDictionary *dic in self.friendArray) {
            if (IsEquallString(model.user_id, dic[@"id"])) {
                ishave = YES;
                break;
            }
        }
        if (ishave) {
            [BGProgressHUD showInfoWithMessage:@"您已@过TA了"];
        }else{
            [self.tempArray addObject:@{@"name":[NSString stringWithFormat:@"@%@ ",model.nickname],@"id":model.user_id}];
            self.selectTextArray(self.tempArray);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self.tempArray addObject:@{@"name":[NSString stringWithFormat:@"@%@ ",model.nickname],@"id":model.user_id}];
        self.selectTextArray(self.tempArray);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *ID = @"BXFriendViewVCHeader";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:ID];
        header.contentView.backgroundColor = self.view.backgroundColor;
        UILabel *label = [UILabel initWithFrame:CGRectZero size:14 color:TextBrightestColor alignment:0 lines:1];
        
        [header.contentView addSubview:label];
        label.sd_layout.leftSpaceToView(header.contentView, 16).topSpaceToView(header.contentView, 0).bottomSpaceToView(header.contentView, 0).rightSpaceToView(header.contentView, 16);
        
        label.text = @"你关注的人";
    }
    return header;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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

@end

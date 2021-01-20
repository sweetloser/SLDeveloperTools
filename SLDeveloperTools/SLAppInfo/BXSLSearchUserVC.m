//
//  BXSLSearchUserVC.m
//  BXlive
//
//  Created by bxlive on 2019/3/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchUserVC.h"
#import "BXSLLiveUserCell.h"
//#import "BXPersonHomeVC.h"
#import "SLAppInfoConst.h"
#import <Masonry/Masonry.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "NewHttpManager.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"


@interface BXSLSearchUserVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *liveUsers;
@property (nonatomic , assign) NSInteger offset;

@end

@implementation BXSLSearchUserVC

- (void)getUsers {
    [NewHttpManager globalSearchWithType:@"user" keyword:_searchResultVC.searchText offset:[NSString stringWithFormat:@"%ld",_offset] success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [self.tableView.mj_header endRefreshing];
        if(flag) {
            if (!self.offset){
                [self.liveUsers removeAllObjects];
                self.tableView.isNoMoreData = NO;
            }
            NSArray *dataArray = jsonDic[@"data"];
            if (dataArray && dataArray.count) {
                for (NSDictionary *dic in dataArray) {
                    BXLiveUser *liveUser = [[BXLiveUser alloc]init];
                    [liveUser updateWithJsonDic:dic];
                    [self.liveUsers addObject:liveUser];
                }
            } else {
                self.tableView.isNoMoreData = YES;
            }
            [self.tableView reloadData];
        }
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    
}

- (void)listDidDisappear {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _liveUsers = [NSMutableArray array];
    self.view.backgroundColor = PageBackgroundColor;;
    [self initViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needSearchAction) name:kNeedSearchNotification object:nil];
}

- (void)initViews {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];

    WS(ws);
    BXRefreshHeader *header = [BXRefreshHeader headerWithRefreshingBlock:^{
        ws.offset = 0;
        [ws getUsers];
    }];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];

}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.liveUsers.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BXSLLiveUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[BXSLLiveUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.liveUser = _liveUsers[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BXLiveUser *liveUser = _liveUsers[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":liveUser.user_id,@"isShow":@"",@"nav":self.navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:liveUser.user_id isShow:nil nav:self.navigationController handle:nil];
}


#pragma - mark UIScrollViewDelegate
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
            _offset = _liveUsers.count;
            [self getUsers];
        }
    }
}

#pragma - mark DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if ([NewHttpManager isNetWorkConnectionAvailable]) {
        return nil;
    } else {
        WS(ws);
        BXNoNetworkView *noNetworkView = [[BXNoNetworkView alloc]initWithHeight:290];
        noNetworkView.needRefresh = ^{
            ws.offset = 0;
            [ws getUsers];
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

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

#pragma - mark Notification
- (void)needSearchAction {
    [_tableView.mj_header beginRefreshing];
}

@end

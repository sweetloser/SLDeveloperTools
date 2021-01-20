//
//  BXSLSearchLiveVC.m
//  BXlive
//
//  Created by bxlive on 2019/3/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchLiveVC.h"
#import "BXSLLiveRoomtCell.h"
//#import "HHMoviePlayVC.h"
#import "SLMoviePlayVCCoonfig.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "NewHttpManager.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "BXSLLiveRoom.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoConst.h"
#import <Masonry/Masonry.h>
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"
#import "SLAppInfoConst.h"

@interface BXSLSearchLiveVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *liveRooms;
@property (nonatomic , assign) NSInteger offset;

@end

@implementation BXSLSearchLiveVC

- (void)getLiveRooms {
    [NewHttpManager globalSearchWithType:@"live" keyword:_searchResultVC.searchText offset:[NSString stringWithFormat:@"%ld",_offset] success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [self.tableView.mj_header endRefreshing];
        if(flag) {
            if (!self.offset){
                [self.liveRooms removeAllObjects];
                self.tableView.isNoMoreData = NO;
            }
            NSArray *dataArray = jsonDic[@"data"];
            if (dataArray && dataArray.count) {
                for (NSDictionary *dict in dataArray) {
                    BXSLLiveRoom *liveRoom = [BXSLLiveRoom objectWithDictionary:dict];
                    [self.liveRooms addObject:liveRoom];
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
    _liveRooms = [NSMutableArray array];
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
        [ws getLiveRooms];
    }];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.liveRooms.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  __ScaleWidth(450);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BXSLLiveRoomtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[BXSLLiveRoomtCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.liveRoom = _liveRooms[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BXSLLiveRoom *liveRoom = _liveRooms[indexPath.row];
//    [BXLocalAgreement loadUrl:liveRoom.jump fromVc:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXLoadURL object:nil userInfo:@{@"vc":self,@"url":liveRoom.jump}];
    
    SLMoviePlayVCCoonfig *config = [SLMoviePlayVCCoonfig shareMovePlayConfig];
    config.loadUrl = nil;
    config.hasMore = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXEnterRoomWithRooms object:nil userInfo:@{@"rooms":@[liveRoom],@"index":@0,@"vc":self}];
    
//    [BXLocalAgreement enterLiveRoomWithAllRoomData:@[liveRoom] currentSelectedIndex:0 fromVc:self];
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
            _offset = _liveRooms.count;
            [self getLiveRooms];
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
            [ws getLiveRooms];
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

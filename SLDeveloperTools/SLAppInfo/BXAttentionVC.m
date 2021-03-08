//
//  BXAttentionVC.m
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXAttentionVC.h"
#import "BXAttentionNoDataCell.h"
#import "BXAttentionPeopleCell.h"
#import "BXAttentionRecommCell.h"
#import "BXAttentionVideoCell.h"
#import "BXAttentionLiveCell.h"
#import "BXHMovieModel.h"
#import "BXAttentFollowModel.h"
//#import "BXMessageCategoryVC.h"
//#import "BXPersonHomeVC.h"
#import "BXAttentRecommView.h"
#import "BXLoadingView.h"
//#import "BXVideoPlayVC.h"
//#import "BXSLSearchVC.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "BXNormalControllView.h"
#import "BXCommentView.h"
#import "BXKTVHTTPCacheManager.h"
#import "BXSendCommentView.h"
#import "BXClickVideoViewVC.h"
#import "BXTransitionAnimation.h"
#import "UIApplication+ActivityViewController.h"
#import "BXMediaModel.h"
#import "NSObject+Tag.h"
#import "SLAppInfoConst.h"
#import "../SLMaskTools/SLMaskTools.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "NewHttpRequestPort.h"
#import "../SLCategory/SLCategory.h"
#import "NewHttpManager.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "SLAppInfoMacro.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"
#import "BXLiveUser.h"
#import "NewHttpRequestHuang.h"
#import <YYCategories/YYCategories.h>

@interface BXAttentionVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,BXAttentionVideoCelllDelegate>

@property(nonatomic,strong)NSMutableArray *followArray;
@property(nonatomic,strong)NSMutableArray *recommArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *isLiveArray;
@property (strong, nonatomic) UIButton *searchBtn;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger poffset;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) BXNormalControllView *controlView;
@property (nonatomic, strong) ZFAVPlayerManager  *playerManager;

@property (nonatomic, weak) BXCommentView *commentView;

@end

@implementation BXAttentionVC

-(NSMutableArray *)followArray{
    if (!_followArray) {
        _followArray = [NSMutableArray array];
        
    }
    return _followArray;
}
-(NSMutableArray *)recommArray{
    if (!_recommArray) {
        _recommArray = [NSMutableArray array];
    }
    return _recommArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    _isLiveArray = [NSMutableArray array];
    [BGProgressHUD showLoadingAnimation:nil inView:self.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didZan:) name:kDidZanNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendChangeStatus:) name:kSendChangeStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCollect:) name:kDidCollectNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSee:) name:kDidSeeNotification object:nil];
    
}
- (void)initView {
    self.view.backgroundColor = sl_BGColors;
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = sl_BGColors;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49 + __kBottomAddHeight);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = sl_BGColors;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[BXAttentionNoDataCell class] forCellReuseIdentifier:@"BXAttentionNoDataCell"];
    [self.tableView registerClass:[BXAttentionPeopleCell class] forCellReuseIdentifier:@"BXAttentionPeopleCell"];
    [self.tableView registerClass:[BXAttentionRecommCell class] forCellReuseIdentifier:@"BXAttentionRecommCell"];
    [self.tableView registerClass:[BXAttentionVideoCell class] forCellReuseIdentifier:@"BXAttentionVideoCell"];
    [self.tableView registerClass:[BXAttentionLiveCell class] forCellReuseIdentifier:@"BXAttentionLiveCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64 + __kTopAddHeight);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    [self.tableView addHeaderWithTarget:self action:@selector(TableDragWithDown)];
    [self.tableView endRefreshingWithNoMoreData];
    
    [self TableDragWithDown];
    @weakify(self)
    _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (!self.player.playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }
    };
    
    self.playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:self.playerManager containerViewTag:101];
    self.player.controlView = self.controlView;
    self.player.WWANAutoPlay = YES;
    self.player.shouldAutoPlay = YES;
    self.player.allowOrentitaionRotation = NO;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch | ZFPlayerDisableGestureTypesSingleTap;
    self.player.playerDisapperaPercent = 1;

    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self);
        [self.player.currentPlayerManager replay];
    };
    
    
    for (NSInteger i = 0; i < 2; i++) {
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction)];
        swipe.direction = i ? UISwipeGestureRecognizerDirectionLeft : UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipe];
    }
    
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
}

- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate 列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

- (void)swipeAction {
    
}

- (void)TableDragWithDown {
    self.offset = 0;
    self.poffset = 0;
    dispatch_group_t group = dispatch_group_create();
    [self loadRecommendData:group];
    [self loadFollowData:group];
    [self createData:group];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.player stopCurrentPlayingCell];
        [self.tableView reloadData];
        @weakify(self);
        /// 找到可以播放的视频并播放
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self);
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    });
}

#pragma mark - 加载更多
- (void)loadMoreData
{
    self.offset = self.dataArray.ds_Tag;
    [self createData:nil];
}

#pragma mark - 请求数据
-(void)loadRecommendData:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    [[NewHttpRequestPort sharedNewHttpRequestPort] getFollowRecommendList:@{@"offset":[NSString stringWithFormat:@"%ld",(long)self.poffset]} Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            [self.recommArray removeAllObjects];
            NSArray *recommArray = responseObject[@"data"];
            if (recommArray.count) {
                for (NSDictionary *cdict in recommArray) {
                    BXAttentFollowModel *model = [BXAttentFollowModel objectWithDictionary:cdict];
                    [self.recommArray addObject:model];
                }
            }
//            else{
//                self.poffset = 0;
//                [self loadRecommendData:nil];
//            }
            self.poffset++;
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        if (group) {
            dispatch_group_leave(group);
        }else{
            [self.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        if (group) {
            dispatch_group_leave(group);
        }
    }];
}
-(void)loadFollowData:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    [[NewHttpRequestPort sharedNewHttpRequestPort] FollowCurrentFollow:@{@"user_id":[BXLiveUser currentBXLiveUser].user_id} Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            [self.followArray removeAllObjects];
            [self.isLiveArray removeAllObjects];
            NSDictionary *dataDic = responseObject[@"data"];
            if (dataDic && [dataDic isDictionary]) {
                NSArray *followArray = dataDic[@"list"];
                if (followArray.count) {
                    for (NSDictionary *cdict in followArray) {
                        BXAttentFollowModel *model = [BXAttentFollowModel objectWithDictionary:cdict];
                        [self.followArray addObject:model];
                        
                        BXSLLiveRoom *liveRoom = [[BXSLLiveRoom alloc]init];
                        [liveRoom updateWithJsonDic:cdict];
                        [self.isLiveArray addObject:liveRoom];
                    }
                }
            }
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        if (group) {
            dispatch_group_leave(group);
        }else{
            [self.tableView reloadData];
        }
        
    } Failure:^(NSError *error) {
        if (group) {
            dispatch_group_leave(group);
        }
    }];
    
}

- (void)createData:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    [[NewHttpRequestPort sharedNewHttpRequestPort] FollowNewPublish:@{@"offset":[NSString stringWithFormat:@"%ld",(long)self.offset]} Success:^(id responseObject) {
        [self.tableView headerEndRefreshing];
        [BGProgressHUD hidden];
        if([responseObject[@"code"] integerValue] == 0) {
            if (!self.offset) {
                [self.dataArray removeAllObjects];
                self.dataArray.ds_Tag = 0;
                self.tableView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                self.tableView.isNoMoreData = NO;
            }
        
            NSDictionary *dataDic = responseObject[@"data"];
            if (dataDic && [dataDic isDictionary]) {
                NSArray *videoArr = dataDic[@"video"];
                NSArray *liveArr = dataDic[@"live"];
                NSMutableArray *tempVideos = [NSMutableArray array];
                NSMutableArray *tempLives = [NSMutableArray array];
                if (videoArr && [videoArr isArray] && videoArr.count) {
                    for (NSDictionary *dic in videoArr) {
                        BXHMovieModel *video = [[BXHMovieModel alloc]init];
                        [video updateWithJsonDic:dic];
                        BXMediaModel *model = [[BXMediaModel alloc]init];
                        model.type = @"video";
                        model.video = video;
                        [tempVideos addObject:model];
                    }
                    for (NSDictionary *dic in liveArr) {
                        BXSLLiveRoom *liveRoom = [[BXSLLiveRoom alloc]init];
                        [liveRoom updateWithJsonDic:dic];
                        BXMediaModel *model = [[BXMediaModel alloc]init];
                        model.type = @"live";
                        model.liveRoom = liveRoom;
                        [tempLives addObject:model];
                    }
                    
                    NSMutableArray *tempDataArr = [NSMutableArray arrayWithArray:tempVideos];
                    [tempDataArr addObjectsFromArray:tempLives];
                    for (NSInteger i = 0; i < tempLives.count; i++) {
                        BXMediaModel *model = tempLives[i];
                        NSInteger index = [model.liveRoom.index integerValue];
                        if (index > 0 && index < tempVideos.count) {
                            [tempDataArr exchangeObjectAtIndex:i + tempVideos.count withObjectAtIndex:index];
                        }
                    }
                    [self.dataArray addObjectsFromArray:tempDataArr];
                    self.dataArray.ds_Tag += tempVideos.count;
                } else {
                    self.tableView.isNoMoreData = YES;
                }
            }
        } else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
        if (group) {
            dispatch_group_leave(group);
        }else{
            [self.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        if (group) {
            dispatch_group_leave(group);
        }
        [BGProgressHUD hidden];
        [self.tableView headerEndRefreshing];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}

- (void)attenRecommendWithIndex:(NSInteger)index {
    if (![NewHttpManager isNetWorkConnectionAvailable]) {
        return ;
    }
    BXAttentFollowModel *model = self.recommArray[index];
    NSMutableArray *arr = [NSMutableArray array];
    for (BXAttentFollowModel *model in self.recommArray) {
        [arr addObject:model.user_id];
    }
    NSString *user_id;
    if (arr.count) {
        [arr removeObject:model.user_id];
        user_id =  [arr componentsJoinedByString:@","];
    }
    
    [[NewHttpRequestPort sharedNewHttpRequestPort] Followfollow:@{@"user_id":model.user_id,@"is_return":@"1",@"exists":user_id} Success:^(id responseObject) {
        if ([responseObject[@"code"]intValue] == 0) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self.recommArray removeObjectAtIndex:index];
                if ([responseObject[@"data"][@"recommend"] count] > 0) {
                    BXAttentFollowModel *model = [BXAttentFollowModel objectWithDictionary: responseObject[@"data"][@"recommend"]];
                    [self.recommArray addObject:model];
                }
            }
        }
        [self loadFollowData:nil];
        [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        [BGProgressHUD hidden];
    }];
}

#pragma - mark UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (self.followArray.count) {
            return 134;
        }
        return 120;
    }else if (indexPath.section==1){
        if (self.recommArray.count) {
            return 224;
        }
        return 0;
    }
    BXMediaModel *mediaModel = self.dataArray[indexPath.row];
    if (IsEquallString(mediaModel.type, @"video")) {
        return [self.tableView cellHeightForIndexPath:indexPath model:mediaModel.video keyPath:@"model" cellClass:[BXAttentionVideoCell class] contentViewWidth:SCREEN_WIDTH];
    } else {
        return [self.tableView cellHeightForIndexPath:indexPath model:mediaModel.liveRoom keyPath:@"model" cellClass:[BXAttentionLiveCell class] contentViewWidth:SCREEN_WIDTH];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 && self.recommArray.count ) {
        return 46;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        if (self.followArray.count) {
            return 1;
        }
    }
    if (section==1) {
        if (self.recommArray.count) {
           return 1;
        }
    }
    return 0.1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }
    return self.dataArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (self.followArray.count) {
            BXAttentionPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXAttentionPeopleCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.dataArr = self.followArray;
            cell.is_live_dataArr = self.isLiveArray;
            return cell;
        }
        BXAttentionNoDataCell *cell = [BXAttentionNoDataCell cellWithTableView:tableView];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
       
    }else if (indexPath.section==1){
        BXAttentionRecommCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXAttentionRecommCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.recArr = self.recommArray;
        @weakify(self);
        [cell setAttentRecommBlock:^(NSInteger index) {
            @strongify(self);
            [self attenRecommendWithIndex:index];
        }];
        return cell;
    }
    BXMediaModel *mediaModel = self.dataArray[indexPath.row];
    if (IsEquallString(mediaModel.type, @"video")) {
        BXAttentionVideoCell *cell = [BXAttentionVideoCell cellWithTableView:tableView];
        cell.backgroundColor = [UIColor clearColor];
        [cell setDelegate:self withIndexPath:indexPath];
        cell.model = mediaModel.video;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    } else {
        BXAttentionLiveCell *cell = [BXAttentionLiveCell cellWithTableView:tableView];
        cell.backgroundColor = [UIColor clearColor];
        cell.model = mediaModel.liveRoom;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1 && self.recommArray.count){
        BXAttentRecommView *backView = [[BXAttentRecommView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        ZZL(weakSelf);
        [backView setChangeConnentPeople:^{
            [weakSelf loadRecommendData:nil];
        }];
        return backView;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        if (self.followArray.count) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
            backView.backgroundColor = LineNormalColor;
            return backView;
        }
        return nil;
    }else if(section==1){
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        backView.backgroundColor = LineNormalColor;
        return backView;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        BXMediaModel *mediaModel = self.dataArray[indexPath.row];
        if (IsEquallString(mediaModel.type, @"video")) {
//            BXVideoPlayVC *vc = [[BXVideoPlayVC alloc]init];
//            vc.videos = @[mediaModel.video];
//            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2BXVideoPlayVC object:nil userInfo:@{@"vc":self,@"movie_models":@[mediaModel.video],@"index":@(0)}];
        } else {
//            [BXLocalAgreement loadUrl:mediaModel.liveRoom.jump fromVc:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:BXLoadURL object:nil userInfo:@{@"vc":self,@"url":mediaModel.liveRoom.jump}];
        }
    }
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

- (void)didZan:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *movieId = info[@"movieId"];
    NSIndexPath *indexPath = nil;
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        BXMediaModel *mediaModel = self.dataArray[i];
        if (IsEquallString(mediaModel.type, @"video")) {
            BXHMovieModel *video = mediaModel.video;
            if ([movieId integerValue] == [video.movieID integerValue]) {
                video.is_zan = info[@"is_zan"];
                video.zan_sum = info[@"zan_sum"];
                indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
    }
    if (indexPath) {
      [self.tableView reloadData];
    }
}

- (void)sendChangeStatus:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *user_id = info[@"user_id"];
    NSIndexPath *indexPath = nil;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        BXMediaModel *mediaModel = self.dataArray[i];
        if (IsEquallString(mediaModel.type, @"video")) {
            BXHMovieModel *video = mediaModel.video;
            if (IsEquallString(user_id, video.user_id)) {
                NSString *is_follow = [NSString stringWithFormat:@"%@",info[@"status"]];
                video.is_follow = is_follow;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
        }
        
        
    }
    for (NSInteger i = 0; i < self.recommArray.count; i++) {
        BXAttentFollowModel *video = self.recommArray[i];
        if (IsEquallString(user_id, video.user_id)) {
            NSString *is_follow = [NSString stringWithFormat:@"%@",info[@"status"]];
            video.is_follow = is_follow;
            indexPath = [NSIndexPath indexPathForRow:i inSection:1];
            break;
        }
    }
    if (indexPath||indexPaths.count) {
        [self.tableView reloadData];
    }
    
    [self loadFollowData:nil];
}
- (void)didCollect:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *type = info[@"type"];
    if (IsEquallString(type, @"video")) {
        NSString *movieId = info[@"movieId"];
        for (BXMediaModel *mediaModel in self.dataArray) {
            if (IsEquallString(mediaModel.type, @"video")) {
                BXHMovieModel *video = mediaModel.video;
                if ([movieId integerValue] == [video.movieID integerValue]) {
                    video.is_collect = info[@"is_collect"];
                    break;
                }
            }
        }
    }
}

-(void)didSee:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *user_id = info[@"user_id"];
    NSIndexPath *indexPath = nil;
    for (NSInteger i = 0; i < self.followArray.count; i++) {
        BXAttentFollowModel *model = self.followArray[i];
        if ([user_id integerValue] == [model.user_id integerValue]) {
            model.is_see = @"1";
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    if (indexPath) {
        [self.tableView reloadData];
    }
}

#pragma BXAttentionVideoCell 代理
- (void)didClickLikeButtonInCell:(BXAttentionVideoCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self loadIndexPath:indexPath cell:cell];
       
}
#pragma 评论 0  评论列表 1
- (void)didClickcCommentButtonInCell:(BXAttentionVideoCell *)cell type:(NSInteger)type{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BXMediaModel *mediaModel = self.dataArray[indexPath.row];
    BXHMovieModel *videoModel = mediaModel.video;
    if (type) {
        WS(ws);
        BXSendCommentView *view = [[BXSendCommentView alloc]initWithFrame:CGRectZero array:@[]];
        view.sendComment = ^(NSString * _Nonnull text, NSString * _Nonnull jsonString) {
            [ws sendCommentWithText:text jsonString:jsonString section:indexPath.row commentModel:videoModel indexPath:indexPath];
        };
        
        [self.navigationController.tabBarController.view addSubview:view];
        [view show:0];
    }else{
        BXCommentView *commentView = [[BXCommentView alloc]initWitBXHMovieModel:videoModel];
        commentView.commentNumChanged = ^(BOOL isAdd, BXCommentModel *comment) {
             WS(ws);
            if (isAdd) {
                [comment processAttributedStringWithAttaties];
                comment.toPersonHome = ^(NSString * _Nonnull userId) {
                    [ws userDetail:userId];
                };
                [videoModel.commentlist insertObject:comment atIndex:0];
                [ws loadIndexPath:indexPath cell:cell];
            }else{
                BOOL isFresh = NO;
                for (NSInteger i = 0; i < videoModel.commentlist.count; i++) {
                    BXCommentModel *models = videoModel.commentlist[i];
                    if ([models.comment_id integerValue] == [comment.comment_id integerValue]) {
                        [videoModel.commentlist removeObjectAtIndex:i];
                        isFresh = YES;
                        break;
                    }
                }
                if (isFresh) {
                    [ws loadIndexPath:indexPath cell:cell];
                }
                
            }
        };
        [commentView showInView:self.navigationController.tabBarController.view];
        self.commentView = commentView;
    }
}
#pragma 回复某人
-(void)didClickcCommentButtonInCell:(BXAttentionVideoCell *)cell model:(BXCommentModel *)model{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BXMediaModel *mediaModel = self.dataArray[indexPath.row];
    BXHMovieModel *videoModel = mediaModel.video;
    BXCommentView *commentView = [[BXCommentView alloc]initWitBXHMovieModel:videoModel];
    commentView.commentNumChanged = ^(BOOL isAdd, BXCommentModel *comment) {
        WS(ws);
        if (isAdd) {
            [comment processAttributedStringWithAttaties];
            comment.toPersonHome = ^(NSString * _Nonnull userId) {
                [ws userDetail:userId];
            };
            [videoModel.commentlist insertObject:comment atIndex:0];
            [ws loadIndexPath:indexPath cell:cell];
        }else{
            BOOL isFresh = NO;
            for (NSInteger i = 0; i < videoModel.commentlist.count; i++) {
                BXCommentModel *models = videoModel.commentlist[i];
                if ([models.comment_id integerValue] == [comment.comment_id integerValue]) {
                    [videoModel.commentlist removeObjectAtIndex:i];
                    isFresh = YES;
                    break;
                }
            }
            if (isFresh) {
               [ws loadIndexPath:indexPath cell:cell];
            }

        }
    };
    [commentView showInView:self.navigationController.tabBarController.view isWrite:YES topComment:model];
    self.commentView = commentView;
}
#pragma 点击播放按钮
- (void)didClickPlayButtonInCell:(BXAttentionVideoCell *)cell playButton:(UIButton *)playButton{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BXMediaModel *mediaModel = self.dataArray[indexPath.row];
    BXHMovieModel *videoModel = mediaModel.video;
    self.currentIndexPath = cell.indexPath;
    if (playButton.selected) {
        videoModel.isPlay = NO;
        [cell.musicName pause];
        [self.player.currentPlayerManager pause];
    }else{
        videoModel.isPlay = YES;
        [cell.musicName resume];
        [self.player.currentPlayerManager play];
    }
}
#pragma 点击封面
-(void)didClickCoverImageInCell:(BXAttentionVideoCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BXMediaModel *mediaModel = self.dataArray[indexPath.row];
    BXHMovieModel *videoModel = mediaModel.video;
    if (self.player.playingIndexPath != indexPath) {
        return;
    }

    //  点击放大
    BXClickVideoViewVC *vc = [[BXClickVideoViewVC alloc] initWithVideoModel:videoModel];
    vc.player = self.player;
    self.currentIndexPath = indexPath;
    self.controlView.progressView.hidden = YES;
    @weakify(self);
    [vc setDetailPlayCallback:^(BXHMovieModel * _Nonnull playVideoModel) {
        @strongify(self);
        self.controlView.progressView.hidden = NO;
        [self.player addPlayerViewToCell];
        if (playVideoModel.isPlay) {
            [self didClickPlayButtonInCell:cell playButton:cell.playBtn];
            [cell.musicName resume];
            cell.playBtn.selected = NO;
            [self.player.currentPlayerManager play];
        }else{
            [cell.musicName pause];
            [self.player.currentPlayerManager pause];
            cell.playBtn.selected = YES;
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma  列表播放
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    BXMediaModel *mediaModel = self.dataArray[indexPath.row];
    if (IsEquallString(mediaModel.type, @"video")) {
        self.currentIndexPath = indexPath;
        BXHMovieModel *model = mediaModel.video;
        [self.controlView resetControlView];
        NSURL * proxyURL = [BXKTVHTTPCacheManager getProxyURLWithOriginalURL:[NSURL URLWithString:model.video_url]];
        NSInteger scalingMode = [model getScalingModeWithScreenHeight:__kHeight];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.player.currentPlayerManager.scalingMode = scalingMode;
        [self.controlView showCoverURLString:model.cover_url scalingMode:scalingMode];
        [self.player playTheIndexPath:indexPath assetURL:proxyURL scrollToTop:NO];
        [CATransaction commit];
        
        BXAttentionVideoCell *cell = (BXAttentionVideoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        for (int i =0; i<self.dataArray.count; i++) {
            BXMediaModel *theMediaModel = self.dataArray[indexPath.row];
            if (IsEquallString(theMediaModel.type, @"video")) {
                BXHMovieModel *vidoe = theMediaModel.video;
                if ([cell.model isEqual:vidoe]) {
                    vidoe.isPlay = YES;
                }else{
                    vidoe.isPlay = NO;
                }
            }
        }
        [self.tableView reloadData];
    }
}
- (BXNormalControllView *)controlView {
    if (!_controlView) {
        _controlView = [BXNormalControllView new];
    }
    return _controlView;
}

#pragma  评论接口
- (void)sendCommentWithText:(NSString *)string jsonString:(NSString *)jsonString section:(NSInteger)section commentModel:(BXHMovieModel *)commentModel indexPath:(NSIndexPath *)indexPath{
    WS(ws);
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]CommentCommentWithVideoID:commentModel.movieID Comment:string ReplyID:@"" Friends:jsonString Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            NSDictionary *dic = responseObject[@"data"];
            BXCommentModel *model = [[BXCommentModel alloc] initWithDict:dic[@"now_comment_data"]];
            model.toPersonHome = ^(NSString * _Nonnull userId) {
                [ws userDetail:userId];
            };
            [model processAttributedStringWithAttaties];
            [commentModel.commentlist insertObject:model atIndex:0];
            BXAttentionVideoCell *cell = (BXAttentionVideoCell *)[ws.tableView cellForRowAtIndexPath:indexPath];
            [ws loadIndexPath:indexPath cell:cell];
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
    } Failure:^(NSError *error) {
        
    }];
}
-(void)userDetail:(NSString *)userId {
    if (self.commentView) {
        [self.commentView commentViewhidden];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":userId,@"isShow":@"",@"nav":self.navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:userId isShow:nil nav:self.navigationController handle:nil];
}

-(void)loadIndexPath:(NSIndexPath *)indexPath cell:(BXAttentionVideoCell *)cell{
    if (self.player.playingIndexPath != indexPath) {
        [self.player stopCurrentPlayingCell];
    }
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
    [self.player addPlayerViewToCell];
    [self didClickPlayButtonInCell:cell playButton:cell.playBtn];
}

#pragma - mark JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    if (self.commentView) {
        [self.commentView showInView:nil];
    }
    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        if (!self.tableView.zf_playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        } else {
            BXMediaModel *mediaModel = self.dataArray[self.currentIndexPath.row];
            if (IsEquallString(mediaModel.type, @"video")) {
                BXHMovieModel *model = mediaModel.video;
                BXAttentionVideoCell *cell = (BXAttentionVideoCell *)[self.tableView cellForRowAtIndexPath:self.tableView.zf_playingIndexPath];
                if (model.isPlay) {
                    [self.player.currentPlayerManager play];
                    [cell.musicName resume];
                    cell.playBtn.selected = NO;
                } else {
                    [self.player.currentPlayerManager pause];
                    [cell.musicName pause];
                    cell.playBtn.selected = YES;
                }
            }
        }
    }];
}

- (void)listWillDisappear {
    if ([_player.currentPlayerManager isPlaying]) {
        [_player.currentPlayerManager pause];
    }
}

- (void)listDidDisappear {
    if ([_player.currentPlayerManager isPlaying]) {
        [_player.currentPlayerManager pause];
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
            [ws TableDragWithDown];
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
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
@end



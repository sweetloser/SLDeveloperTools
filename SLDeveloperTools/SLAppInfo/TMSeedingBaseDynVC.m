//
//  TMSeedingBaseDynVC.m
//  BXlive
//
//  Created by mac on 2020/11/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import "TMSeedingBaseDynVC.h"

#import "TMSEEDOnePicCell.h"
#import "TMSEEDFourPicCell.h"
#import "TMSEEDMorePicCell.h"
#import "TMSEEDVideoTableViewCell.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "BXNormalControllView.h"

#import "BXKTVHTTPCacheManager.h"

#import "BXDynMoreAlertView.h"
#import "BXDynCircelOperAlert.h"

#import "BaseNavVC.h"
#import "BXShortVideoConfigure.h"

#import "HZPhotoBrowser.h"

#import "SLReportToolVC.h"
//#import "BXDynSynTopicCategoryVC.h"

#import "BXDynamicModel.h"
#import "SLAmwayListModel.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "NSObject+Tag.h"
#import "BXDynClickPlayVC.h"
#import "BXDynAlertRemoveSoundView.h"
#import <Aspects/Aspects.h>
#import "BXAVPlayerManager.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MJExtension/MJExtension.h>
#import <YYCategories/YYCategories.h>
#import "../SLCategory/SLCategory.h"
#import "SLAmwayListModel.h"
#import "SLAmwayDetailModel.h"
#import <CTMediatorSLAmway/CTMediator+SLAmway.h>


@interface TMSeedingBaseDynVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate, TMSEEDBaseCellDelegate>



@property (nonatomic, strong) BXNormalControllView *controlView;

@property (nonatomic , assign) BOOL isResh;

@property (nonatomic,strong)NSString *vcType;

@property (nonatomic,assign)BOOL isUnfold;

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger poffset;


@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSIndexPath *SoundcurrentIndexPath;

@property(nonatomic, strong)HZPhotoBrowser *browser;

@property(nonatomic, strong)NSMutableArray *SLDataArray;


@property(nonatomic, strong)NSIndexPath *currentPlayCellInndexPath;

@end

@implementation TMSeedingBaseDynVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}

-(UITableView *)tableview{
    if(_tableview == nil){
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64.0 + __kTopAddHeight, self.view.frame.size.width, self.view.bounds.size.height - 64.0 - __kTopAddHeight - 49 - __kBottomAddHeight) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
    }
    return _tableview;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    _dataArray = [NSMutableArray array];
    _SLDataArray = [NSMutableArray array];
    self.view.backgroundColor = sl_BGColors;
    [self.view addSubview:self.tableview];
    [self createTableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendChangeStatus:) name:TMSeedLikeStatus object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendCommentStatus:) name:DynamdicCommentStatusNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoCommentStatus:) name:TMSeedCommentStatus object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLike:) name:SLAmwayDidLikeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undeleteChange:) name:kDeleteNotification object:nil];


    
}

#pragma mark - 下拉刷新
- (void)TableDragWithDown {
    self.page = 0;
    dispatch_group_t group = dispatch_group_create();
    [self getData:group];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.player stopCurrentPlayingCell];
        [self.tableview reloadData];
        @weakify(self);
        /// 找到可以播放的视频并播放
        [self.tableview zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self);
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    });
}

#pragma mark - 加载更多
- (void)loadMoreData
{
    self.page = self.dataArray.ds_Tag;
    [self getData:nil];
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
-(void)getData:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    WS(weakSelf);
    [[NewHttpManager sharedNetManager] AmwayPost:@"plantinggrass/api/grass/getMyFouncs" parameters:@{@"page_index":[NSString stringWithFormat:@"%ld",(long)_page+1],@"page_size":@20} success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if (!weakSelf.page) {
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.SLDataArray removeAllObjects];
                weakSelf.dataArray.ds_Tag = 0;
                weakSelf.tableview.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                weakSelf.tableview.isNoMoreData = NO;
            }
            NSArray *dataArray1 = responseObject[@"data"][@"list"];
            if (dataArray1 && [dataArray1 isArray] && dataArray1.count) {
                for (NSDictionary *dic in dataArray1) {
                    NSMutableDictionary *addDic = [NSMutableDictionary dictionary];
                    [addDic setValue:dic forKey:@"msgdetail"];
                    [addDic setValue:dic[@"id"] forKey:@"fcmid"];
                    BXDynamicModel *model = [[BXDynamicModel alloc]init];
                    [model updateWithJsonDic:addDic];
                    [weakSelf.dataArray addObject:model];
                    
                    
                    SLAmwayListModel *slmodel = [SLAmwayListModel mj_objectWithKeyValues:dic];
                    NSLog(@"%@",slmodel.systemplus);
                    [weakSelf.SLDataArray addObject:slmodel];
                }

                 weakSelf.dataArray.ds_Tag++;
            }
            else {
                weakSelf.tableview.isNoMoreData = YES;
            }
        }
        else{
            [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
        }

        [weakSelf.tableview headerEndRefreshing];
        weakSelf.tableview.isRefresh = NO;
        weakSelf.tableview.isNoNetwork = NO;
        
        if (group) {
            dispatch_group_leave(group);
        }else{
                [weakSelf.tableview reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        if (group) {
            dispatch_group_leave(group);
        }
        [BGProgressHUD hidden];
        [weakSelf.tableview headerEndRefreshing];
        weakSelf.tableview.isRefresh = NO;
        weakSelf.tableview.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
    
}


-(void)createTableView{
    
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.tableview.tableFooterView = [[UIView alloc]init];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableview.estimatedRowHeight = 0;
    [self.tableview addHeaderWithTarget:self action:@selector(TableDragWithDown)];
    [self.tableview endRefreshingWithNoMoreData];
    [self.tableview headerBeginRefreshing];
    [self.tableview aspect_hookSelector:@selector(scrollToRowAtIndexPath:atScrollPosition:animated:) withOptions:AspectPositionInstead usingBlock:^(id _id){
        return;
    } error:nil];
    

    self.playerManager = [[BXAVPlayerManager alloc] initWithTpye:BXAVPlayerManagerVideoPlayDynamicNew];
    self.player = [ZFPlayerController playerWithScrollView:self.tableview playerManager:self.playerManager containerViewTag:101];
    self.player.controlView = self.controlView;
    self.player.WWANAutoPlay = YES;
    self.player.shouldAutoPlay = YES;
    self.player.allowOrentitaionRotation = NO;
//    self.player.resumePlayRecord = YES;
//    /// 0.4是消失40%时候
//    self.player.playerDisapperaPercent = 0.4;
//    /// 0.6是出现60%时候
//    self.player.playerApperaPercent = 0.6;
    
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch | ZFPlayerDisableGestureTypesSingleTap;
    self.player.playerDisapperaPercent = 1;
    @weakify(self)

    
    _tableview.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (!self.player.playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self);
        [self.player.currentPlayerManager replay];
    };

}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    WS(weakSelf);
    NSInteger render_type = [[self.dataArray[indexPath.row] msgdetailmodel].render_type integerValue];
    if (render_type == 1) {
        static NSString *onecell = @"onepic";
        TMSEEDOnePicCell *cell = [tableView dequeueReusableCellWithIdentifier:onecell];
        if (cell == nil){
            cell = [[TMSEEDOnePicCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:onecell];
        }
        cell.delegate = self;
        cell.model = self.dataArray[indexPath.row];
        cell.DidClickItem = ^(NSInteger index) {
  
        };
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
  else  if (render_type ==  4) {
      static NSString *piccell = @"fourcell";
      TMSEEDFourPicCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
      if (cell == nil){
          cell = [[TMSEEDFourPicCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
      }
      cell.delegate = self;
      cell.model= _dataArray[indexPath.row];
      [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
      cell.selectionStyle = UITableViewCellSeparatorStyleNone;
      return cell;
      
  }
  else  if (render_type == 7) {
      static NSString *sealcell = @"sealvideo";
      TMSEEDVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sealcell];
      if (cell == nil){
          cell = [[TMSEEDVideoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sealcell];
      }
      cell.model = _dataArray[indexPath.row];
      cell.slModel = _SLDataArray[indexPath.row];
      cell.delegate = self;
      cell.indexPath = indexPath;
      WS(weakSelf);
      cell.DidClickPlay = ^(BXDynamicModel * _Nonnull model, UIButton * _Nullable playbtn, TMSEEDVideoTableViewCell * _Nonnull cell) {
          [weakSelf playManagerModel:model index:indexPath button:playbtn cell:cell];
      };
      cell.DidCover = ^(TMSEEDVideoTableViewCell * _Nonnull cell) {
          [weakSelf playManagerCovercell:cell];
      };
      cell.selectionStyle = UITableViewCellSeparatorStyleNone;
      [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
      return cell;
    }

  
  else{

      static NSString *piccell = @"morecell";
      TMSEEDMorePicCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
      if (cell == nil){
          cell = [[TMSEEDMorePicCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
      }
      cell.delegate = self;
      cell.model= _dataArray[indexPath.row];
      [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
      cell.selectionStyle = UITableViewCellSeparatorStyleNone;
      return cell;
  }

}
-(void)didClickUnfoldInCell:(TMSEEDOnePicCell *)cell isUnfold:(BOOL)unfold{
    self.isUnfold = unfold;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];

    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//return [self.tableview cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[BXDynBaseTableviewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableview];
    


}
#pragma mark - TableViewDidClickViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[[_dataArray[indexPath.row] msgdetailmodel] render_type] intValue] == 7 ) {
        return;
    }
    
    SLAmwayListModel *model = [[SLAmwayListModel alloc]init];
    model.user = [[SLAmwayPublicUser alloc]init];
    model.list_id = [NSNumber numberWithString:[NSString stringWithFormat:@"%@", [_dataArray[indexPath.row] fcmid]]];
    model.user.avatar = [[_dataArray[indexPath.row] msgdetailmodel] avatar];
    model.address = [[_dataArray[indexPath.row] msgdetailmodel]address];
    model.user.nickname = [[_dataArray[indexPath.row] msgdetailmodel]nickname];
    
    UIViewController *vc = [[CTMediator sharedInstance] TMSeedingPictureDetailVC_ViewControllerWithListModel:model DynModel:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
    
    if (self.player.playingIndexPath != indexPath) {
        [self.player stopCurrentPlayingCell];
    }
    
}

-(void)didClickUnfoldInCell:(TMSeedingBaseTableviewCell *)cell{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    self.dataArray[indexPath.row] = cell.model;
    [self.tableview reloadData];
}
-(void)didClickHeaderCell:(TMSeedingBaseTableviewCell *)cell{

    
//    BXDynSynTopicCategoryVC *vc = [[BXDynSynTopicCategoryVC alloc]init];
//
//    [self pushVc:vc];
//    BXExpressingWallVC *vc = [[BXExpressingWallVC alloc]init];
//    [self pushVc:vc];
    
}
-(void)didClickMoreCell:(TMSeedingBaseTableviewCell *)cell{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    BXDynamicModel *model = self.dataArray[indexPath.row];
    NSString *is_mine = [NSString stringWithFormat:@"%@",model.msgdetailmodel.user_id];
    NSString *my_id = [NSString stringWithFormat:@"%@",[BXLiveUser currentBXLiveUser].user_id];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if ([is_mine isEqualToString:my_id]) {
        BXDynCircelOperAlert *OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"删除", @"取消"]];
        OperationAlert.DidOpeClick = ^(NSInteger tag) {
            if (tag == 0) {
                BXDynAlertRemoveSoundView *view =[[BXDynAlertRemoveSoundView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)Title:@"是否删除此种草信息" Sure:@"删除" Cancle:@"取消"];
                  view.RemoveBlock = ^{
                      [[NewHttpManager sharedNetManager] APIPOST:@"plantinggrass/api/grass/delPlantingGress" parameters:@{@"gress_id":model.fcmid} success:^(id  _Nonnull responseObject) {
                          NSNumber *code = responseObject[@"code"];
                          if ([code integerValue] == 0) {
                              [self.dataArray removeObjectAtIndex:indexPath.row];
                              [self.tableview reloadData];
                          }
                          [BGProgressHUD showInfoWithMessage:responseObject[@"message"]];
                      } failure:^(NSError * _Nonnull error) {
                          [BGProgressHUD showInfoWithMessage:@"删除失败"];
                      }];
                  };
                  [window addSubview:view];
            }
        };
        [OperationAlert showWithView:window];
        return;
    }
    BXDynCircelOperAlert *OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"举报", @"取消"]];
    OperationAlert.DidOpeClick = ^(NSInteger tag) {
        if (tag == 0) {
            SLAmwayDetailModel *slmodel = [[SLAmwayDetailModel alloc]init];
            slmodel.usermsg = [[SLAmwayDetailUserModel alloc]init];
            slmodel.usermsg.nickname = model.msgdetailmodel.nickname;
            slmodel.content = model.msgdetailmodel.content;
            slmodel.msg_id = [NSNumber numberWithString:[NSString stringWithFormat:@"%@", model.fcmid]];
            
            SLReportToolVC *tvc = [[SLReportToolVC alloc] init];
            tvc.amwayDetailModel = slmodel;
            
            tvc.reportType = SLReportTypeAmwayPicture;
            
            [self pushVc:tvc];
        }
    };
    [OperationAlert showWithView:window];
    


}


-(void)didClickOperation:(TMSeedingBaseTableviewCell *)cell model:(BXDynamicModel *)model type:(NSInteger)type{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    self.dataArray[indexPath.row] = cell.model;

}


- (void)sendChangeStatus:(NSNotification *)noti {
//    NSDictionary *info = noti.userInfo;
//    BXDynamicModel *model = info[@"model"];
//    NSString *fcmid = [NSString stringWithFormat:@"%@", model.fcmid];
//    for (NSInteger i = 0; i < self.dataArray.count; i++) {
//        NSString *datafcmid = [NSString stringWithFormat:@"%@",[self.dataArray[i] fcmid]];
//        if (IsEquallString(fcmid, datafcmid)) {
//            self.dataArray[i] = model;
//            [self.tableview reloadData];
//            break;
//        }
//    }
    NSDictionary *info = noti.userInfo;
    NSString *list_id = [NSString stringWithFormat:@"%@", info[@"fcmid"]];

    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        BXDynamicModel *model = self.dataArray[i];
        SLAmwayListModel *m = self.SLDataArray[i];
        if ([list_id integerValue] == [model.fcmid integerValue]) {
            if ([info[@"status"] intValue] == 1) {
//                model.msgdetailmodel.extend_already_live =  @"1";
//                model.msgdetailmodel.like_num = [NSString stringWithFormat:@"%d",[model.msgdetailmodel.like_num intValue] + 1 ];
                m.mylive = [NSNumber numberWithString:@"1"];
                m.like_num = [NSNumber numberWithString:[NSString stringWithFormat:@"%d",[m.like_num intValue] + 1]];
            }
            else{
//                model.msgdetailmodel.extend_already_live =  @"0";
//                model.msgdetailmodel.like_num = [NSString stringWithFormat:@"%d",[model.msgdetailmodel.like_num intValue] - 1 ];
                m.mylive = [NSNumber numberWithString:@"0"];
                m.like_num = [NSNumber numberWithString:[NSString stringWithFormat:@"%d",[m.like_num intValue] - 1]];
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPaths addObject:indexPath];
            break;
        }
    }
    if (indexPaths) {
        [_tableview reloadData];
    }
    
}
-(void)sendCommentStatus:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    BXDynamicModel *model = info[@"model"];
    NSString *fcmid = [NSString stringWithFormat:@"%@", model.fcmid];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        NSString *datafcmid = [NSString stringWithFormat:@"%@",[self.dataArray[i] fcmid]];
        if (IsEquallString(fcmid, datafcmid)) {
            self.dataArray[i] = model;
            [self.tableview reloadData];
            break;
        }
    }
}
-(void)VideoCommentStatus:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;

    NSString *fcmid = [NSString stringWithFormat:@"%@", info[@"fcmid"]];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        NSString *datafcmid = [NSString stringWithFormat:@"%@",[self.dataArray[i] fcmid]];
        if (IsEquallString(fcmid, datafcmid)) {
            BXDynamicModel *model = self.dataArray[i];
            if ([info[@"status"] intValue] == 1) {
                model.msgdetailmodel.comment_num = [NSString stringWithFormat:@"%d", [model.msgdetailmodel.comment_num intValue] + 1];
            }else{
                model.msgdetailmodel.comment_num = [NSString stringWithFormat:@"%d", [model.msgdetailmodel.comment_num intValue] - 1];
            }
//            self.dataArray[i] = model;
            [self.tableview reloadData];
            break;
        }
    }
}
-(void)sendAttentionStatus:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *status = info[@"atten_status"];
    NSString *user_id = [NSString stringWithFormat:@"%@", info[@"user_id"]];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        NSString *datafcmid = [NSString stringWithFormat:@"%@",[[self.dataArray[i] msgdetailmodel] user_id]];
        if (IsEquallString(user_id, datafcmid)) {
            BXDynamicModel *model = self.dataArray[i];
            if ([status isEqualToString:@"1"]) {
                
                model.msgdetailmodel.extend_followed = @"1";
            }else{
                model.msgdetailmodel.extend_followed = @"0";
            }
            self.dataArray[i] = model;
        }
    }
    [self.tableview reloadData];

}
-(void)sendCircleFollowStatus:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *status = info[@"extend_circlfollowed"];
    NSString *circle_id = [NSString stringWithFormat:@"%@", info[@"circle_id"]];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        if ([self.dataArray[i] msgdetailmodel].extend_circledetailArray.count) {
            NSString *datacircle_id = [NSString stringWithFormat:@"%@",[[self.dataArray[i] msgdetailmodel].extend_circledetailArray[0] circle_id]];
            if (IsEquallString(circle_id, datacircle_id)) {
                BXDynamicModel *model = self.dataArray[i];
                if ([status isEqualToString:@"1"]) {
                    
                    model.msgdetailmodel.extend_circlfollowed = @"1";
                }else{
                    model.msgdetailmodel.extend_circlfollowed = @"0";
                }
                self.dataArray[i] = model;
            }
        }
    }
    [self.tableview reloadData];

}
- (void)didLike:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *list_id = [NSString stringWithFormat:@"%@", info[@"list_id"]];

    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        BXDynamicModel *model = self.dataArray[i];
        SLAmwayListModel *m = self.SLDataArray[i];
        if ([list_id integerValue] == [model.fcmid integerValue]) {
            model.msgdetailmodel.extend_already_live =  [NSString stringWithFormat:@"%@",info[@"mylive"]];
            model.msgdetailmodel.like_num = [NSString stringWithFormat:@"%@",info[@"like_num"]];
            m.mylive = [NSNumber numberWithString:[NSString stringWithFormat:@"%@",info[@"mylive"]]];
            m.like_num = [NSNumber numberWithString:[NSString stringWithFormat:@"%@",info[@"like_num"]]];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPaths addObject:indexPath];
            break;
        }
    }
    if (indexPaths) {
        [_tableview reloadData];
    }
}
-(void)undeleteChange:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSString *movieId = [NSString stringWithFormat:@"%@",info[@"movieId"]];
    for (BXDynamicModel *video in self.dataArray) {
        NSString *list_Id = [NSString stringWithFormat:@"%@",video.fcmid];
        if (IsEquallString(movieId, list_Id)) {
            [self.dataArray removeObject:video];
            [_tableview reloadData];
            break;
        }
    }
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
- (void)listDidAppear {

    @weakify(self)
    [self.tableview zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        if (!self.tableview.zf_playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        } else {
            BXDynamicModel *model = self.dataArray[self.currentIndexPath.row];
//            if (IsEquallString(mediaModel.type, @"video")) {
//                BXHMovieModel *model = mediaModel.video;
                TMSEEDVideoTableViewCell *cell = (TMSEEDVideoTableViewCell *)[self.tableview cellForRowAtIndexPath:self.tableview.zf_playingIndexPath];
                if (model.isPlay) {
                    [self.player.currentPlayerManager play];

                    cell.playBtn.selected = NO;
                    
                } else {
                    [self.player.currentPlayerManager pause];

                    cell.playBtn.selected = YES;
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


#pragma  列表播放
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    BXDynamicModel *model = self.dataArray[indexPath.row];
    if ([[NSString stringWithFormat:@"%@", model.msgdetailmodel.render_type] isEqualToString:@"7"]) {
        self.currentIndexPath = indexPath;
        [self.controlView resetControlView];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        NSURL *url = [NSURL URLWithString:model.msgdetailmodel.video];
        [self.controlView showCoverURLString:model.cover_url scalingMode:1];
        [self.player playTheIndexPath:indexPath assetURL:url scrollPosition:ZFPlayerScrollViewScrollPositionCenteredHorizontally animated:YES];
        model.isPlay = YES;
        [CATransaction commit];


        TMSEEDVideoTableViewCell *cell = (TMSEEDVideoTableViewCell *)[self.tableview cellForRowAtIndexPath:indexPath];
        for (int i =0; i<self.dataArray.count; i++) {
            BXDynamicModel *model = self.dataArray[indexPath.row];
            if ([[NSString stringWithFormat:@"%@", model.msgdetailmodel.render_type] isEqualToString:@"7"] ) {
                if ([cell.model isEqual:model]) {
                    model.isPlay = YES;
                }else{
                    model.isPlay = NO;
                }
            }
        }
        self.dataArray[indexPath.row] = model;
        [self.tableview reloadData];
//        [self.tableview reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)playManagerModel:(BXDynamicModel *)model index:(NSIndexPath*)index button:(UIButton *)playbtn cell:(TMSEEDVideoTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    BXDynamicModel *playmodel = self.dataArray[indexPath.row];
    self.currentIndexPath = cell.indexPath;
    if (playbtn.selected) {

        playmodel.isPlay = NO;
        [self.player.currentPlayerManager pause];
    }else{

        playmodel.isPlay = YES;
        [self.player.currentPlayerManager play];
    }
//    self.dataArray[indexPath.row] = playmodel;

}
-(void)playManagerCovercell:(TMSEEDVideoTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    BXDynamicModel *model = self.dataArray[indexPath.row];
    SLAmwayListModel *m = self.SLDataArray[indexPath.row];
    if (self.player.playingIndexPath != indexPath) {
        return;
    }
    if ([model.msgdetailmodel.render_type intValue] == 7) {
        //        视频
        NSNumber *currentIndex = @0;
        NSMutableArray *modelList = [NSMutableArray new];
        for (SLAmwayListModel *model in self.SLDataArray) {
            if ([model.render_type integerValue] == 7) {
                [modelList addObject:model];
                if ([m isEqual:model]) {
                    currentIndex = @(modelList.count -1);
                }
            }
        }
        UIViewController *svc = [[CTMediator sharedInstance] SLAmwayVideoShowVC_ViewControllerWithModelList:modelList CurrentIndex:currentIndex];
        
        
        [self.navigationController pushViewController:svc animated:YES];
        return;
    }
    BXDynClickPlayVC *vc = [[BXDynClickPlayVC alloc] initWithVideoModel:model];
    vc.player = self.player;
    self.currentIndexPath = indexPath;
    self.controlView.progressView.hidden = YES;
    @weakify(self);
    [vc setDetailPlayCallback:^(BXDynamicModel * _Nonnull playVideoModel) {
        @strongify(self);
        self.controlView.progressView.hidden = NO;
        [self.player addPlayerViewToCell];
        if (playVideoModel.isPlay) {
            [self playManagerModel:playVideoModel index:0 button:cell.playBtn cell:cell];
            cell.playBtn.selected = NO;
            [self.player.currentPlayerManager play];
        }else{
            
            [self.player.currentPlayerManager pause];
            cell.playBtn.selected = YES;
        }
        
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
- (BXNormalControllView *)controlView {
    if (!_controlView) {
        _controlView = [BXNormalControllView new];
    }
    return _controlView;
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
//
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
-(void)uptatecellHeight{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    [_tableview beginUpdates];
    [_tableview.delegate tableView:_tableview heightForRowAtIndexPath:indexPath1];
    [_tableview endUpdates];
}
-(void)updatecellheightWithunfold:(BOOL)unfold{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *index = [self.tableview indexPathForSelectedRow];
    [_tableview beginUpdates];
    [_tableview.delegate tableView:_tableview heightForRowAtIndexPath:index];
    [_tableview endUpdates];
    
}
#pragma - mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
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

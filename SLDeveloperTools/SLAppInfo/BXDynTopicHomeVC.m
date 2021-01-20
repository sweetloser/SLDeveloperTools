//
//  BXDynTopicHomeVC.m
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//
//
#import "BXDynTopicHomeVC.h"
#import "BXDynNewOnePicCell.h"
#import "BXDynNewMorePicCell.h"
#import "BXDynNewFourPicCell.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "BXNormalControllView.h"
#import "BXMediaModel.h"
#import "BXHMovieModel.h"
#import "BXKTVHTTPCacheManager.h"
#import "BXDynamicDetailsVC.h"
#import "BXAttentionVideoCell.h"
#import "BXDynNewVideoTableViewCell.h"
#import "BXDynGoodsCell.h"
#import "BXDynRecommendCell.h"
#import "BXDynSoundCell.h"
#import "BXDynShareLiveCell.h"
#import "BXDynLivingCell.h"
#import "BXDynMoreAlertView.h"
#import "BXDynCircelOperAlert.h"
#import "BXDynWhisperAlertView.h"
//#import "SLTHShortRecordVideoVC.h"
#import "BaseNavVC.h"
#import "BXShortVideoConfigure.h"
#import "BXOPenIssueDyn.h"
#import "HZPhotoBrowser.h"
//#import "BXExpressingWallVC.h"
#import "BXDynTipOffVC.h"
#import "BXDynSynTopicCategoryVC.h"
#import "BXDynCircleCategoryVC.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynamicModel.h"
#import "DynPlayMp3Voice.h"
#import "NSObject+Tag.h"
#import "BXDynClickPlayVC.h"
#import "BXHMovieModel.h"
//#import "BXVideoPlayVC.h"
#import "BXDynAlertRemoveSoundView.h"
#import "BXAVPlayerManager.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoConst.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "NewHttpManager.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"
@interface BXDynTopicHomeVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate, BXDynBaseCellDelegate,playDelegate>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , assign) BOOL isResh;
@property (nonatomic,strong)NSString *vcType;

@property (nonatomic,assign)BOOL isUnfold;

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger poffset;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) BXNormalControllView *controlView;
@property (nonatomic, strong) ZFAVPlayerManager  *playerManager;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSIndexPath *SoundcurrentIndexPath;

@property(nonatomic, strong)HZPhotoBrowser *browser;

@property(nonatomic, strong)DynPlayMp3Voice *playSound;
@property(nonatomic, assign)NSInteger playFlag;

@property(nonatomic, strong)BXDynSoundCell *currentSoundCell;

@property (nonatomic, copy) void(^listScrollViewDidScroll)(UIScrollView *scrollView);
@end

@implementation BXDynTopicHomeVC
- (UIScrollView *)listScrollView {
    return self.tableview;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView * _Nonnull))callback {
    self.listScrollViewDidScroll = callback;
}
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
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - 64.0 - __kTopAddHeight - 49 - __kBottomAddHeight) style:UITableViewStylePlain];
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
//    [BGProgressHUD showLoadingAnimation];
    [self.view addSubview:self.tableview];
 self.view.backgroundColor = [UIColor whiteColor];
//    MMKV *mmkv = [MMKV defaultMMKV];
//    _dataArray =  [mmkv getObjectOfClass:[NSMutableArray class] forKey:DynamicHomePageNew];
//    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
//    }

    [self createTableView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendChangeStatus:) name:DynamdicLikeStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendAttentionStatus:) name:DynamicAttention object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendCommentStatus:) name:DynamdicCommentStatusNotification object:nil];

    
}
-(void)createRessh{
    //下拉刷新
//    [self.tableview addHeaderWithTarget:self action:@selector(TableDragWithDown)];
//    [self.tableview headerBeginRefreshing];
}
#pragma mark - 下拉刷新
- (void)TableDragWithDown {
    self.offset = 0;
    self.poffset = 0;
    self.page = 0;
    dispatch_group_t group = dispatch_group_create();
    if ([self.dynType isEqualToString:@"1"]) {
        [self getPersonData:group];
    }else{
        [self getData:group];
    }
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
    self.isResh = NO;
    if ([self.dynType isEqualToString:@"1"]) {
        [self getPersonData:nil];
    }else{
        [self getData:nil];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
    !self.listScrollViewDidScroll ? : self.listScrollViewDidScroll(scrollView);
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
    
     [HttpMakeFriendRequest TipTopicListWithpage_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"20" extend_type:@"1" topic_id:self.model.topic_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        NSLog(@"%@", jsonDic);
        if (flag) {
            if (!self.page) {
                [self.dataArray removeAllObjects];
                self.dataArray.ds_Tag = 0;
                self.tableview.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                self.tableview.isNoMoreData = NO;
            }
            NSArray *dataArray1 = jsonDic[@"data"][@"data"];
            if (dataArray1 && [dataArray1 isArray] && dataArray1.count) {
                for (NSDictionary *dic in dataArray1) {
                    BXDynamicModel *model = [[BXDynamicModel alloc]init];
                    [model updateWithJsonDic:dic];
                    [self.dataArray addObject:model];
                    
                }
//                if (self.page == 0) {
//
//                    MMKV *mmkv = [MMKV defaultMMKV];
//                    [mmkv setObject:self.dataArray forKey:DynamicHomePageNew];
//                }
                 self.dataArray.ds_Tag++;
            }
            else {
                self.tableview.isNoMoreData = YES;
            }
        }
        else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        
        
        [self.tableview headerEndRefreshing];
        self.tableview.isRefresh = NO;
        self.tableview.isNoNetwork = NO;
        
        if (group) {
            dispatch_group_leave(group);
        }else{
            [self.tableview reloadData];
        }
    } Failure:^(NSError *error) {
        if (group) {
            dispatch_group_leave(group);
        }
        [BGProgressHUD hidden];
        [self.tableview headerEndRefreshing];
        self.tableview.isRefresh = NO;
        self.tableview.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
-(void)getPersonData:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    
    
    [HttpMakeFriendRequest MySenderDynWithpage_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"10" type:@"2" user_id:self.user_id Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        NSLog(@"%@", jsonDic);
        if (flag) {
            if (!self.page) {
                [self.dataArray removeAllObjects];
                self.dataArray.ds_Tag = 0;
                self.tableview.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
                self.tableview.isNoMoreData = NO;
            }
            NSArray *dataArray1 = jsonDic[@"data"][@"data"];
            if (dataArray1 && [dataArray1 isArray] && dataArray1.count) {
                for (NSDictionary *dic in dataArray1) {
                    BXDynamicModel *model = [[BXDynamicModel alloc]init];
                    [model updateWithJsonDic:dic];
                    [self.dataArray addObject:model];
                    
                }
                self.dataArray.ds_Tag++;
            }
            else {
                self.tableview.isNoMoreData = YES;
            }
        }
        else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        
        
        [self.tableview headerEndRefreshing];
        self.tableview.isRefresh = NO;
        self.tableview.isNoNetwork = NO;
        
        if (group) {
            dispatch_group_leave(group);
        }else{
            [self.tableview reloadData];
        }
    } Failure:^(NSError *error) {
        if (group) {
            dispatch_group_leave(group);
        }
        [BGProgressHUD hidden];
        [self.tableview headerEndRefreshing];
        self.tableview.isRefresh = NO;
        self.tableview.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
-(void)createTableView{

    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.tableview.tableFooterView = [[UIView alloc]init];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableview.rowHeight = UITableViewAutomaticDimension;
//    self.tableview.estimatedRowHeight = 100;
    [self.tableview addHeaderWithTarget:self action:@selector(TableDragWithDown)];
    [self.tableview endRefreshingWithNoMoreData];
    [self.tableview headerBeginRefreshing];
    
//    [self TableDragWithDown];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(0));
        make.top.bottom.mas_equalTo(0);
        make.bottom.mas_equalTo(-__kBottomAddHeight);
        make.right.mas_equalTo(0);
    }];
    
    self.playerManager = [[ZFAVPlayerManager alloc] init];
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
//    [self.player setZf_scrollViewDidEndScrollingCallback:^(NSIndexPath * _Nonnull indexPath) {
//        @strongify(self)
//        if (!self.player.playingIndexPath) {
//            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
//        }
//    }];
    
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
    
    self.playSound = [[DynPlayMp3Voice alloc]init];
    self.playSound.delegate =self;
    
    self.scrollView = self.tableview;
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WS(weakSelf);
    NSInteger render_type = [[self.dataArray[indexPath.row] msgdetailmodel].render_type integerValue];
    if (render_type == 0 || render_type == 5 || render_type == 10 || render_type == 11 || render_type == 13) {
        static NSString *onecell = @"onepic";
        BXDynNewOnePicCell *cell = [tableView dequeueReusableCellWithIdentifier:onecell];
        if (cell == nil){
            cell = [[BXDynNewOnePicCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:onecell];
        }
        cell.delegate = self;
        cell.model = self.dataArray[indexPath.row];
        cell.DidClickItem = ^(NSInteger index) {
            [weakSelf ClickItemAct:index];
        };
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
  else  if (render_type == 1 || render_type == 2) {
      BXDynamicModel *model = self.dataArray[indexPath.row];
      if ([model.msgdetailmodel.picture count] == 4) {
          static NSString *piccell = @"fourcell";
          BXDynNewFourPicCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
          if (cell == nil){
              cell = [[BXDynNewFourPicCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
          }
          cell.delegate = self;
          cell.model= _dataArray[indexPath.row];
          [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
          cell.selectionStyle = UITableViewCellSeparatorStyleNone;
          return cell;
      }else{
          static NSString *piccell = @"morecell";
          BXDynNewMorePicCell *cell = [tableView dequeueReusableCellWithIdentifier:piccell];
          if (cell == nil){
              cell = [[BXDynNewMorePicCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:piccell];
          }
          cell.delegate = self;
          cell.model= _dataArray[indexPath.row];
          [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
          cell.selectionStyle = UITableViewCellSeparatorStyleNone;
          return cell;
      }
    }
  else  if (render_type == 3 || render_type == 4 || render_type == 20) {
      static NSString *sealcell = @"sealvideo";
      BXDynNewVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sealcell];
      if (cell == nil){
          cell = [[BXDynNewVideoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sealcell];
      }
      cell.model = _dataArray[indexPath.row];
      cell.delegate = self;
      cell.indexPath = indexPath;
      WS(weakSelf);
      cell.DidClickPlay = ^(BXDynamicModel * _Nonnull model, UIButton * _Nullable playbtn, BXDynNewVideoTableViewCell * _Nonnull cell) {
          [weakSelf playManagerModel:model index:indexPath button:playbtn cell:cell];
      };
      cell.DidCover = ^(BXDynNewVideoTableViewCell * _Nonnull cell) {
          [weakSelf playManagerCovercell:cell];
      };
      cell.selectionStyle = UITableViewCellSeparatorStyleNone;
      [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
      return cell;
    }
  else  if (render_type == 6 ){
      static NSString *sealcell = @"sound";
      BXDynSoundCell *cell = [tableView dequeueReusableCellWithIdentifier:sealcell];
      if (cell == nil){
          cell = [[BXDynSoundCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sealcell];
      }

      cell.model = _dataArray[indexPath.row];
      WS(weakSelf);
      __block BXDynSoundCell *weakCell = cell;
      cell.DidSoundIndex = ^(NSString * _Nonnull voiceurl, BXDynSoundCell * _Nonnull cell) {
          if ([weakSelf.playSound.player isPlaying]) {
              [weakSelf.playSound StopPlay];
              
              //                  先停止播放上一个点击的。不管是否为当前的cell。都停止
              BXDynSoundCell *pCell = [weakSelf.tableview cellForRowAtIndexPath:weakSelf.SoundcurrentIndexPath];
              [pCell StoprotateView];
              
              //                  [weakSelf.currentSoundCell StoprotateView];
              //                  判断是否为当前cell
              if (indexPath.row != self.SoundcurrentIndexPath.row) {
                  weakSelf.SoundcurrentIndexPath = indexPath;
                  [weakSelf.playSound StartPlayWithplaypath:voiceurl];
                  [weakSelf.playSound startPlay];
                  [weakCell rotateView];
              }
              
          }else{
              weakSelf.SoundcurrentIndexPath = indexPath;
              //                  weakSelf.currentSoundCell = cell;
              [weakSelf.playSound StartPlayWithplaypath:voiceurl];
              [weakSelf.playSound startPlay];
              [weakCell rotateView];
              //                  [weakSelf.currentSoundCell rotateView];
          }
          
          
      };
      
      
      if (indexPath.row == self.SoundcurrentIndexPath.row) {
          if ([self.playSound.player isPlaying]) {
              [cell rotateView];
          }
      }
      cell.delegate = self;
      [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      return cell;
  }
  else if (render_type == 7) {
      static NSString *sealcell = @"recommend";
        BXDynRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:sealcell];
        if (cell == nil){
            cell = [[BXDynRecommendCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sealcell];
        }
        cell.array = [[_dataArray[indexPath.row] msgdetailmodel ]circle_recomedArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }

   else if (render_type == 8){
        static NSString *sealcell = @"seal";
        BXDynGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:sealcell];
        if (cell == nil){
            cell = [[BXDynGoodsCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sealcell];
        }
        cell.model = _dataArray[indexPath.row];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

 else if (render_type == 12){
        static NSString *sealcell = @"shareLive";
        BXDynShareLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:sealcell];
        if (cell == nil){
            cell = [[BXDynShareLiveCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sealcell];
        }
        cell.model = _dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
  else if (render_type == 9){
        static NSString *sealcell = @"Live";
        BXDynLivingCell *cell = [tableView dequeueReusableCellWithIdentifier:sealcell];
        if (cell == nil){
            cell = [[BXDynLivingCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sealcell];
        }
        cell.model = _dataArray[indexPath.row];
      cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }

    else{
        BXDynNewOnePicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notcellID"];
        if (cell == nil){
            cell = [[BXDynNewOnePicCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"notcellID"];
        }
        cell.delegate = self;
//        cell.model = self.dataArray[indexPath.row];
        cell.DidClickItem = ^(NSInteger index) {
            [weakSelf ClickItemAct:index];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }

}
-(void)didClickUnfoldInCell:(BXDynNewOnePicCell *)cell isUnfold:(BOOL)unfold{
    self.isUnfold = unfold;
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
//    BXDynNewModel *model = self.dataArray[indexPath.row];

    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableview reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//return [self.tableview cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[BXDynBaseTableviewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableview];
    


}
#pragma mark - TableViewDidClickViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger render_type = [[self.dataArray[indexPath.row] msgdetailmodel].render_type integerValue];
    if (render_type == 0 || render_type == 10 ||render_type == 11 ||render_type == 1 ||render_type == 2 ||render_type == 3 ||render_type == 4 ||render_type == 6 ||render_type == 13 ||render_type == 20) {
        BXDynamicDetailsVC *vc = [[BXDynamicDetailsVC alloc]initWithType:[self.dataArray[indexPath.row] msgdetailmodel].render_type model:self.dataArray[indexPath.row]];
        vc.model = self.dataArray[indexPath.row];
        [self pushVc:vc];
    }
    if (self.player.playingIndexPath != indexPath) {
        [self.player stopCurrentPlayingCell];
    }
    
}

-(void)didClickUnfoldInCell:(BXDynBaseTableviewCell *)cell{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    self.dataArray[indexPath.row] = cell.model;
    [self.tableview reloadData];
}
-(void)didClickHeaderCell:(BXDynBaseTableviewCell *)cell{

    
    BXDynSynTopicCategoryVC *vc = [[BXDynSynTopicCategoryVC alloc]init];
    
    [self pushVc:vc];
//    BXExpressingWallVC *vc = [[BXExpressingWallVC alloc]init];
//    [self pushVc:vc];
    
}
-(void)didClickMoreCell:(BXDynBaseTableviewCell *)cell{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NSString *is_mine = [NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row] ismysender]];
    if ([is_mine isEqualToString:@"1"]) {
        BXDynCircelOperAlert *OperationAlert = [[BXDynCircelOperAlert alloc]initWithItemArray:@[@"删除", @"取消"]];
        OperationAlert.DidOpeClick = ^(NSInteger tag) {
            if (tag == 0) {
                
                BXDynAlertRemoveSoundView *view =[[BXDynAlertRemoveSoundView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)Title:@"是否删除此动态" Sure:@"删除" Cancle:@"取消"];
                  view.RemoveBlock = ^{
                      [HttpMakeFriendRequest DelMsgWithmsg_id:[self.dataArray[indexPath.row] fcmid] Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
                           if (flag) {
                               [self.dataArray removeObjectAtIndex:indexPath.row];
                               [self.tableview reloadData];
                           }else{
                               [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                           }
                       } Failure:^(NSError * _Nonnull error) {
                           [BGProgressHUD showInfoWithMessage:@"操作失败"];
                       }];
                  };
                  [window addSubview:view];

            }
        };
        [OperationAlert showWithView:window];
        return;
    }
    BXDynMoreAlertView *alert = [[BXDynMoreAlertView alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height) model:self.dataArray[indexPath.row]];
    alert.determineBlock = ^(NSString * _Nonnull user_id, NSInteger tag) {
        NSLog(@"%ld", (long)tag);
        if (tag == 2) {
            BXDynTipOffVC *vc = [[BXDynTipOffVC alloc]init];
            vc.model = self.dataArray[indexPath.row];
            vc.reporttype = @"2";
            vc.reportmsg_id = [self.dataArray[indexPath.row]fcmid];
            [self pushVc:vc];
        }
        if (tag == 0) {
            [HttpMakeFriendRequest setFilterWithfilter_id:[[self.dataArray[indexPath.row] msgdetailmodel] user_id] msgType:@"2" filter_type:@"1" filter_msg_id:[self.dataArray[indexPath.row] fcmid] Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
                if (flag) {
                    NSString *user_id = [[self.dataArray[indexPath.row] msgdetailmodel] user_id];
                    for (int i = 0; i < self.dataArray.count; i++) {
                        if ([user_id isEqualToString:[NSString stringWithFormat:@"%@",[[self.dataArray[i] msgdetailmodel] user_id]]]) {
                            [self.dataArray removeObjectAtIndex:i];
                        }
                    }
                    [self.tableview reloadData];
                }else{
                    [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                }
                
            } Failure:^(NSError * _Nonnull error) {
                [BGProgressHUD showInfoWithMessage:@"操作失败"];
                [BGProgressHUD hidden];
                
            }];
            
        }
        if (tag == 1) {
            
            [HttpMakeFriendRequest setFilterWithfilter_id:[[self.dataArray[indexPath.row] msgdetailmodel] user_id] msgType:@"2" filter_type:@"2" filter_msg_id:[self.dataArray[indexPath.row] fcmid] Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
                    if (flag) {
                        [self.dataArray removeObjectAtIndex:indexPath.row];
                        [self.tableview reloadData];
                    }else{
                        [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                    }
                    
                } Failure:^(NSError * _Nonnull error) {
                    [BGProgressHUD showInfoWithMessage:@"操作失败"];
                    
                }];
        }
        

    };
    [alert showWithView:window];
}
-(void)didClicWhisperCell:(BXDynBaseTableviewCell *)cell{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    BXDynWhisperAlertView *alert = [[BXDynWhisperAlertView alloc]initWithFrame:CGRectMake(0,0, window.frame.size.width, window.frame.size.height) model:self.dataArray[indexPath.row]];
//    WS(weakSelf);
    alert.sendComment = ^(NSString * _Nonnull text, NSString * _Nonnull jsonString) {
//        NSLog(@"%@", text);
//        BXDynamicModel *dynmodel = weakSelf.dataArray[indexPath.row];
//        [HttpMakeFriendRequest SendMsgWithto_uid:dynmodel.msgdetailmodel.uid messages:text imgs:@"" video:@"" messages_type:@"1" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
//            if (!flag) {
//                [BGProgressHUD showInfoWithMessage:jsonDic[@"data"]];
//            }
//
//        } Failure:^(NSError * _Nonnull error) {
//            [BGProgressHUD showInfoWithMessage:@"消息发送失败"];
//        }];
    };
    [alert showWithView:window];
}

-(void)ClickItemAct:(NSInteger)index{
    if (index == 1) {
        BXDynCircleCategoryVC *vc = [[BXDynCircleCategoryVC alloc]init];
        vc.isOwn = YES;
        [self pushVc:vc];
    }
}
-(void)didClickOperation:(BXDynBaseTableviewCell *)cell model:(BXDynamicModel *)model type:(NSInteger)type{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    self.dataArray[indexPath.row] = cell.model;
//    [self.tableview reloadData];
}

-(void)PlaySoundAct:(BXDynSoundCell *)cell{
   
    if (_currentSoundCell == cell) {
      if ([_playSound.player isPlaying]) {
            [_playSound StopPlay];
            [_currentSoundCell StoprotateView];
        }else{
            [_playSound startPlay];
            [_currentSoundCell rotateView];
        }
    }
    
    else{
        if ([_playSound.player isPlaying]) {
            if (_currentSoundCell) {
                [_playSound StopPlay];
                [_currentSoundCell StoprotateView];
            }else{
                _currentSoundCell =cell;
                [_playSound startPlay];
                [_currentSoundCell rotateView];
            }
          }else{
              _currentSoundCell =cell;
              [_playSound startPlay];
              [_currentSoundCell rotateView];
          }
    }
    
    
    
}
-(void)getTime:(NSString *)timeString{
    BXDynSoundCell *cell = [self.tableview cellForRowAtIndexPath:_SoundcurrentIndexPath];
     cell.timeLable.text = timeString;
}
-(void)ReturnDuratime:(NSString *)timeString{
    BXDynSoundCell *cell = [self.tableview cellForRowAtIndexPath:_SoundcurrentIndexPath];
    cell.timeLable.text = timeString;
}

-(void)endPlaySound{
    BXDynSoundCell *cell = [self.tableview cellForRowAtIndexPath:_SoundcurrentIndexPath];
    [_playSound StopPlay];
    [cell StoprotateView];
}
- (void)sendChangeStatus:(NSNotification *)noti {
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
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
- (void)listDidAppear {
    [super listDidAppear];
    @weakify(self)
    [self.tableview zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        if (!self.tableview.zf_playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        } else {
            BXDynamicModel *model = self.dataArray[self.currentIndexPath.row];
//            if (IsEquallString(mediaModel.type, @"video")) {
//                BXHMovieModel *model = mediaModel.video;
                BXDynNewVideoTableViewCell *cell = (BXDynNewVideoTableViewCell *)[self.tableview cellForRowAtIndexPath:self.tableview.zf_playingIndexPath];
                if (model.isPlay) {
                    [self.player.currentPlayerManager play];

                    cell.playBtn.selected = NO;
                    
                } else {
                    [self.player.currentPlayerManager pause];

                    cell.playBtn.selected = YES;
                }
//            }
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
    [_playSound StopPlay];
    if (_SoundcurrentIndexPath) {
        BXDynSoundCell *cell = [self.tableview cellForRowAtIndexPath:_SoundcurrentIndexPath];
        cell.timeLable.text = cell.originTime;
        [cell StopPalyVoice];
    }
}


#pragma  列表播放
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    BXDynamicModel *model = self.dataArray[indexPath.row];
    if ([[NSString stringWithFormat:@"%@", model.msgdetailmodel.render_type] isEqualToString:@"3"] || [[NSString stringWithFormat:@"%@", model.msgdetailmodel.render_type] isEqualToString:@"4"] || [[NSString stringWithFormat:@"%@", model.msgdetailmodel.render_type] isEqualToString:@"20"]) {
        self.currentIndexPath = indexPath;
        [self.controlView resetControlView];
//        NSURL * proxyURL = [BXKTVHTTPCacheManager getProxyURLWithOriginalURL:[NSURL URLWithString:model.msgdetailmodel.video]];
//        NSInteger scalingMode = [model getScalingModeWithScreenHeight:__kHeight];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        NSURL *url = [NSURL URLWithString:model.msgdetailmodel.video];
//        self.player.currentPlayerManager.scalingMode = scalingMode;
        [self.controlView showCoverURLString:model.cover_url scalingMode:1];
//        [self.player playTheIndexPath:indexPath assetURL:url scrollToTop:NO];
        [self.player playTheIndexPath:indexPath assetURL:url scrollPosition:2 animated:YES];
        model.isPlay = YES;
        [CATransaction commit];
        
        BXDynNewVideoTableViewCell *cell = (BXDynNewVideoTableViewCell *)[self.tableview cellForRowAtIndexPath:indexPath];
        for (int i =0; i<self.dataArray.count; i++) {
            BXDynamicModel *model = self.dataArray[indexPath.row];
            if ([[NSString stringWithFormat:@"%@", model.msgdetailmodel.render_type] isEqualToString:@"3"] || [[NSString stringWithFormat:@"%@", model.msgdetailmodel.render_type] isEqualToString:@"4"]|| [[NSString stringWithFormat:@"%@", model.msgdetailmodel.render_type] isEqualToString:@"20"]) {
                if ([cell.model isEqual:model]) {
                    model.isPlay = YES;
                }else{
                    model.isPlay = NO;
                }
            }
        }
        self.dataArray[indexPath.row] = model;
        [self.tableview reloadData];
    }
}

-(void)playManagerModel:(BXDynamicModel *)model index:(NSIndexPath*)index button:(UIButton *)playbtn cell:(BXDynNewVideoTableViewCell *)cell{
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
-(void)playManagerCovercell:(BXDynNewVideoTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    BXDynamicModel *model = self.dataArray[indexPath.row];
    
    if (self.player.playingIndexPath != indexPath) {
        return;
    }
    if ([model.msgdetailmodel.render_type intValue] == 20) {
//        BXVideoPlayVC *vc = [[BXVideoPlayVC alloc]init];
//        BXHMovieModel *moviemodel = [BXHMovieModel new];
//        moviemodel = model.msgdetailmodel.MovieModel;
//        NSMutableArray *movieArray = [NSMutableArray arrayWithObject:moviemodel];
//        vc.videos = movieArray;
//        vc.index = 0;
//        [self pushVc:vc];
//        return;
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
@end

//
//  BXSLSearchAllVC.m
//  BXlive
//
//  Created by bxlive on 2019/3/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchAllVC.h"
#import "BXSLLiveUserCell.h"
#import "BXSLLiveRoomtCell.h"
#import "BXAttentionVideoCell.h"
//#import "BXPersonHomeVC.h"
//#import "HHMoviePlayVC.h"
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
#import "BXDynNewOnePicCell.h"
#import "BXDynNewMorePicCell.h"
#import "BXDynNewFourPicCell.h"
#import "BXKTVHTTPCacheManager.h"
#import "BXDynamicDetailsVC.h"
#import "BXDynNewVideoTableViewCell.h"
#import "BXDynGoodsCell.h"
#import "BXDynRecommendCell.h"
#import "BXDynCircleRecommendHeaderViewcell.h"
#import "BXDynSoundCell.h"
#import "BXDynShareLiveCell.h"
#import "BXDynLivingCell.h"
#import "BXDynMoreAlertView.h"
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
//#import "BXVideoPlayVC.h"
#import <Aspects/Aspects.h>
#import "SLAppInfoConst.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import <Masonry/Masonry.h>
#import "NewHttpManager.h"
#import "NewHttpRequestHuang.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"

@interface BXSLSearchAllVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,BXAttentionVideoCelllDelegate,BXDynBaseCellDelegate,playDelegate>

//@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *liveUsers;
@property (nonatomic, strong) NSMutableArray *liveRooms;
@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, strong) NSMutableArray *dynamicArray;

@property (nonatomic, copy) NSString *userMoreStatus;
@property (nonatomic, copy) NSString *liveMoreStatus;
@property (nonatomic, copy) NSString *videoMoreStatus;

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger poffset;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) BXNormalControllView *controlView;
@property (nonatomic, strong) ZFAVPlayerManager  *playerManager;

@property (nonatomic, weak) BXCommentView *commentView;


@property(nonatomic, strong)HZPhotoBrowser *browser;

@property(nonatomic, strong)DynPlayMp3Voice *playSound;
@property(nonatomic, assign)NSInteger playFlag;

@property(nonatomic, strong)BXDynSoundCell *currentSoundCell;
@property (nonatomic, strong) NSIndexPath *SoundcurrentIndexPath;

@end

@implementation BXSLSearchAllVC

- (void)getAllData {
    [NewHttpManager globalSearchWithType:@"all" keyword:_searchResultVC.searchText offset:@"" success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [self.tableView.mj_header endRefreshing];
        if(flag) {
            [self.liveUsers removeAllObjects];
            [self.liveRooms removeAllObjects];
            [self.videos removeAllObjects];
            
            NSDictionary *dataDic = jsonDic[@"data"];
            if (dataDic && [dataDic isDictionary] && dataDic.count) {
                NSDictionary *userDic = dataDic[@"user"];
                if (userDic && [userDic isDictionary]) {
                    self.userMoreStatus = userDic[@"more_status"];
                    NSDictionary *listDic = userDic[@"list"];
                    for (NSDictionary *dic in listDic) {
                        BXLiveUser *liveUser = [[BXLiveUser alloc]init];
                        [liveUser updateWithJsonDic:dic];
                        [self.liveUsers addObject:liveUser];
                    }
                }
    
                NSDictionary *liveDic = dataDic[@"live"];
                if (liveDic && [liveDic isDictionary]) {
                    self.liveMoreStatus = liveDic[@"more_status"];
                    NSDictionary *listDic = liveDic[@"list"];
                    for (NSDictionary *dic in listDic) {
                        BXSLLiveRoom *liveRoom = [[BXSLLiveRoom alloc]init];
                        [liveRoom updateWithJsonDic:dic];
                        [self.liveRooms addObject:liveRoom];
                    }
                }
                
                NSDictionary *filmDic = dataDic[@"film"];
                if (filmDic && [filmDic isDictionary]) {
                    self.videoMoreStatus = filmDic[@"more_status"];
                    NSDictionary *listDic = filmDic[@"list"];
                    for (NSDictionary *dic in listDic) {
                        BXHMovieModel *video = [[BXHMovieModel alloc]init];
                        [video updateWithJsonDic:dic];
                        [self.videos addObject:video];
                    }
                }
            }
            [self.player stopCurrentPlayingCell];
            [self.tableView reloadData];
            @weakify(self);
            /// 找到可以播放的视频并播放
            [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
                @strongify(self);
                [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
            }];
            
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}
-(void)getDynamicData{
    [HttpMakeFriendRequest SearchComplexNewDynWithpage_index:@"1" page_size:@"20" keyword:_searchResultVC.searchText Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear{
    if (self.commentView) {
        [self.commentView showInView:nil];
    }
    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        if (!self.tableView.zf_playingIndexPath) {
            [self playTheVideoAtIndexPath:self.tableView.zf_playingIndexPath scrollToTop:NO];
        }else{
            BXHMovieModel *model = self.videos[self.currentIndexPath.row];
            BXAttentionVideoCell *cell = (BXAttentionVideoCell *)[self.tableView cellForRowAtIndexPath:self.tableView.zf_playingIndexPath];
            if (model.isPlay) {
                [self.player.currentPlayerManager play];
                [cell.musicName resume];
                cell.playBtn.selected = NO;
            }else{
                [self.player.currentPlayerManager pause];
                [cell.musicName pause];
                cell.playBtn.selected = YES;
            }
        }
    }];
}

- (void)listDidDisappear {
    if ([_player.currentPlayerManager isPlaying]) {
        [_player.currentPlayerManager pause];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _liveUsers = [NSMutableArray array];
    _liveRooms = [NSMutableArray array];
    _videos = [NSMutableArray array];
    _dynamicArray = [NSMutableArray array];
    
    [self initViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needSearchAction) name:kNeedSearchNotification object:nil];
}

- (void)initViews {
    self.view.backgroundColor = PageBackgroundColor;;
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.tableView registerClass:[BXAttentionVideoCell class] forCellReuseIdentifier:@"BXAttentionVideoCell"];
    WS(ws);
    BXRefreshHeader *header = [BXRefreshHeader headerWithRefreshingBlock:^{
        [ws getAllData];
        [ws getDynamicData];
    }];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    
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
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch | ZFPlayerDisableGestureTypesSingleTap;
    self.player.playerDisapperaPercent = 1;
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self);
        [self.player.currentPlayerManager replay];
    };
    
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
    
}
- (UIView *)getHeaderViewWithSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, __kWidth, 52);
    UIImageView *imgV = [[UIImageView alloc] init];
    [headerView addSubview:imgV];
    
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(12));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(15);
    }];
    
    UILabel *textLb = [[UILabel alloc]init];
    textLb.font = SLBFont(16);
    textLb.textColor = sl_textColors;
    [headerView addSubview:textLb];
    [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.centerY.equalTo(imgV);
        make.left.equalTo(imgV.mas_right).offset(16);
    }];
    
    if (section == 1) {
        textLb.text = @"用户";
        imgV.image = CImage(@"search_result_users");
        
    } else if (section == 2) {
        textLb.text = @"直播";
        [imgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(19);
            make.height.mas_equalTo(18);
        }];
        imgV.image = CImage(@"search_result_live");
    } else if (section == 0){
        textLb.text = @"视频";
        [imgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(15);
        }];
        imgV.image = CImage(@"search_result_video");
    }
    return headerView;
}

- (UIView *)getFooterViewWithSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    footerView.tag = section;
    footerView.frame = CGRectMake(0, 0, __kWidth, 51);
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = sl_divideLineColor;
    [footerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    
    UILabel *textLb = [[UILabel alloc]init];
    textLb.font = SLPFFont(14);
    textLb.textColor = sl_textColors;
    [footerView addSubview:textLb];
    [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.bottom.mas_equalTo(lineView.mas_top).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *toIv = [[UIImageView alloc]init];
    toIv.image = CImage(@"my_icon_view");
    [footerView addSubview:toIv];
    [toIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.right.mas_equalTo(-__ScaleWidth(12));
        make.centerY.mas_equalTo(textLb);
    }];
    
    if (section == 1) {
        textLb.text = @"查看全部用户";
    } else if (section == 2) {
        textLb.text = @"查看全部直播";
    } else if (section == 0) {
        textLb.text = @"查看全部视频";
        lineView.hidden = YES;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [footerView addGestureRecognizer:tap];
    
    return footerView;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (_moreDetail) {
        NSInteger index = sender.view.tag;
        if (index == 0) {
            index = 1;
        } else if (index == 1) {
            index = 2;
        } else if (index == 2){
            index = 3;
        }
        _moreDetail(index);
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.videos.count ;
        
    } else if (section == 1) {
        return self.liveUsers.count;
        
    } else if (section == 2) {
        return self.liveRooms.count;
    }
    
    return self.liveUsers.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return __ScaleWidth(95);
    } else if (indexPath.section == 2) {
//        直播
        return __ScaleWidth(450);
    } else if (indexPath.section == 0) {
//        视频
        return [_tableView cellHeightForIndexPath:indexPath model:_videos[indexPath.row] keyPath:@"model" cellClass:[BXAttentionVideoCell class] contentViewWidth:__kWidth];
    }
    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return self.liveUsers.count ? 52 : 0.01;
    } else if (section == 2) {
        return self.liveRooms.count ? 52 : 0.01;
    } else if (section == 2) {
        return self.videos.count ? 52 : 0.01;
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (self.liveUsers.count && [self.userMoreStatus integerValue]) {
            return 51;
        } else {
            return 0.01;
        }
    } else if (section == 2) {
        if (self.liveRooms.count && [self.liveMoreStatus integerValue]) {
            return 51;
        } else {
            return 0.01;
        }
    } else if (section == 0) {
        if (self.videos.count && [self.videoMoreStatus integerValue]) {
            return 51;
        } else {
            return 0.01;
        }
    }
    
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
//        第二个分组：用户
        if (self.liveUsers.count) {
            return [self getHeaderViewWithSection:section];
        } else {
            return nil;
        }
    } else if (section == 2) {
        //        第三个分组：直播
        if (self.liveRooms.count) {
            return [self getHeaderViewWithSection:section];
        } else {
            return nil;
        }
    } else if (section == 0){
        //        第一个分组：短视频
        if (self.videos.count) {
            return [self getHeaderViewWithSection:section];
        } else {
            return nil;
        }
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        if (self.liveUsers.count && [self.userMoreStatus integerValue]) {
            return [self getFooterViewWithSection:section];
        } else {
            return nil;
        }
    } else if (section == 2) {
        if (self.liveRooms.count && [self.liveMoreStatus integerValue]) {
            return [self getFooterViewWithSection:section];;
        } else {
            return nil;
        }
    } else if (section == 0) {
        if (self.videos.count && [self.videoMoreStatus integerValue]) {
            return [self getFooterViewWithSection:section];;
        } else {
            return nil;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        BXSLLiveUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXSLLiveUserCell"];
        if (!cell) {
            cell = [[BXSLLiveUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BXSLLiveUserCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.liveUser = _liveUsers[indexPath.row];
        return cell;
    } else if (indexPath.section == 2) {
        BXSLLiveRoomtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveRoomtCell"];
        if (!cell) {
            cell = [[BXSLLiveRoomtCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LiveRoomtCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.liveRoom = _liveRooms[indexPath.row];
        return cell;
    } else if (indexPath.section == 2){
        BXAttentionVideoCell *cell = [BXAttentionVideoCell cellWithTableView:tableView];
        [cell setDelegate:self withIndexPath:indexPath];
        cell.model = _videos[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    
    return [UITableViewCell new];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        BXLiveUser *liveUser = _liveUsers[indexPath.row];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":liveUser.user_id,@"isShow":@"",@"nav":self.navigationController}];
        
//        [BXPersonHomeVC toPersonHomeWithUserId:liveUser.user_id isShow:nil nav:self.navigationController handle:nil];
    } else if (indexPath.section == 2) {
        BXSLLiveRoom *liveRoom = _liveRooms[indexPath.row];
//        [BXLocalAgreement loadUrl:liveRoom.jump fromVc:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:BXLoadURL object:nil userInfo:@{@"vc":self,@"url":liveRoom.jump}];
    } else if (indexPath.section == 0) {
        BXHMovieModel *video = _videos[indexPath.row];
        
//        BXVideoPlayVC *vc = [[BXVideoPlayVC alloc]init];
//        vc.videos = @[video];
//        [self.navigationController pushViewController:vc animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2BXVideoPlayVC object:nil userInfo:@{@"vc":self,@"movie_models":@[video],@"index":@(0)}];
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
            [ws getAllData];
            [ws getDynamicData];
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

#pragma BXAttentionVideoCell 代理
- (void)didClickLikeButtonInCell:(BXAttentionVideoCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self loadIndexPath:indexPath cell:cell];
}
#pragma 评论 0  评论列表 1
- (void)didClickcCommentButtonInCell:(BXAttentionVideoCell *)cell type:(NSInteger)type{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BXHMovieModel *videoModel = self.videos[indexPath.row];
    if (type) {
        WS(ws);
        BXSendCommentView *view = [[BXSendCommentView alloc]initWithFrame:CGRectZero array:@[]];
        view.sendComment = ^(NSString * _Nonnull text, NSString * _Nonnull jsonString) {
            [ws sendCommentWithText:text jsonString:jsonString section:indexPath.row commentModel:videoModel indexPath:indexPath];
        };
        [self.tabBarController.view addSubview:view];
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
        [commentView showInView:self.tabBarController.view];
        self.commentView = commentView;
    }
}
#pragma 回复某人
-(void)didClickcCommentButtonInCell:(BXAttentionVideoCell *)cell model:(BXCommentModel *)model{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BXHMovieModel *videoModel = self.videos[indexPath.row];
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
    [commentView showInView:self.tabBarController.view isWrite:YES topComment:model];
    self.commentView = commentView;
}
#pragma 点击播放按钮
- (void)didClickPlayButtonInCell:(BXAttentionVideoCell *)cell playButton:(UIButton *)playButton{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BXHMovieModel *videoModel = self.videos[indexPath.row];
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
    BXHMovieModel *videoModel = self.videos[indexPath.row];
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
    self.currentIndexPath = indexPath;
    BXHMovieModel *model = self.videos[indexPath.row];
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
    for (int i =0; i<self.videos.count; i++) {
        BXHMovieModel *vidoe = self.videos[i];
        if ([cell.model isEqual:vidoe]) {
            vidoe.isPlay = YES;
        }else{
            vidoe.isPlay = NO;
        }
    }
    [self.tableView reloadData];
    
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
-(void)userDetail:(NSString *)userId{
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":userId,@"isShow":@"",@"nav":[[UIApplication sharedApplication] activityViewController].navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:userId isShow:nil nav:[[UIApplication sharedApplication] activityViewController].navigationController handle:nil];
}

-(void)loadIndexPath:(NSIndexPath *)indexPath cell:(BXAttentionVideoCell *)cell{
    if (self.player.playingIndexPath != indexPath) {
        [self.player stopCurrentPlayingCell];
    }
    [self.tableView reloadData];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.player addPlayerViewToCell];
    [self didClickPlayButtonInCell:cell playButton:cell.playBtn];
}



@end

//
//  BXPagerView.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXPagerView.h"
#import "BXLocationTitleView.h"
#import "BXAttentionVideoCell.h"
//#import "BXVideoPlayVC.h"
#import "BXLocationDetailVC.h"
#import "BXNormalControllView.h"
#import "BXClickVideoViewVC.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "BXKTVHTTPCacheManager.h"
#import "BXSendCommentView.h"
#import "SLAppInfoMacro.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import "NewHttpManager.h"
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLMaskTools/SLMaskTools.h"
#import "NewHttpRequestHuang.h"
#import "SLAppInfoConst.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"

//#import "BXPersonHomeVC.h"

@interface BXPagerView () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIGestureRecognizerDelegate, BXAttentionVideoCelllDelegate>

@property (nonatomic, strong) BXLocationTitleView *headerView;
@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) BXNormalControllView *controlView;

@property (nonatomic, assign) CGFloat initialY;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, strong) ZFAVPlayerManager  *playerManager;

@end

@implementation BXPagerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame headerType:(NSInteger)headerType {
    self = [super initWithFrame:frame];
    if (self) {
        _initialY = self.y ;
        _videos = [NSMutableArray array];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        
        _headerView = [[BXLocationTitleView alloc]initWithType:headerType];
        _headerView.frame = CGRectMake(0, 0, __kWidth, 94 * (headerType + 1));
        
        _tableView = [[UITableView alloc]initWithFrame:self.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.tableHeaderView = _headerView;
        if (IOS11) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_tableView];
        
        
        _moreView = [[UIView alloc]init];
        _moreView.alpha = 0.0;
        [self addSubview:_moreView];
        [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(94);
            make.height.mas_equalTo(44 + __kBottomAddHeight);
        }];
        
        UIButton *moreBtn = [[UIButton alloc]init];
        [moreBtn setTitle:@"查看更多详情" forState:BtnNormal];
        moreBtn.titleLabel.font = CFont(14);
        [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:BtnTouchUpInside];
        [_moreView addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
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
    }
    return self;
}

- (void)setLocation:(BXLocation *)location {
    _location = location;
    _headerView.location = location;
    
    _offset = 0;
    [self getVideosByLocation];
}

- (void)open {
    CGFloat y = __kHeight - _bottomSpace;
    
    [UIView animateWithDuration:.2 animations:^{
        self.y = y;
    }];
    [self frameDidChangeWithContentOffsetY:y - _initialY duration:.2];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _moreView.backgroundColor = backgroundColor;
}

- (void)moreAction {
    [UIView animateWithDuration:.2 animations:^{
        self.y = self.initialY;
    }];
    [self frameDidChangeWithContentOffsetY:0 duration:.2];
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    if (_tableView.scrollEnabled) {
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer translationInView:recognizer.view];
        if (_tableView.contentOffset.y > 0 && point.y) {
            CGFloat contentOffsetY = _tableView.contentOffset.y - point.y;
            _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, [self changeContentOffsetY:contentOffsetY]);
            [self scrollViewDidScroll:_tableView];
        } else {
            CGFloat y = self.frame.origin.y + point.y;
            if (y <= _topSpace) {
                CGFloat contentOffsetY = _tableView.contentOffset.y - point.y;
                _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, [self changeContentOffsetY:contentOffsetY]);
                [self scrollViewDidScroll:_tableView];
                y = _topSpace;
            } else if (y > __kHeight - _bottomSpace) {
                y = __kHeight - _bottomSpace;
            }
            self.y = y;
            [self frameDidChangeWithContentOffsetY:self.y - _initialY duration:0];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateCancelled) {
        _tableView.scrollEnabled = NO;
        
        CGFloat y = self.frame.origin.y;
        if (y > _initialY) {
            if (y < __kHeight / 2) {
                y = _initialY;
            } else {
                y = __kHeight - _bottomSpace;
            }
            
            [UIView animateWithDuration:.2 animations:^{
                self.y = y;
            }];
            [self frameDidChangeWithContentOffsetY:y - _initialY duration:.2];
        } else if (y <= _topSpace) {
            if (_videos.count) {
                _tableView.scrollEnabled = YES;
            }
        }
        
        CGFloat maxContentOffsetY = _tableView.contentSize.height - _tableView.height;
        if (maxContentOffsetY > 0 && _tableView.contentOffset.y > maxContentOffsetY) {
            [_tableView setContentOffset:CGPointMake(_tableView.contentOffset.x, maxContentOffsetY) animated:YES];
        }
    }
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

- (void)frameDidChangeWithContentOffsetY:(CGFloat)contentOffsetY duration:(NSTimeInterval)duration {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerViewFrameDidChangeWithContentOffsetY: duration:)]) {
        [self.delegate pagerViewFrameDidChangeWithContentOffsetY:contentOffsetY duration:duration];
    }
    
    if (duration) {
        [UIView animateWithDuration:duration animations:^{
            self.moreView.alpha = [self getMoreViewAlphaWithContentOffsetY:contentOffsetY];
        }];
    } else {
        self.moreView.alpha = [self getMoreViewAlphaWithContentOffsetY:contentOffsetY];
    }
}

- (CGFloat)getMoreViewAlphaWithContentOffsetY:(CGFloat)contentOffsetY {
    if (contentOffsetY > 0) {
        CGFloat height = __kHeight - _initialY - _bottomSpace;
        if (contentOffsetY > height / 2) {
            return contentOffsetY * 2 / height - 1;
        }
    }
    return 0;
}

- (CGFloat)changeContentOffsetY:(CGFloat)contentOffsetY {
    if (contentOffsetY < 0) {
        contentOffsetY = 0;
    } else {
        CGFloat maxContentOffsetY = _tableView.contentSize.height - _tableView.height;
        if (_videos.count) {
            maxContentOffsetY += 60;
        }
        if (maxContentOffsetY > 0) {
            contentOffsetY = MIN(contentOffsetY, maxContentOffsetY);
        } else {
            contentOffsetY = 0;
        }
    }
    return contentOffsetY;
}

- (void)getVideosByLocation {
    [NewHttpManager videosByLocationWithLocationId:_location.location_id offset:[NSString stringWithFormat:@"%ld",_offset] success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            if (!self.offset) {
                [self.videos removeAllObjects];
                self.tableView.isNoMoreData = NO;
            }
            NSArray *dataArray = jsonDic[@"data"];
            if (dataArray && dataArray.count) {
                for (NSDictionary *dic in dataArray) {
                    BXHMovieModel *model = [[BXHMovieModel alloc] init];
                    [model updateWithJsonDic:dic];
                    [self.videos addObject:model];
                }
            } else {
                self.tableView.isNoMoreData = YES;
            }
            [self.tableView reloadData];
            
            @weakify(self);
            /// 找到可以播放的视频并播放
            [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
                @strongify(self);
                [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
            }];
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
    } failure:^(NSError *error) {
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}

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
            [model processAttributedStringWithAttaties];
            model.toPersonHome = ^(NSString * _Nonnull userId) {
                [ws userDetail:userId];
            };
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
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
    [self.player addPlayerViewToCell];
    [self didClickPlayButtonInCell:cell playButton:cell.playBtn];
}


#pragma - mark UITableView 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXHMovieModel *model = _videos[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[BXAttentionVideoCell class] contentViewWidth:SCREEN_WIDTH];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videos.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXAttentionVideoCell *cell = [BXAttentionVideoCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.model = _videos[indexPath.row];
    [cell setDelegate:self withIndexPath:indexPath];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BXHMovieModel *video = _videos[indexPath.row];
//    BXVideoPlayVC *vc = [[BXVideoPlayVC alloc]init];
//    vc.videos = @[video];
//    [self.vc.navigationController pushViewController:vc animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2BXVideoPlayVC object:nil userInfo:@{@"vc":self.vc,@"movie_models":@[video],@"index":@(0)}];
    
}

#pragma - mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.scrollEnabled && scrollView.contentOffset.y <= 0) {
        scrollView.scrollEnabled = NO;
    }
    [scrollView zf_scrollViewDidScroll];
    
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self];
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
            _offset = _videos.count;
            [self getVideosByLocation];
        }
    }
}

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
            [ws getVideosByLocation];
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

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
}

- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView {
    scrollView.scrollEnabled = NO;
}

#pragma - mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma - mark BXAttentionVideoCelllDelegate
- (void)didClickLikeButtonInCell:(BXAttentionVideoCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self loadIndexPath:indexPath cell:cell];
    
}

- (void)didClickcCommentButtonInCell:(BXAttentionVideoCell *)cell type:(NSInteger)type{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BXHMovieModel *videoModel = self.videos[indexPath.row];
    if (type) {
        WS(ws);
        BXSendCommentView *view = [[BXSendCommentView alloc]initWithFrame:CGRectZero array:@[]];
        view.sendComment = ^(NSString * _Nonnull text, NSString * _Nonnull jsonString) {
            [ws sendCommentWithText:text jsonString:jsonString section:indexPath.row commentModel:videoModel indexPath:indexPath];
        };
        [self.vc.view addSubview:view];
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
        [commentView showInView:self.vc.view];
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
    [commentView showInView:self.vc.view isWrite:YES topComment:model];
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
    [self.vc presentViewController:vc animated:YES completion:nil];
}

@end



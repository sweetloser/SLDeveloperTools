//
//  BXDynTopicCircleVideoVC.m
//  BXlive
//
//  Created by mac on 2020/8/15.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynTopicCircleVideoVC.h"
#import "BXDynPlayVideoCell.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "BXPlayerControlView.h"
#import "BXAVPlayerManager.h"
#import "BXKTVHTTPCacheManager.h"
#import "BXVideoDescribeResponder.h"
//#import "BXVideoGiftManager.h"
#import "TimeHelper.h"
#import "BXDynamicModel.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>

@interface BXDynTopicCircleVideoVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) BXPlayerControlView *controlView;
@property (strong, nonatomic) ZFPlayerController *player;
@property (strong, nonatomic) BXHMovieModel *currentVideo;
@property (assign, nonatomic) ZFPlayerPlaybackState lastPlayType;

@end

@implementation BXDynTopicCircleVideoVC


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_lastPlayType == ZFPlayerPlayStatePlaying) {
        [_player.currentPlayerManager play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _lastPlayType = _player.currentPlayerManager.playState;
    [_player.currentPlayerManager pause];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([_player.currentPlayerManager isPlaying]) {
        _lastPlayType = _player.currentPlayerManager.playState;
        [_player.currentPlayerManager pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = PageBackgroundColor;
    self.fd_prefersNavigationBarHidden = YES;

    [self initViews];
    [self initPlayer];

    
    if (_videos && _videos.count) {
        [self autoPlayVideo];
    } else if (!IsNilString(_videoId)) {

    }

}

- (void)autoPlayVideo {
    if (_videos.count == 1 || _index < 0) {
        _index = 0;
    } else if (_index >= _videos.count) {
        _index = _videos.count - 1;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_index inSection:0];
   [self playTheIndexPath:indexPath type:0];
    
}

- (void)initViews {
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.pagingEnabled = YES;
    if (self.videos.count <= 1) {
        self.tableView.scrollEnabled = NO;
    }
    @weakify(self);
    _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        [self playTheIndexPath:indexPath type:1];
    };
    if (IOS11) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (_videos) {
        _videos = [NSArray arrayWithArray:_videos];
        if (_videos.count > 1) {
            _tableView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
            _tableView.isNoMoreData = YES;
        }
    } else {
        _tableView.bounces = NO;
    }
    [self.view addSubview:_tableView];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:CImage(@"icon_quit_white") forState:BtnNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:BtnTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.left.mas_equalTo(11);
        make.top.mas_equalTo(20 + __kTopAddHeight + 6);
    }];
}

- (void)initPlayer {
    
    @weakify(self);
    ZFAVPlayerManager *playerManager = [[BXAVPlayerManager alloc] initWithTpye:BXAVPlayerManagerVideoPlayOthers];
    _controlView = [[BXPlayerControlView alloc]initWithFrame:CGRectZero type:1];
    _player = [ZFPlayerController playerWithScrollView:_tableView playerManager:playerManager containerViewTag:101];
    _player.controlView = _controlView;
    _player.allowOrentitaionRotation = NO;
    _player.playerDisapperaPercent = 1.0;
    _player.WWANAutoPlay = YES;
    _player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self);
        [self replayCurrentVideo];
    };
    
}


- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//type 0：自动播放 1：t相同视频不播放
- (void)playTheIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type{
    if (_videos.count) {
        BXDynamicModel *model = _videos[indexPath.row];
        BXHMovieModel *video = [BXHMovieModel new];
        video.video_url = model.msgdetailmodel.video;
        video.cover_url = model.msgdetailmodel.cover_url;
        if (type == 1) {
            if (_currentVideo.video_url && [video.video_url isEqual:_currentVideo.video_url]) {
                return;
            }
        }
        if (_videos.count > indexPath.row + 1) {
            BXDynamicModel *model = _videos[indexPath.row + 1];
            BXHMovieModel *nextVideo = [BXHMovieModel new];
            nextVideo.video_url = model.msgdetailmodel.video;
            nextVideo.cover_url = model.msgdetailmodel.cover_url;
            [self preloadTheNextVideoWithVideoUrl:nextVideo.video_url];
            [self preloadTheNextVideoWithVideoUrl:nextVideo.cover_url];
        }
        if (indexPath.row) {
            BXDynamicModel *model = _videos[indexPath.row - 1];
            BXHMovieModel *preVideo = [BXHMovieModel new];
            preVideo.video_url = model.msgdetailmodel.video;
            preVideo.cover_url = model.msgdetailmodel.cover_url;
            [self preloadTheNextVideoWithVideoUrl:preVideo.video_url];
        }
        
        _currentVideo = video;
        
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
        NSURL * proxyURL = [BXKTVHTTPCacheManager getProxyURLWithOriginalURL:[NSURL URLWithString:_currentVideo.video_url]];
        NSInteger scalingMode = [video getScalingModeWithScreenHeight:__kHeight];
    
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _player.currentPlayerManager.scalingMode = scalingMode;
        [_controlView showCoverURL:_currentVideo.cover_url scalingMode:scalingMode];
        _controlView.video = _currentVideo;
        NSLog(@"$$$$$$$  %@   $$$$$$",_currentVideo.video_url);
        [_player playTheIndexPath:indexPath assetURL:proxyURL scrollToTop:NO];
        [CATransaction commit];

        
    } else {
        [_player.currentPlayerManager stop];
    }
}

- (void)replayCurrentVideo {
    BOOL isReplay = YES;
    CGFloat timeSp = [TimeHelper getFloatTimeSp];
    CGFloat replayTimeSp = _currentVideo.replayTimeSp;
    if (replayTimeSp > 0) {
        CGFloat totalTime = self.player.totalTime;
        if (totalTime > 0) {
            CGFloat minTime = totalTime;
            if (totalTime > 12.0) {//有拖动进度条
                minTime = 1.0;//最小.3 + 暂停及拖动时间
            }
            if (timeSp - replayTimeSp < minTime) {
                isReplay = NO;
            }
        }
    }
    if (isReplay) {
        _currentVideo.replayTimeSp = timeSp;
        
        _controlView.video = _currentVideo;
        [self.player.currentPlayerManager replay];
    }
}


- (void)preloadTheNextVideoWithVideoUrl:(NSString *)videoUrl {
    NSURL * proxyURL = [BXKTVHTTPCacheManager getProxyURLWithOriginalURL:[NSURL URLWithString:videoUrl]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:proxyURL];
    [request setValue:@"bytes" forHTTPHeaderField:@"Accept-Ranges"];
    [request setValue:@"bytes=0-2000000" forHTTPHeaderField:@"Range"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
        [task resume];
    });
}

- (void)preloadTheNextVideoCoverWithCoverUrl:(NSString *)coverUrl {
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    [manager requestImageWithURL:[NSURL URLWithString:coverUrl] options:YYWebImageOptionIgnoreImageDecoding progress:nil transform:nil completion:nil];
}



- (void)dealloc {
    if (_player) {
        [_player stop];
        _player = nil;
        
        [_controlView removeFromSuperview];
        _controlView = nil;
    }
}

#pragma - mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXDynPlayVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[BXDynPlayVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" type:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.moreType = 1;

    BXDynamicModel *model = _videos[indexPath.row];
    BXHMovieModel *preVideo = [BXHMovieModel new];
    preVideo.video_url = model.msgdetailmodel.video;
    preVideo.cover_url = model.msgdetailmodel.cover_url;
    [BXVideoDescribeResponder processVideoDescribeAttri:preVideo];
    cell.video = preVideo;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return __kHeight;
}

#pragma - mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
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




@end

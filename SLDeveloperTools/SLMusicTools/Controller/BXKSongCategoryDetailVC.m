//
//  BXKSongCategoryDetailVC.m
//  BXlive
//
//  Created by bxlive on 2019/6/13.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXKSongCategoryDetailVC.h"
#import "BXMusicModel.h"
#import "BXKSongTableViewCell.h"
#import "BXMusicManager.h"
#import "SLMaskTools.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../../SLMacro/SLMacro.h"
#import <YYWebImage/YYWebImage.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "../../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import "../../SLAppInfo/SLAppInfo.h"
#import <YYCategories/YYCategories.h>
#import "../../SLCategory/SLCategory.h"
#import "SLMusicToolsMacro.h"
#import "../../SLWidget/SLBaseEmptyVC/SLEmptyHeader.h"


@interface BXKSongCategoryDetailVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) NSInteger offSet;
@property (nonatomic , strong) BXMusicModel * currentModel;
@end

@implementation BXKSongCategoryDetailVC

- (NSString *)title{
    return self.titleString;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:WhiteBgTitleColor, NSFontAttributeName:CBFont(20)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:CHH_RGBCOLOR(238, 240, 240, 1.0)]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:MainTitleColor, NSFontAttributeName:CBFont(20)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:PageBackgroundColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:PageBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    [[BXMusicManager sharedManager] stopPlay];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _offSet = 0;
    [BGProgressHUD showLoadingWithMessage:nil];
    [self initTableView];
    [self addObserver];
}

- (void)addObserver{
    // app进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)initTableView{
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    [self.tableView endRefreshingWithNoMoreData];
    
    [self TableDragWithDown];
}
- (void)TableDragWithDown {
    self.offSet = 0;
    [self createData];
}

- (void)loadMoreData
{
    self.offSet = self.dataArray.count;
    [self createData];
}

- (void)createData{
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]MusicMusicsByCategoryListWithCategoryId:self.categoryId Offset:[NSString stringWithFormat:@"%ld",_offSet] length:@"20" Success:^(id responseObject) {
        [BGProgressHUD hidden];
        if ([responseObject[@"code"] integerValue]==0) {
            if (!self.offSet) {
                [self.dataArray removeAllObjects];
                self.tableView.isNoMoreData = NO;
            }
            NSArray *recommArray = responseObject[@"data"];
            if (recommArray.count) {
                for (NSDictionary *cdict in recommArray) {
                    BXMusicModel *model = [BXMusicModel objectWithDictionary:cdict];
                    [self.dataArray addObject:model];
                }
            }else{
                self.tableView.isNoMoreData = YES;
            }
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        [BGProgressHUD hidden];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}

#pragma mark - UITableViewDelegate/Datasouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    BXKSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BXKSongTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = self.dataArray[indexPath.row];
    BXMusicModel *model = self.dataArray[indexPath.row];
    @weakify(self);
    [cell setMusicCollectBlock:^() {
        @strongify(self);
        if (![NewHttpManager isNetWorkConnectionAvailable]) {
            return ;
        }
        [NewHttpManager collectionAddWithTargetId:model.music_id type:@"music" success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
            if (flag) {
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                NSDictionary *dataDic = jsonDic[@"data"];
                NSString *is_collect = [NSString stringWithFormat:@"%@",dataDic[@"status"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidCollectNotification object:nil userInfo:@{@"musicId":model.music_id, @"is_collect":is_collect, @"type":@"music"}];
                model.is_collect = is_collect;
                [self.tableView reloadData];
            } else {
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            [BGProgressHUD showInfoWithMessage:@"操作失败"];
        }];
        
    }];
    
    [cell setMusicUseBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidUseMusicNotification object:nil userInfo:@{@"model":model}];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![NewHttpManager isNetWorkConnectionAvailable]) {
        return ;
    }
    BXKSongTableViewCell *cell = (BXKSongTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    BXMusicModel *themodel = self.dataArray[indexPath.row];
    self.currentModel = themodel;
    for (BXMusicModel *model in self.dataArray) {
        if ([model isEqual:themodel]) {
            if (themodel.isSelect==NO) {
                themodel.isSelect = YES;
                cell.useBtn.hidden = NO;
                cell.playPauseImageView.image = [UIImage imageNamed:@"icon_music_pause"];
                [UIView animateWithDuration:0.5 animations:^{
                    cell.musicLabel.frame = CGRectMake(80, 15, SCREEN_WIDTH-80-55-85, 19);
                    cell.nameLabel.frame = CGRectMake(80, 38, SCREEN_WIDTH-80-55-85, 16);
                    cell.collectBtn.frame = CGRectMake(SCREEN_WIDTH-39-85, 23.5, 23, 21);
                    cell.useBtn.frame = CGRectMake(SCREEN_WIDTH-11-85+15, 18, 65, 32);
                }];
                [[BXMusicManager sharedManager] play:model.link];
                [[BXMusicManager sharedManager] setPlayerFinish:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":model}];
                }];
            }else{
                themodel.isSelect = NO;
                cell.useBtn.hidden = YES;
                cell.playPauseImageView.image = [UIImage imageNamed:@"icon_music_play"];
                cell.musicLabel.frame = CGRectMake(80, 15, SCREEN_WIDTH-80-55, 19);
                cell.nameLabel.frame = CGRectMake(80, 38, SCREEN_WIDTH-80-55, 16);
                cell.collectBtn.frame = CGRectMake(SCREEN_WIDTH-39, 23.5, 23, 21);
                cell.useBtn.frame = CGRectMake(SCREEN_WIDTH, 18, 65, 32);
                [[BXMusicManager sharedManager]pausePlay];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectMusicNotification" object:nil userInfo:@{@"model":themodel}];
}

#pragma mark - app进入后台停止播放
- (void)applicationEnterBackground{
    [[BXMusicManager sharedManager] pausePlay];
    if (self.currentModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
    }
}

/*
 #pragma mark - 耳机插入和拔掉
 //耳机插入、拔出事件
 - (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
 NSDictionary *interuptionDict = notification.userInfo;
 
 NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
 
 switch (routeChangeReason) {
 
 case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
 //耳机插入
 break;
 
 case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
 //耳机拔出
 if (self.currentModel) {
 [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
 }
 break;
 
 case AVAudioSessionRouteChangeReasonCategoryChange:
 // called at start - also when other audio wants to play
 
 break;
 }
 }
 
 #pragma mark - 来电中断
 - (void)handleInterruption:(NSNotification*)notification {
 if (self.currentModel) {
 [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
 }
 }
 */
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

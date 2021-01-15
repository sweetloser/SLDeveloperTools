//
//  BXKSongVC.m
//  BXlive
//
//  Created by bxlive on 2019/6/11.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXKSongVC.h"
#import "BXKSongCell.h"
#import "BXMusicCategoryModel.h"
#import "BXMusicManager.h"
#import "BXMusicDownloadManager.h"
#import "BXKSongCategoryVC.h"
#import "BXKSongCategoryDetailVC.h"
#import "BXKSongRecommedDetailVC.h"
#import "BXKSongUseListVC.h"
#import "BXKSongLikeSongVC.h"
#import "BXKSongSearchVC.h"
#import "SLMaskTools.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "SLMusicToolsMacro.h"
#import "../../SLAppInfo/SLAppInfo.h"
#import "../../SLMacro/SLMacro.h"
#import "../../SLCategory/SLCategory.h"


@interface BXKSongVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DSKSongSearchVCDelegate>

@property(nonatomic,strong)UITableView *tableView;
/** 搜索文本 */
@property (nonatomic , strong) UITextField * textField;
@property (nonatomic , strong) NSMutableArray * homeListArray;

@property (nonatomic , strong) BXMusicModel * currentModel;

@property (nonatomic, strong) AVAudioSessionCategory category;

@property (nonatomic, strong) NSString *categoryString;

@property (nonatomic, strong) NSString *recommendString;

@end

@implementation BXKSongVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(NSMutableArray *)homeListArray{
    if (!_homeListArray) {
        _homeListArray = [NSMutableArray array];
    }
    return _homeListArray;
}

- (void)dealloc {
    [[BXMusicManager sharedManager] stopPlay];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:_category error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    
    //通知
    [self addObserver];
    [self initNavView];
    [self initTableView];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    _category = audioSession.category;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayPause:) name:kSelectMusicPlayPauseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUseMusic:) name:kDidUseMusicNotification object:nil];
    //耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    //来电中断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    // app进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - notification
#pragma mark - 选中播放音乐
- (void)didPlayPause:(NSNotification *)notic{
    NSDictionary *info = notic.userInfo;
    BXMusicModel *model = info[@"model"];
    self.currentModel = model;
    if (model.isSelect) {
        [[BXMusicManager sharedManager] play:model.link];
        [[BXMusicManager sharedManager] setPlayerFinish:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":model}];
        }];
    }else{
        [[BXMusicManager sharedManager] pausePlay];
    }
}

#pragma mark - 使用音乐
- (void)didUseMusic:(NSNotification *)notic{
    NSDictionary *info = notic.userInfo;
    BXMusicModel *model = info[@"model"];
    [BXKSongVC downloadMusic:model isDownLyric:YES completion:^(BXMusicModel * _Nonnull music) {
        [[NewHttpRequestHuang sharedNewHttpRequestHuang]MusicReportUseMusicWithMusicID:model.music_id Success:^(id responseObject) {
        } Failure:^(NSError *error) {
        }];
        if (self.musicAndLyricPathBlock) {
            self.musicAndLyricPathBlock(model);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

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

#pragma mark - app进入后台停止播放
- (void)applicationEnterBackground{
    [[BXMusicManager sharedManager] pausePlay];
    if (self.currentModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
    }
}

#pragma mark - app从后台进入前台
- (void)applicationBecomeActive{
    
}

#pragma mark - 来电中断
- (void)handleInterruption:(NSNotification*)notification {
    [[BXMusicManager sharedManager] pausePlay];
    if (self.currentModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
    }
}

#pragma mark - 创建自定义导航栏
- (void)initNavView {
    self.view.backgroundColor = [UIColor whiteColor];
    //自定义导航栏
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 114+__kTopAddHeight)];
    [self.view addSubview:navView];
    //删除按钮&标题
    UIView *dtView = [[UIView alloc]initWithFrame:CGRectMake(0, 20+__kTopAddHeight, SCREEN_WIDTH, 50)];
    dtView.backgroundColor = [UIColor whiteColor];
    [navView addSubview:dtView];
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 13, 24, 24)];
    [deleteBtn setImage:[UIImage imageNamed:@"pop_icon_guanbi"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [dtView addSubview:deleteBtn];
    UILabel *titleLabel = [UILabel initWithFrame:CGRectZero text:@"K歌" size:16 color:WhiteBgTitleColor alignment:NSTextAlignmentCenter lines:1 shadowColor:[UIColor clearColor]];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [dtView addSubview:titleLabel];
    titleLabel.sd_layout.centerXEqualToView(dtView).centerYEqualToView(dtView).widthIs(150).heightIs(50);
    //搜索
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 70+__kTopAddHeight, SCREEN_WIDTH, 44)];
    [self.view addSubview:searchView];
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 39, 34)];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuo_icon_sousuo"]];
    iconIv.contentMode = UIViewContentModeCenter;
    iconIv.frame = CGRectMake(16, 9, 16, 16);
    [leftview addSubview:iconIv];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(16, 5, SCREEN_WIDTH-32, 34)];
    textField.backgroundColor = CHHCOLOR_D(0xF4F8F8);
    textField.layer.cornerRadius = 17;
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = CHHCOLOR_D(0xDFE9E9).CGColor;
    textField.font = CFont(14);
    textField.leftView = leftview;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索歌曲名称" attributes:@{NSForegroundColorAttributeName:CHHCOLOR_D(0xA8AFAF)}];
    [searchView addSubview:textField];
    _textField = textField;
}

#pragma mark - 创建表单视图
- (void)initTableView{
    //表单头视图
    //已唱歌曲.曲目分类.喜欢的歌
    UIView *tableheadView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 92)];
    tableheadView.backgroundColor = [UIColor whiteColor];
    tableheadView.clipsToBounds = YES;
    
    NSArray *iconArray = @[@"live_ksong_alreadySong",@"live_ksong_category",@"live_ksong_like"];
    NSArray *titleArray = @[@"已唱歌曲",@"曲目分类",@"喜欢的歌"];
    for (int i=0; i<iconArray.count; i++) {
        UIButton *headButton = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH/3.0*i, 4, SCREEN_WIDTH/3.0, 88) Title:titleArray[i] Font:CFont(12) Color:[UIColor sl_colorWithHex:0x4A4F4F] Image:[UIImage imageNamed:iconArray[i]] Target:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside ImagePosition:2 spacing:14];
        headButton.tag = i;
        [tableheadView addSubview:headButton];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.tableHeaderView = tableheadView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[BXKSongCell class] forCellReuseIdentifier:@"BXKSongCell"];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(114+__kTopAddHeight, 0, 0 + __kBottomAddHeight, 0));
    self.tableView.hidden = YES;
    
    [self loadHomeData];
}

- (void)loadHomeData{
    [BGProgressHUD showLoadingWithMessage:nil];
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]RoomMusicHomeWithSuccess:^(id responseObject) {
        [BGProgressHUD hidden];
        self.tableView.hidden = NO;
        if([responseObject[@"code"] integerValue] == 0)
        {
            NSArray *itemArray = responseObject[@"data"];
            if (itemArray && [itemArray isArray] && itemArray.count) {
                for (NSDictionary *cdict in itemArray) {
                    BXMusicCategoryModel *model = [[BXMusicCategoryModel alloc]init];
                    [model updateWithJsonDic:cdict];
                    [self.homeListArray addObject:model];
                }
            }
        } else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        [BGProgressHUD hidden];
    }];
}

#pragma mark - 关闭
- (void)deleteBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 已唱歌曲,曲目分类,喜欢的歌
- (void)headButtonClick:(UIButton *)btn{
    if (btn.tag==0) {
        [[BXMusicManager sharedManager] stopPlay];
        if (self.currentModel) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
        }
        BXKSongUseListVC *kulvc = [[BXKSongUseListVC alloc]init];
        [self.navigationController pushViewController:kulvc animated:YES];
    }else if (btn.tag == 1){
        [[BXMusicManager sharedManager] stopPlay];
        if (self.currentModel) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
        }
        BXKSongCategoryVC *kscvc = [[BXKSongCategoryVC alloc]init];
        [self.navigationController pushViewController:kscvc animated:YES];
    }else{
        [[BXMusicManager sharedManager] stopPlay];
        if (self.currentModel) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
        }
        BXKSongLikeSongVC *kslcvc = [[BXKSongLikeSongVC alloc]init];
        [self.navigationController pushViewController:kslcvc animated:YES];
    }
}

#pragma - mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[BXMusicManager sharedManager] stopPlay];
    if (self.currentModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
    }
    BXKSongSearchVC *msvc = [[BXKSongSearchVC alloc]init];
    msvc.delegate = self;
    msvc.view.frame = self.view.frame;
    [self.view addSubview:msvc.view];
    [self addChildViewController:msvc];
    return NO;
}

#pragma - mark - DSKSongSearchVCDelegate
- (void)deleteAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancelSearch {
    [UIView animateWithDuration:.5 animations:^{
        self.textField.width = SCREEN_WIDTH-32;
    }];
}

#pragma - mark UITableViewDelegate/DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.homeListArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 204;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BXKSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXKSongCell"];
    BXMusicCategoryModel *categoryModel = self.homeListArray[indexPath.section];
    cell.dataArray = categoryModel.itemArray;
    [cell setLikeSongBlock:^(NSInteger index) {
        if (![NewHttpManager isNetWorkConnectionAvailable]) {
            return ;
        }
        BXMusicModel *model = categoryModel.itemArray[index];
        [NewHttpManager collectionAddWithTargetId:model.music_id type:@"music" success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
            if (flag) {
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                NSDictionary *dataDic = jsonDic[@"data"];
                NSString *is_collect = [NSString stringWithFormat:@"%@",dataDic[@"status"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidCollectNotification object:nil userInfo:@{@"musicId":model.music_id, @"is_collect":is_collect, @"type":@"music"}];
            } else {
                [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
            }
        } failure:^(NSError *error) {
            [BGProgressHUD showInfoWithMessage:@"操作失败"];
        }];
    }];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 52;
    }
    return 42;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
        headView.backgroundColor = [UIColor whiteColor];
        UIView *fengeView = [[UIView alloc]initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH-32, 1)];
        fengeView.backgroundColor = [UIColor sl_colorWithHex:0xDFE9E9];
        [headView addSubview:fengeView];
        BXMusicCategoryModel *categoryModel = self.homeListArray[section];
        UILabel *titleLabel = [UILabel initWithFrame:CGRectMake(16, 26, 80, 20) text:categoryModel.title size:16 color:WhiteBgTitleColor alignment:NSTextAlignmentLeft lines:1 shadowColor:[UIColor clearColor]];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [headView addSubview:titleLabel];
        UIButton *lookAllBtn = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-16-50, 22, 50, 30) Title:@"查看全部" Font:CFont(12) Color:[UIColor sl_colorWithHex:0x7A8181] Image:nil Target:self action:@selector(lookAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        lookAllBtn.tag = section;
        [headView addSubview:lookAllBtn];
        return headView;
    }else{
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
        headView.backgroundColor = [UIColor whiteColor];
        BXMusicCategoryModel *categoryModel = self.homeListArray[section];
        UILabel *titleLabel = [UILabel initWithFrame:CGRectMake(16, 16, 80, 20) text:categoryModel.title size:16 color:WhiteBgTitleColor alignment:NSTextAlignmentLeft lines:1 shadowColor:[UIColor clearColor]];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [headView addSubview:titleLabel];
        UIButton *lookAllBtn = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-16-50, 12, 50, 30) Title:@"查看全部" Font:CFont(12) Color:[UIColor sl_colorWithHex:0x7A8181] Image:nil Target:self action:@selector(lookAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        lookAllBtn.tag = section;
        [headView addSubview:lookAllBtn];
        return headView;
    }
    return nil;
}

#pragma mark - 查看全部
- (void)lookAllBtn:(UIButton *)btn{
    [[BXMusicManager sharedManager] stopPlay];
    if (self.currentModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
    }
    if (btn.tag == 0) {
        //推荐
        BXKSongRecommedDetailVC *ksrdvc = [[BXKSongRecommedDetailVC alloc]init];
        [self.navigationController pushViewController:ksrdvc animated:YES];
    }else{
        BXMusicCategoryModel *categoryModel = self.homeListArray[btn.tag];
        BXKSongCategoryDetailVC *kscdvc = [[BXKSongCategoryDetailVC alloc]init];
        kscdvc.categoryId = categoryModel.category_id;
        kscdvc.titleString = categoryModel.title;
        [self.navigationController pushViewController:kscdvc animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = 52;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
        scrollView.contentInset=UIEdgeInsetsMake(-scrollView.contentOffset.y,0,0,0);
    }else if(scrollView.contentOffset.y>=sectionHeaderHeight){
        scrollView.contentInset=UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
    }
}

+ (void)downloadMusic:(BXMusicModel *)music isDownLyric:(BOOL)lyric completion:(void (^)(BXMusicModel *music))completion{
    [BXMusicDownloadManager downloadMusic:music isDownLyric:(BOOL)lyric completion:^(BXMusicModel * _Nonnull music) {
        if (completion) {
            completion(music);
        }
    }];
}

@end

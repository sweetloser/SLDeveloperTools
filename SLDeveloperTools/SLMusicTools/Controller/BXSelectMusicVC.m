//
//  BXSelectMusicVC.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSelectMusicVC.h"
#import "BXMusicCategoryModel.h"
#import "BXMusicRecommendCell.h"
#import "BXMusicCategoryCell.h"
#import "BXMusicHomeListCell.h"
#import "BXMusicTableViewCell.h"
#import "BXMusicSearchVC.h"//搜索
#import "BXBannerView.h"
#import "BXBannerModel.h"
#import "BXMusicCategoryVC.h"//音乐类别
#import "BXMusicCategoryDetailVC.h"//音乐类别详情
#import "BXMusicRecommedDeailVC.h"//推荐详情
#import "FilePathHelper.h"
#import "BXMusicManager.h"
#import "BXMusicDownloadManager.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <YYWebImage/YYWebImage.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <YYCategories/YYCategories.h>
#import "SLMusicToolsMacro.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

#define lunboHeight SCREEN_WIDTH*90/343.0

@interface BXSelectMusicVC ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate,
    DSMusicSearchVCDelegate,
    DSMusicCategoryCellDelegate,
    DZNEmptyDataSetDelegate,
    DZNEmptyDataSetSource
>

@property(nonatomic,strong)UITableView *tableView;
/** 轮播 */
@property(nonatomic,strong)NSMutableArray *bannerArray;
/** 推荐 */
@property(nonatomic,strong)NSMutableArray *recommendArray;
/** 歌单 */
@property(nonatomic,strong)NSMutableArray *categoryArray;
/** 主页列表 */
@property (nonatomic , strong) NSMutableArray * homeListArray;
/** 我的收藏 */
@property(nonatomic,strong)NSMutableArray *collectionArray;
/** 搜索文本 */
@property (nonatomic , strong) UITextField * textField;
/** 轮播图 */
@property (nonatomic , strong) BXBannerView * bannerView;
/** 根据type创建不同的cell,1.发现音乐,2.我的收藏 */
@property (nonatomic , strong) NSString * type;
/** 发现音乐 */
@property (nonatomic , strong) UIButton * findMusicBtn;
/** 我的收藏 */
@property (nonatomic , strong) UIButton * myCollectBtn;

@property (nonatomic , strong) BXMusicModel * currentModel;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic , strong) AVPlayer * player;
@property (nonatomic , strong) AVPlayerItem * songItem;

@property (nonatomic, strong) AVAudioSessionCategory category;


@property (nonatomic, strong) NSString *categoryString;
@property (nonatomic, strong) NSString *recommendString;

@end

@implementation BXSelectMusicVC
#pragma mark - 懒加载
#pragma mark - 轮播图数组
-(NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
#pragma mark - 音乐推荐数组
-(NSMutableArray *)recommendArray{
    if (!_recommendArray) {
        _recommendArray = [NSMutableArray array];
    }
    return _recommendArray;
}
#pragma mark - 音乐类别数组
-(NSMutableArray *)categoryArray{
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray array];
    }
    return _categoryArray;
}
#pragma mark - 音乐主页底部数组
-(NSMutableArray *)homeListArray{
    if (!_homeListArray) {
        _homeListArray = [NSMutableArray array];
    }
    return _homeListArray;
}
#pragma mark - 我的收藏数组
-(NSMutableArray *)collectionArray{
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}


#pragma mark - 生命周期
- (void)dealloc {
    [[BXMusicManager sharedManager] stopPlay];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:_category error:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:WhiteBgTitleColor, NSFontAttributeName:CBFont(20)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:CHH_RGBCOLOR(238, 240, 240, 1.0)]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:MainTitleColor, NSFontAttributeName:CBFont(20)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:PageBackgroundColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:PageBackgroundColor] forBarMetrics:UIBarMetricsDefault];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.type = @"1";
    self.offset = 0;
    //通知
    [self addObserver];
    //创建自定义导航栏
    [self initNavView];
    //创建表单视图
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
//选中播放音乐
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
    [BXSelectMusicVC downloadMusic:model completion:^(BXMusicModel * _Nonnull music) {
        if (self.musicPathBlock) {
            self.musicPathBlock(model);
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
    UILabel *titleLabel = [UILabel initWithFrame:CGRectZero text:@"选择音乐" size:16 color:WhiteBgTitleColor alignment:NSTextAlignmentCenter lines:1 shadowColor:[UIColor clearColor]];
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
    UIView *tableheadView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 68+lunboHeight)];
    tableheadView.backgroundColor = [UIColor whiteColor];
    tableheadView.clipsToBounds = YES;
    WS(ws);
    //轮播图
    _bannerView = [[BXBannerView alloc]initWithFrame:CGRectMake(16, 12, SCREEN_WIDTH-32, lunboHeight)];
    //    _bannerView.layer.masksToBounds = YES;
    //    _bannerView.layer.cornerRadius = 4;
    _bannerView.backgroundColor = [UIColor clearColor];
    _bannerView.selectedBanner = ^(NSInteger index) {
        BXBannerModel *model = ws.bannerArray[index];
//        [BXLocalAgreement loadUrl:model.url fromVc:ws];
    };
    [tableheadView addSubview:_bannerView];
    //发现音乐/我的收藏
    UIView *listView = [[UIView alloc]initWithFrame:CGRectMake(0, 20+lunboHeight, SCREEN_WIDTH, 44)];
    listView.backgroundColor = [UIColor whiteColor];
    [tableheadView addSubview:listView];
    
    self.findMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.findMusicBtn.backgroundColor = [UIColor clearColor];
    [self.findMusicBtn setTitle:@"发现音乐" forState:UIControlStateNormal];
    [self.findMusicBtn setTitleColor:UIColorHex(2F3333) forState:UIControlStateNormal];
    self.findMusicBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.findMusicBtn.tag=0;
    [self.findMusicBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [listView addSubview:self.findMusicBtn];
    self.findMusicBtn.sd_layout.leftSpaceToView(listView, 16).topSpaceToView(listView, 0).bottomSpaceToView(listView, 1).widthIs(SCREEN_WIDTH/2.0-16.5);
    
    self.myCollectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.myCollectBtn.backgroundColor = [UIColor clearColor];
    [self.myCollectBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
    [self.myCollectBtn setTitleColor:UIColorHex(4A4F4F) forState:UIControlStateNormal];
    self.myCollectBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.myCollectBtn.tag=1;
    [self.myCollectBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [listView addSubview:self.myCollectBtn];
    self.myCollectBtn.sd_layout.rightSpaceToView(listView, 16).topSpaceToView(listView, 0).bottomSpaceToView(listView, 1).widthIs(SCREEN_WIDTH/2.0-16.5);
    
    UIView *fengeView = [[UIView alloc]init];
    fengeView.backgroundColor = UIColorHex(DFE9E9);
    [listView addSubview:fengeView];
    fengeView.sd_layout.centerXEqualToView(listView).centerYEqualToView(listView).widthIs(1).heightIs(28);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view sd_addSubviews:@[self.tableView]];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    if ([NewHttpManager isNetWorkConnectionAvailable]) {
        self.tableView.tableHeaderView = tableheadView;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[BXMusicRecommendCell class] forCellReuseIdentifier:@"BXMusicRecommendCell"];
    [self.tableView registerClass:[BXMusicCategoryCell class] forCellReuseIdentifier:@"BXMusicCategoryCell"];
    [self.tableView registerClass:[BXMusicHomeListCell class] forCellReuseIdentifier:@"BXMusicHomeListCell"];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(114+__kTopAddHeight, 0, 0 + __kBottomAddHeight, 0));
    self.tableView.hidden = YES;
    [self loadAllData];
}

#pragma mark - 加载数据
- (void)loadAllData {
    [BGProgressHUD showLoadingWithMessage:nil];
    dispatch_group_t group = dispatch_group_create();
    [self loadBannerData:group];
    [self loadRecommendData:group];
    [self loadcategoryData:group];
    [self createData:group];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [BGProgressHUD hidden];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    });
}

#pragma mark - 请求数据
#pragma mark - 轮播图
- (void)loadBannerData:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]MusicSliderAdWithSuccess:^(id responseObject) {
        if ([responseObject[@"code"]integerValue]==0) {
            NSDictionary *slideDic = responseObject[@"data"];
            if (slideDic && [slideDic isDictionary]) {
                NSArray *contentsArr = slideDic[@"contents"];
                [self.bannerArray removeAllObjects];
                if ([contentsArr isArray]) {
                    [contentsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        BXBannerModel *model = [BXBannerModel appInfoWithDict:obj];
                        [self.bannerArray addObject:model];
                    }];
                }
                self.bannerView.banners = self.bannerArray;
            }
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

#pragma mark - 推荐
-(void)loadRecommendData:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]MusicRecommendWithOffset:@"0" length:@"12" Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
//            if (self.recommendArray) {
//                [self.recommendArray removeAllObjects];
//            }
            NSDictionary *dataDic = responseObject[@"data"];
            self.recommendString = dataDic[@"title"];
            if (dataDic && [dataDic isDictionary]) {
                 NSArray *itemArray = dataDic[@"item"];
                if (itemArray && [itemArray isArray] && itemArray.count) {
                    for (NSDictionary *cdict in itemArray) {
                        BXMusicModel *model = [BXMusicModel objectWithDictionary:cdict];
                        [self.recommendArray addObject:model];
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

#pragma mark - 歌单分类
-(void)loadcategoryData:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]MusicCategoryListWithSuccess:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            NSDictionary *dataDic = responseObject[@"data"];
            self.categoryString = dataDic[@"title"];
            if (dataDic && [dataDic isDictionary]) {
                NSArray *itemArray = dataDic[@"item"];
                if (itemArray && [itemArray isArray] && itemArray.count) {
                    for (NSDictionary *cdict in itemArray) {
                        BXMusicCategoryModel *model = [[BXMusicCategoryModel alloc]init];
                        [model updateWithJsonDic:cdict];
                        [self.categoryArray addObject:model];
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

#pragma mark - 主页底部数据
- (void)createData:(dispatch_group_t)group{
    if (group) {
        dispatch_group_enter(group);
    }
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]MusicHomeWithSuccess:^(id responseObject) {
        if([responseObject[@"code"] integerValue] == 0)
        {
            NSArray *dataDic = responseObject[@"data"];
            if (dataDic && [dataDic isArray] && dataDic.count) {
                for (NSDictionary *cdict in dataDic) {
                    BXMusicCategoryModel *model = [[BXMusicCategoryModel alloc]init];
                    [model updateWithJsonDic:cdict];
                    [self.homeListArray addObject:model];
                }
            }
        } else{
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

#pragma mark - 我的收藏
- (void)mycollectData{
    [[NewHttpRequestPort sharedNewHttpRequestPort] CollectionOwnList:@{@"type":@"music",@"offset":[NSString stringWithFormat:@"%ld",(long)self.offset],@"length":@"20"} Success:^(id responseObject) {
        [BGProgressHUD hidden];
        if([responseObject[@"code"] integerValue] == 0)
        {
            if (!self.offset) {
                [self.collectionArray removeAllObjects];
                self.tableView.isNoMoreData = NO;
            }
            NSArray *dataArray = responseObject[@"data"];
            if (dataArray && dataArray.count) {
                for (NSDictionary *dic in dataArray) {
                    BXMusicModel *model = [BXMusicModel objectWithDictionary:dic];
                    [self.collectionArray addObject:model];
                }
            } else {
                self.tableView.isNoMoreData = YES;
            }
        } else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        [self.tableView reloadData];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
    } Failure:^(NSError *error) {
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}

#pragma mark - 关闭按钮
- (void)deleteBtnClick{
    if (self.closeMusicBlock) {
        self.closeMusicBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发现音乐/我的收藏 点击事件
- (void)listBtnClick:(UIButton *)btn{
    if (btn.tag==0) {
        if ([self.type isEqualToString:@"1"]) {
            return;
        }else{
            [[BXMusicManager sharedManager] pausePlay];
            self.type = @"1";
            [self.findMusicBtn setTitleColor:UIColorHex(2F3333) forState:UIControlStateNormal];
            self.findMusicBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [self.myCollectBtn setTitleColor:UIColorHex(4A4F4F) forState:UIControlStateNormal];
            self.myCollectBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.tableView reloadData];
        }
    }else{
        if ([self.type isEqualToString:@"2"]) {
            return;
        }else{
            [BGProgressHUD showLoadingWithMessage:nil];
            [[BXMusicManager sharedManager] pausePlay];
            if (self.currentModel) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
            }
            self.type = @"2";
            [self.findMusicBtn setTitleColor:UIColorHex(4A4F4F) forState:UIControlStateNormal];
            self.findMusicBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.myCollectBtn setTitleColor:UIColorHex(2F3333) forState:UIControlStateNormal];
            self.myCollectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            self.offset = 0;
            [self mycollectData];
        }
    }
}

#pragma - mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[BXMusicManager sharedManager] stopPlay];
    if (self.currentModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
    }
    BXMusicSearchVC *msvc = [[BXMusicSearchVC alloc]init];
    msvc.delegate = self;
    msvc.view.frame = self.view.frame;
    [self.view addSubview:msvc.view];
    [self addChildViewController:msvc];
    return NO;
}

#pragma - mark - DSMusicSearchVCDelegate
- (void)deleteAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancelSearch {
    [UIView animateWithDuration:.5 animations:^{
        self.textField.mj_w = SCREEN_WIDTH-32;
    }];
}

#pragma mark - DSMusicCategoryCellDelegate
- (void)pushCategoryDetailWithCategoryID:(NSString *)categoryID Title:(NSString *)title{
    [[BXMusicManager sharedManager] stopPlay];
    if (self.currentModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
    }
    BXMusicCategoryDetailVC *mcdvc = [[BXMusicCategoryDetailVC alloc]init];
    mcdvc.categoryId = categoryID;
    mcdvc.titleString = title;
    [self.navigationController pushViewController:mcdvc animated:YES];
}

#pragma - mark UITableViewDelegate/DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.type isEqualToString:@"1"]) {
        return 2 + self.homeListArray.count;
    }else{
        return 1;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.type isEqualToString:@"1"]) {
        return 1;
    }else{
        return self.collectionArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"1"]) {
        return 204;
    }else{
        return 68;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"1"]) {
        if (indexPath.section==0) {
            BXMusicRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXMusicRecommendCell"];
            cell.dataArray = self.recommendArray;
            @weakify(self);
            [cell setMusicCollectBlock:^(NSInteger index) {
                @strongify(self);
                if (![NewHttpManager isNetWorkConnectionAvailable]) {
                    return ;
                }
                BXMusicModel *model = self.recommendArray[index];
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
        }else if (indexPath.section==1){
            BXMusicCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXMusicCategoryCell"];
            cell.delegate = self;
            cell.dataArray = self.categoryArray;
            return cell;
        }else{
            BXMusicHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXMusicHomeListCell"];
            BXMusicCategoryModel *categoryModel = self.homeListArray[indexPath.section-2];
            cell.dataArray = categoryModel.itemArray;
            [cell setMusicCollectBlock:^(NSInteger index) {
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
    }else{
        NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
        BXMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[BXMusicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.model = self.collectionArray[indexPath.row];
        BXMusicModel *model = self.collectionArray[indexPath.row];

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
                    if (model.isSelect) {
                        [[BXMusicManager sharedManager] pausePlay];
                    }
                    [self.collectionArray removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                } else {
                    [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
                }
            } failure:^(NSError *error) {
                [BGProgressHUD showInfoWithMessage:@"操作失败"];
            }];
            
        }];
        [cell setMusicUseBlock:^{
            if (![NewHttpManager isNetWorkConnectionAvailable]) {
                return ;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUseMusicNotification object:nil userInfo:@{@"model":model}];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.type isEqualToString:@"2"]) {
        if (![NewHttpManager isNetWorkConnectionAvailable]) {
            return ;
        }
        BXMusicTableViewCell *cell = (BXMusicTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        BXMusicModel *themodel = self.collectionArray[indexPath.row];
        self.currentModel = themodel;
        for (BXMusicModel *model in self.collectionArray) {
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
                    [[BXMusicManager sharedManager] pausePlay];
                }
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectMusicNotification" object:nil userInfo:@{@"model":themodel}];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (![NewHttpManager isNetWorkConnectionAvailable]) {
        return 0;
    }
    if ([self.type isEqualToString:@"1"]) {
        return 42;
    }else{
        return 0.1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.type isEqualToString:@"1"]) {
        return 0.1;
    }else{
        return 0.1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (![NewHttpManager isNetWorkConnectionAvailable]) {
        return nil;
    }
    if ([self.type isEqualToString:@"1"]) {
        if (section == 0) {
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
            headView.backgroundColor = [UIColor whiteColor];
            UIView *fengeView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32, 1)];
            fengeView.backgroundColor = UIColorHex(DFE9E9);
            [headView addSubview:fengeView];
            UILabel *titleLabel = [UILabel initWithFrame:CGRectMake(16, 16, 80, 20) text:self.recommendString ? self.recommendString : @"推荐" size:16 color:WhiteBgTitleColor alignment:NSTextAlignmentLeft lines:1 shadowColor:[UIColor clearColor]];
            titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [headView addSubview:titleLabel];
            UIButton *lookAllBtn = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-16-50, 12, 50, 30) Title:@"查看全部" Font:CFont(12) Color:UIColorHex(7A8181) Image:nil Target:self action:@selector(lookAllBtn:) forControlEvents:UIControlEventTouchUpInside];
            lookAllBtn.tag = section;
            [headView addSubview:lookAllBtn];
            return headView;
        }else if (section == 1){
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
            headView.backgroundColor = [UIColor whiteColor];
            UIView *fengeView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32, 1)];
            fengeView.backgroundColor = UIColorHex(DFE9E9);
            [headView addSubview:fengeView];
            UILabel *titleLabel = [UILabel initWithFrame:CGRectMake(16, 16, 80, 20) text:self.categoryString ? self.categoryString : @"歌单分类" size:16 color:WhiteBgTitleColor alignment:NSTextAlignmentLeft lines:1 shadowColor:[UIColor clearColor]];
            titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [headView addSubview:titleLabel];
            UIButton *lookAllBtn = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-16-50, 12, 50, 30) Title:@"查看全部" Font:CFont(12) Color:UIColorHex(7A8181) Image:nil Target:self action:@selector(lookAllBtn:) forControlEvents:UIControlEventTouchUpInside];
            lookAllBtn.tag = section;
            [headView addSubview:lookAllBtn];
            return headView;
        }else{
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
            headView.backgroundColor = [UIColor whiteColor];
            UIView *fengeView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32, 1)];
            fengeView.backgroundColor = UIColorHex(DFE9E9);
            [headView addSubview:fengeView];
            BXMusicCategoryModel *categoryModel = self.homeListArray[section-2];
            UILabel *titleLabel = [UILabel initWithFrame:CGRectMake(16, 16, 80, 20) text:categoryModel.title size:16 color:WhiteBgTitleColor alignment:NSTextAlignmentLeft lines:1 shadowColor:[UIColor clearColor]];
            titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [headView addSubview:titleLabel];
            UIButton *lookAllBtn = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-16-50, 12, 50, 30) Title:@"查看全部" Font:CFont(12) Color:UIColorHex(7A8181) Image:nil Target:self action:@selector(lookAllBtn:) forControlEvents:UIControlEventTouchUpInside];
            lookAllBtn.tag = section;
            [headView addSubview:lookAllBtn];
            return headView;
        }
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if ([self.type isEqualToString:@"1"]) {
//        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//        footView.backgroundColor = [UIColor whiteColor];
//        return footView;
//    }
    return nil;
}

#pragma mark - 查看全部
- (void)lookAllBtn:(UIButton *)btn{
    [[BXMusicManager sharedManager] stopPlay];
    if (self.currentModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
    }

    if (btn.tag==0) {
        //推荐
        BXMusicRecommedDeailVC *mrdvc = [[BXMusicRecommedDeailVC alloc]init];
        [self.navigationController pushViewController:mrdvc animated:YES];
    }else if (btn.tag == 1){
        //歌单分类
        BXMusicCategoryVC *mcvc = [[BXMusicCategoryVC alloc]init];
        [self.navigationController pushViewController:mcvc animated:YES];
    }else{
        BXMusicCategoryModel *categoryModel = self.homeListArray[btn.tag-2];
        BXMusicCategoryDetailVC *mcdvc = [[BXMusicCategoryDetailVC alloc]init];
        mcdvc.categoryId = categoryModel.category_id;
        mcdvc.titleString = categoryModel.title;
        [self.navigationController pushViewController:mcdvc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.type isEqualToString:@"2"]) {
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
                self.offset = self.collectionArray.count;
                [self mycollectData];
            }
        }
    }else{
        CGFloat sectionHeaderHeight = 42;
        if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
            scrollView.contentInset=UIEdgeInsetsMake(-scrollView.contentOffset.y,0,0,0);
        }else if(scrollView.contentOffset.y>=sectionHeaderHeight){
            scrollView.contentInset=UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
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
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

#pragma - mark Class Method
+ (void)downloadMusic:(BXMusicModel *)music completion:(void (^)(BXMusicModel *music))completion {
    [BXMusicDownloadManager downloadMusic:music isDownLyric:NO completion:^(BXMusicModel * _Nonnull music) {
        if (completion) {
            completion(music);
        }
    }];
}

@end

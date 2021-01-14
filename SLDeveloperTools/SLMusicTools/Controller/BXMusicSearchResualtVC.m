//
//  BXMusicSearchResualtVC.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicSearchResualtVC.h"
#import "BXSLSearchManager.h"
#import "BXMusicModel.h"
#import "BXMusicTableViewCell.h"
#import "BXMusicManager.h"
#import <YYWebImage/YYWebImage.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <YYCategories/YYCategories.h>
#import "SLMusicToolsMacro.h"

@interface BXMusicSearchResualtVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * searchReaultArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic , strong) UIButton * cancelBtn;
@property (nonatomic, assign) NSInteger offSet;
@property (nonatomic , strong) BXMusicModel * currentModel;
@property (nonatomic , assign) BOOL isEdite;
@property (nonatomic , strong) NSString * searchString;
@end

@implementation BXMusicSearchResualtVC


- (NSMutableArray *)searchReaultArray{
    if (!_searchReaultArray) {
        _searchReaultArray = [[NSMutableArray alloc]init];
    }
    return _searchReaultArray;
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
    self.isEdite = NO;
    self.searchString = _searchText;
    _offSet = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavView];
    [self initTableView];
    [self loadFirstData];
    [self addObserver];
}

- (void)addObserver{
    // app进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

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
    textField.textColor = WhiteBgTitleColor;
    textField.returnKeyType = UIReturnKeySearch;
    textField.layer.cornerRadius = 17;
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = CHHCOLOR_D(0xDFE9E9).CGColor;
    textField.font = CFont(14);
    textField.leftView = leftview;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索歌曲名称" attributes:@{NSForegroundColorAttributeName:CHHCOLOR_D(0xA8AFAF)}];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.text = _searchText;
    [searchView addSubview:textField];
    [textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    _textField = textField;

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(__kWidth, 0, 30, 44);
    [cancelBtn setTitleColor:TextHighlightColor forState:BtnNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelBtn setTitle:@"取消" forState:BtnNormal];
    cancelBtn.titleLabel.font = CFont(14);
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:BtnTouchUpInside];
    [searchView addSubview:cancelBtn];
    _cancelBtn = cancelBtn;
}

- (void)initTableView{
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
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(114+__kTopAddHeight, 0, 0, 0));
    
    [self.tableView endRefreshingWithNoMoreData];
}

- (void)loadFirstData{
    self.offSet = 0;
    [self loadSearchReault];
    [BGProgressHUD showLoadingWithMessage:nil];
}

#pragma mark - 加载更多
- (void)loadMoreData
{
    self.offSet = self.searchReaultArray.count;
    [self loadSearchReault];
}

- (void)loadSearchReault{
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]MusicSearchWithWords:_textField.text Offset:[NSString stringWithFormat:@"%ld",(long)self.offSet] length:@"20" Success:^(id responseObject) {
        [BGProgressHUD hidden];
        if ([responseObject[@"code"] integerValue]==0) {
            if (!self.offSet) {
                [self.searchReaultArray removeAllObjects];
                self.tableView.isNoMoreData = NO;
            }
            NSArray *recommArray = responseObject[@"data"];
            if (recommArray.count) {
                for (NSDictionary *cdict in recommArray) {
                    BXMusicModel *model = [BXMusicModel objectWithDictionary:cdict];
                    [self.searchReaultArray addObject:model];
                }
            }else{
                self.tableView.isNoMoreData = YES;
            }
            [BXSLSearchManager addMusicSearchHistoryWithSearchText:self.textField.text];
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = NO;
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        [BGProgressHUD hidden];
        [self.tableView.mj_header endRefreshing];
        self.tableView.isRefresh = NO;
        self.tableView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}

#pragma - mark UITableViewDelegate/DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchReaultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.searchReaultArray.count-1) {
        return 78;
    }
    return 68;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    BXMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BXMusicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = self.searchReaultArray[indexPath.row];
    BXMusicModel *model = self.searchReaultArray[indexPath.row];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![NewHttpManager isNetWorkConnectionAvailable]) {
        return ;
    }
    BXMusicTableViewCell *cell = (BXMusicTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    BXMusicModel *themodel = self.searchReaultArray[indexPath.row];
    self.currentModel = themodel;
    for (BXMusicModel *model in self.searchReaultArray) {
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
#pragma mark - 删除
- (void)deleteBtnClick{
    [[BXMusicManager sharedManager] stopPlay];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteAction)]) {
        [_delegate deleteAction];
    }
}

#pragma mark - 取消
- (void)cancelAction{
    [[BXMusicManager sharedManager] stopPlay];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancelSearch)]) {
        [_delegate cancelSearch];
    }
}

-(void)changedTextField:(UITextField *)textField
{
    if (textField.text == nil||textField.text.length == 0) {
        [[BXMusicManager sharedManager] stopPlay];
        [self.textField resignFirstResponder];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if (_delegate && [_delegate respondsToSelector:@selector(removeResault)]) {
            [_delegate removeResault];
        }
    }
}

#pragma - mark UITextFieldDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (_delegate && [_delegate respondsToSelector:@selector(removeResault)]) {
        [_delegate removeResault];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.isEdite = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.cancelBtn.frame = CGRectMake(__kWidth - 16 - 30, 0, 30, 44);
        self.textField.frame = CGRectMake(16, textField.mj_y, SCREEN_WIDTH-78, textField.mj_h);
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (IsNilString(textField.text)) {
        [BGProgressHUD showInfoWithMessage:@"请输入搜索内容"];
        return NO;
    }
    self.isEdite = NO;
    [self.textField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.cancelBtn.frame = CGRectMake(__kWidth, 0, 30, 44);
        self.textField.frame = CGRectMake(16, textField.mj_y, SCREEN_WIDTH-32, textField.mj_h);
    }];
    if (![_searchString isEqualToString:self.textField.text]) {
        if (self.currentModel) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidMusicPlayFinishNotification object:nil userInfo:@{@"model":self.currentModel}];
        }
        [[BXMusicManager sharedManager] pausePlay];
        _searchString = self.textField.text;
        [self.searchReaultArray removeAllObjects];
        [self loadFirstData];
    }
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>0||offsetY<0) {
        if (self.isEdite == YES) {
            self.isEdite = NO;
            [self.textField resignFirstResponder];
            [UIView animateWithDuration:0.5 animations:^{
                self.cancelBtn.frame = CGRectMake(__kWidth, 0, 30, 44);
                self.textField.frame = CGRectMake(16, self.textField.mj_y, SCREEN_WIDTH-32, self.textField.mj_h);
            }];
        }
    }
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

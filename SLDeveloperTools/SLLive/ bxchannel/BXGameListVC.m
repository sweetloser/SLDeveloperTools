//
//  GameListVc.m
//  BXlive
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BXGameListVC.h"
#import "BXGameListDetailVC.h"
#import "BXGameListCell.h"
#import "BXLiveChannel.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface BXGameListVC () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property (strong, nonatomic) NSArray *liveChannels;

@property(nonatomic,strong)UIView *navigationView;

@end

@implementation BXGameListVC

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)getLiveChannels{
    [NewHttpManager liveChannelWithParentId:@"" success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            self.liveChannels = [NSArray arrayWithArray:models];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = sl_BGColors;
    self.fd_prefersNavigationBarHidden = YES;
    [self setupNav];
    [self setupTableview];
    [self getLiveChannels];
}

-(void)setupNav{
//    self.navigationItem.title = @"选择直播频道";
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"login_icon_back"] forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 0, 32, 32);
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    // 修改导航栏左边的item
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationController.navigationBar.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
//    self.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:[UIColor sl_colorWithHex:0xFFFFFF]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:sl_textColors,NSFontAttributeName: SLBFont(18)}];
    
    _navigationView = [UIView new];
    [self.view addSubview:_navigationView];
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(__kTopAddHeight+64);
    }];
    [_navigationView setBackgroundColor:[UIColor colorWithHex:0xFFFFFF]];
    WS(weakSelf);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:BtnTouchUpInside];
    [_navigationView addSubview:backBtn];
    [backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    UILabel *label = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"选择直播频道" Font:SLBFont(18) TextColor:sl_textColors];
    label.textAlignment = 1;
    [_navigationView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(44);
        make.right.mas_equalTo(-44);
        make.centerY.equalTo(weakSelf.navigationView.mas_bottom).offset(-22);
        make.height.mas_equalTo(25);
    }];

}

- (void)setupTableview {
    
    UIView *header = [UIView new];
    header.width = [UIScreen mainScreen].bounds.size.width;
    header.backgroundColor = sl_subBGColors;
    UILabel *channelLabel = [UILabel initWithFrame:CGRectZero text:@"注意选择合适自己的频道。直播过程中,如果运营人员发您选择的频道与直播内容不符的情况,将重新调整您的直播频道" size:13 color:sl_textSubColors alignment:0 lines:0 shadowColor:nil];
    channelLabel.font = SLPFFont(12);
    [header addSubview:channelLabel];
    channelLabel.sd_layout.leftSpaceToView(header, __ScaleWidth(12)).topSpaceToView(header, __ScaleWidth(15)).rightSpaceToView(header, __ScaleWidth(12)).autoHeightRatio(0);
    [header setupAutoHeightWithBottomView:channelLabel bottomMargin:__ScaleWidth(15)];
    [header layoutSubviews];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view sd_addSubviews:@[self.tableView]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64 + __kTopAddHeight, 0, 0, - __kBottomAddHeight));
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = header;
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BXLiveChannel *model = _liveChannels[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"liveChannel" cellClass:[BXGameListCell class] contentViewWidth:SCREEN_WIDTH];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _liveChannels.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BXGameListCell *cell = [BXGameListCell  cellWithTableView:tableView];
    
    
    cell.liveChannel = _liveChannels[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BXLiveChannel *liveChannel = _liveChannels[indexPath.row];
    if ([liveChannel.sub_channel integerValue]) {
        BXGameListDetailVC *detailVC = [[BXGameListDetailVC alloc]init];
        detailVC.parentId = liveChannel.channelId;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        self.selectType(liveChannel.name, liveChannel.channelId, @"0");
        [self back];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

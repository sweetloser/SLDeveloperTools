//
//  BXGameListDetailVC.m
//  BXlive
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BXGameListDetailVC.h"
#import "BXGameListCell.h"
#import "BXLiveChannel.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface BXGameListDetailVC () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property (strong, nonatomic) NSArray *liveChannels;

@property(nonatomic,strong)UIView *navigationView;

@end

@implementation BXGameListDetailVC

-(void)getLiveChannels{
    [NewHttpManager liveChannelWithParentId:_parentId success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
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

    _navigationView = [UIView new];
    [self.view addSubview:_navigationView];
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(__kTopAddHeight+64);
    }];
    [_navigationView setBackgroundColor:[UIColor colorWithHex:0xFFFFFF]];
    WS(weakSelf);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:BtnTouchUpInside];
    [_navigationView addSubview:backBtn];
    [backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    UILabel *label = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"选择直播类型" Font:SLBFont(18) TextColor:sl_textColors];
    label.textAlignment = 1;
    [_navigationView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(44);
        make.right.mas_equalTo(-44);
        make.centerY.equalTo(weakSelf.navigationView.mas_bottom).offset(-22);
        make.height.mas_equalTo(25);
    }];
    
    
    
    [self setupTableview];
    [self getLiveChannels];
}

- (void)setupTableview {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view sd_addSubviews:@[self.tableView]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64 + __kTopAddHeight, 0, 0, - __kBottomAddHeight));
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.liveChannel = _liveChannels[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     BXLiveChannel *liveChannel = _liveChannels[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidGetGameChannelNotification object:self userInfo:@{@"name":liveChannel.name,@"gameId":liveChannel.channelId,@"channel_id":_parentId}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

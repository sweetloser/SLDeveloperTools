//
//  BXKSongCategoryVC.m
//  BXlive
//
//  Created by bxlive on 2019/6/13.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXKSongCategoryVC.h"
#import "BXMusicCategoryModel.h"
#import "BXMusicCategoryTableViewCell.h"
#import "BXKSongCategoryDetailVC.h"
#import "SLMaskTools.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../../SLMacro/SLMacro.h"
#import <YYWebImage/YYWebImage.h>
#import "../../SLAppInfo/SLAppInfo.h"
#import "../../SLCategory/SLCategory.h"

@interface BXKSongCategoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation BXKSongCategoryVC

- (NSString *)title{
    return @"曲目分类";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [BGProgressHUD showLoadingWithMessage:nil];
    [self initTableView];
    [self loadTableViewData];
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:WhiteBgTitleColor, NSFontAttributeName:CBFont(20)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:CHH_RGBCOLOR(238, 240, 240, 1.0)]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:MainTitleColor, NSFontAttributeName:CBFont(20)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:PageBackgroundColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:PageBackgroundColor] forBarMetrics:UIBarMetricsDefault];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}



- (void)loadTableViewData{
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]MusicCategoryListWithSuccess:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            [BGProgressHUD hidden];
            NSDictionary *dataDic = responseObject[@"data"];
            if (dataDic && [dataDic isDictionary]) {
                NSArray *itemArray = dataDic[@"item"];
                if (itemArray && [itemArray isArray] && itemArray.count) {
                    for (NSDictionary *cdict in itemArray) {
                        BXMusicCategoryModel *model = [[BXMusicCategoryModel alloc]init];
                        [model updateWithJsonDic:cdict];
                        [self.dataArray addObject:model];
                    }
                }
            }
        }else{
            [BGProgressHUD showInfoWithMessage:[responseObject valueForKey:@"msg"]];
        }
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        [BGProgressHUD hidden];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BXMusicCategoryTableViewCell *cell = [BXMusicCategoryTableViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BXMusicCategoryModel *model = self.dataArray[indexPath.row];
    BXKSongCategoryDetailVC *kscdvc = [[BXKSongCategoryDetailVC alloc]init];
    kscdvc.titleString = [NSString stringWithFormat:@"%@",model.title];
    kscdvc.categoryId = [NSString stringWithFormat:@"%@",model.category_id];
    [self.navigationController pushViewController:kscdvc animated:YES];
}

@end

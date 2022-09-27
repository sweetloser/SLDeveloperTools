//
//  HHSelectCountryVC.m
//  BXlive
//
//  Created by bxlive on 2018/9/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "HHSelectCountryVC.h"
#import "HHSelectCountryCell.h"
#import "HHCountrySection.h"
#import "HHCountry.h"
#import "HHSearchResultVC.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <YYWebImage/YYWebImage.h>
#import <Masonry/Masonry.h>
#import <MMKV/MMKV.h>

@interface HHSelectCountryVC () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchVC;
@property (strong, nonatomic) HHSearchResultVC *resultVC;

@property (strong, nonatomic) NSArray *countrySections;

@end

@implementation HHSelectCountryVC

- (void)getPhoneCodes {
    [BGProgressHUD showLoadingWithMessage:nil];
    [NewHttpManager getPhoneCodesSuccess:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        [BGProgressHUD hidden];
        if (flag) {
            [self didGetDatWithDic:jsonDic];
        } else {
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD hidden];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:sl_BGColors]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:sl_BGColors] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:sl_textColors, NSFontAttributeName:SLBFont(18)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:sl_BGColors]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:sl_BGColors] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:sl_textColors, NSFontAttributeName:SLBFont(18)};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"选择国家/地区";
    
    [self initView];
    [self getPhoneCodes];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:[UIColor whiteColor]]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)didGetDatWithDic:(NSDictionary *)dic {
    NSArray *dataArray = dic[@"data"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        HHCountrySection *countrySection = [[HHCountrySection alloc]init];
        [countrySection updateWithJsonDic:dic];
        [tempArray addObject:countrySection];
    }
    self.countrySections = [NSArray arrayWithArray:tempArray];
    [self.tableView reloadData];
}

- (void)initView {
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = TextHighlightColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    HHSearchResultVC *resultVC = [[HHSearchResultVC alloc]init];
    
    UISearchController *searchVC = [[UISearchController alloc] initWithSearchResultsController:resultVC];
    searchVC.delegate = self;
    searchVC.searchBar.delegate = self;
    searchVC.searchResultsUpdater = resultVC;
    searchVC.searchBar.placeholder = @"请输入国家/地区中文名、全拼或代码";
    searchVC.searchBar.tintColor = sl_normalColors;
    searchVC.searchBar.backgroundImage = CImage(@"noneImage");
//    searchVC.searchBar.barTintColor = sl_normalColors;
    [searchVC.searchBar sizeToFit];
    searchVC.searchBar.backgroundColor = sl_BGColors;
    if (@available(iOS 13.0, *)){
        
    }else{
        UITextField *textField = [searchVC.searchBar valueForKey:@"_searchField"];
        textField.font = CFont(15);
        [textField setValue:CHHCOLOR_D(0xB0B0B0) forKeyPath:@"_placeholderLabel.textColor"];
        textField.backgroundColor = [UIColor whiteColor];
    }
    
//    UIButton *canceLBtn = [self.searchController.searchBar valueForKey:@"cancelButton"];
    
//    if (IOS11) {
//        self.navigationItem.searchController = searchVC;
//    } else {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, 56)];
    [headerView addSubview:searchVC.searchBar];
    _tableView.tableHeaderView = headerView;
//    }
    
    WS(ws);
    resultVC.searchBar = searchVC.searchBar;
    resultVC.didSelectCountry = ^(NSString *country, NSString *code) {
        [ws didGetPhoneArea:country phoneCode:code];
    };
    _searchVC = searchVC;
    _resultVC = resultVC;
}

- (void)didGetPhoneArea:(NSString *)phoneArea phoneCode:(NSString *)phoneCode{
    [self.navigationController popViewControllerAnimated:YES];
    MMKV *mmkv = [MMKV defaultMMKV];
    [mmkv setString:phoneArea forKey:kDefaultPhoneArea];
    [mmkv setString:phoneCode forKey:kDefaultPhoneCode];
    if (_didSelectCountry) {
        _didSelectCountry(phoneArea, phoneCode);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark UITableViewDataSource
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titles = [NSMutableArray array];
    for (HHCountrySection *countrySection in _countrySections) {
        [titles addObject:countrySection.title];
    }
    return titles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _countrySections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HHCountrySection *countrySection = _countrySections[section];
    return countrySection.countrys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHSelectCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell  = [[HHSelectCountryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HHCountrySection *countrySection = _countrySections[indexPath.section];
    cell.country = countrySection.countrys[indexPath.row];
    return cell;
}

#pragma - mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHCountrySection *countrySection = _countrySections[section];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 30)];
//    view.backgroundColor = CHHCOLOR_D(0xf4f4f4);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.font = CFont(14);
    titleLb.textColor = CHHCOLOR_D(0x373737);
    titleLb.text = countrySection.title;
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCountrySection *countrySection = _countrySections[indexPath.section];
    HHCountry *country = countrySection.countrys[indexPath.row];
    [self didGetPhoneArea:country.area phoneCode:country.code];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    for (UIView *view in [tableView subviews]) {
        
        if ([view isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
            // 设置字体大小
            [view setValue:CFont(12) forKey:@"_font"];
            
            [view setValue:sl_normalColors forKey:@"_indexColor"];
            //设置view的大小
            view.bounds = CGRectMake(0, 0, 30, 30);
            view.backgroundColor = [UIColor clearColor];
        }
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
            [ws getPhoneCodes];
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

#pragma - mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _resultVC.countrySections = _countrySections;
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

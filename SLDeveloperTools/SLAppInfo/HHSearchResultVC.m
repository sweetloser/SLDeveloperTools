//
//  HHSearchResultVC.m
//  BXlive
//
//  Created by bxlive on 2018/9/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "HHSearchResultVC.h"
#import "HHSelectCountryCell.h"
#import "HHCountrySection.h"
#import "HHCountry.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>
#import <SLDeveloperTools/SLDeveloperTools.h>


@interface HHSearchResultVC () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *countrys;

@end

@implementation HHSearchResultVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;  //不加的话，table会下移
    self.edgesForExtendedLayout = UIRectEdgeNone;    //不加的话，UISearchBar返回后会上移
//    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:PageBackgroundColor]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:PageBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage yy_imageWithColor:[UIColor whiteColor]]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self initView];
}

- (void)initView {
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.sectionIndexColor = TextHighlightColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *text = searchController.searchBar.text;
    if (IsNilString(text)) {
        _countrys = nil;
    } else {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@ || %K CONTAINS %@ || %K CONTAINS[cd] %@", @"code", text, @"area", text, @"pinyin", text];
        for (HHCountrySection *countrySection in _countrySections) {
            [tempArray addObjectsFromArray:[countrySection.countrys filteredArrayUsingPredicate:predicate]];
        }
        _countrys = [NSArray arrayWithArray:tempArray];
    }
    [_tableView reloadData];
}

#pragma - mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _countrys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHSelectCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell  = [[HHSelectCountryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.country = _countrys[indexPath.row];
    return cell;
}

#pragma - mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCountry *country = _countrys[indexPath.row];
    if (_didSelectCountry) {
        _didSelectCountry(country.area, country.code);
    }
}

#pragma - mark DZNEmptyDataSetSource
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

#pragma - mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
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

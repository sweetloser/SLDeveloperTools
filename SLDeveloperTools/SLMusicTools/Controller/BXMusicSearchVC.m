//
//  BXMusicSearchVC.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicSearchVC.h"
#import "BXSLSearchHistoryCell.h"
#import "BXMusicSearchResualtVC.h"
#import "BXSLSearchManager.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <YYWebImage/YYWebImage.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>

@interface BXMusicSearchVC ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,BXMusicSearchResualtVCDelegate>
/** 表单视图 */
@property (nonatomic, strong) UITableView *tableView;
/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *searchHistorys;
/** 搜索文本框 */
@property (nonatomic , strong) UITextField * textField;

@end

@implementation BXMusicSearchVC

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
    self.view.backgroundColor = [UIColor whiteColor];
    _searchHistorys = [BXSLSearchManager getMusicSearchHistorys].mutableCopy;
    //创建自定义导航栏
    [self initNavView];
    //创建表单视图
    [self initTableView];
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
    textField.tintColor = normalColors;
    [searchView addSubview:textField];
    [textField becomeFirstResponder];
    _textField = textField;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(__kWidth, 0, 30, 44);
    [cancelBtn setTitleColor:TextHighlightColor forState:BtnNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelBtn setTitle:@"取消" forState:BtnNormal];
    cancelBtn.titleLabel.font = CFont(14);
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:BtnTouchUpInside];
    [searchView addSubview:cancelBtn];
    
    [UIView animateWithDuration:.5 animations:^{
        cancelBtn.frame = CGRectMake(__kWidth - 16 - 30, 0, 30, 44);
        textField.frame = CGRectMake(16, textField.mj_y, SCREEN_WIDTH-78, textField.mj_h);
    }];
}

#pragma mark - 创建表单视图
- (void)initTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(114 + __kTopAddHeight);
    }];
}

#pragma mark - 关闭按钮
- (void)deleteBtnClick{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteAction)]) {
        [_delegate deleteAction];
    }
}

#pragma mark - 取消按钮
- (void)cancelAction {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancelSearch)]) {
        [_delegate cancelSearch];
    }
}

#pragma mark - 跳转到搜索结果页面
- (void)searchResault:(NSString *)text {
    self.textField.text = @"";
    [self.textField resignFirstResponder];

    BXMusicSearchResualtVC *msvc = [[BXMusicSearchResualtVC alloc]init];
    msvc.delegate = self;
    msvc.searchText = text;
    msvc.view.frame = self.view.frame;
    [self.view addSubview:msvc.view];
    [self addChildViewController:msvc];
}

#pragma mark - BXMusicSearchResualtVCDelegate
- (void)deleteAction{
    [self deleteBtnClick];
}
- (void)cancelSearch{
    [self cancelAction];
}
- (void)removeResault{
    [self.textField becomeFirstResponder];
    _searchHistorys = [BXSLSearchManager getMusicSearchHistorys].mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - 清除全部历史记录
- (void)footerViewTapAction {
    [BXSLSearchManager removeMusicSearchHistoryWithSearchText:nil];
    [_searchHistorys removeAllObjects];
    [self.tableView reloadData];
}

#pragma - mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (IsNilString(textField.text)) {
        [BGProgressHUD showInfoWithMessage:@"请输入搜索内容"];
        return NO;
    }
    [self searchResault:textField.text];
    return YES;
}

#pragma mark - UITableViewDelegate/Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return 1;
    } else {
        if (_searchHistorys.count>10) {
            return 10;
        }else{
            return _searchHistorys.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(ws);
    BXSLSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXSLSearchHistoryCell"];
    if (!cell) {
        cell = [[BXSLSearchHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BXSLSearchHistoryCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.text = _searchHistorys[indexPath.row];
    cell.removeText = ^(NSString *text) {
        [BXSLSearchManager removeMusicSearchHistoryWithSearchText:text];
        [ws.searchHistorys removeObject:text];
        [tableView reloadData];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_searchHistorys.count) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 55)];
        footerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *textLb = [[UILabel alloc]init];
        textLb.font = CFont(14);
        textLb.textColor = WhiteBgTitleColor;
        textLb.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:textLb];
        [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-20);
            make.height.mas_equalTo(20);
        }];
        
        if (_searchHistorys.count) {
            textLb.text = @"清除全部历史记录";
        } else {
            textLb.text = @"全部搜索历史记录";
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footerViewTapAction)];
        [footerView addGestureRecognizer:tap];
        
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_searchHistorys.count) {
        return 55;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [self searchResault:_searchHistorys[indexPath.row]];
    }
}

@end

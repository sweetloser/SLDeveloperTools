//
//  BXSLSearchingVC.m
//  BXlive
//
//  Created by bxlive on 2019/3/7.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchingVC.h"
#import "BXSLSearchResultVC.h"
#import "BXSLSearchManager.h"
#import "BXSLSearchHistoryCell.h"
#import "SLSearchHistoryCollectionViewCell.h"
#import "BXSLSearchHeaderView.h"
#import "SLSeachHeaderView.h"
#import "SLSearchingFlowLayout.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "../SLMaskTools/SLMaskTools.h"

@interface BXSLSearchingVC () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, strong) NSMutableArray *searchHistorys;

@property (nonatomic, assign) BOOL isAll;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation BXSLSearchingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
    // Do any additional setup after loading the view.
    _searchHistorys = [BXSLSearchManager getSearchHistorys].mutableCopy;
    
    [self addSearchBar];
    [self initViews];
}

- (void)addSearchBar {
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 64 + __kTopAddHeight)];
    [self.view addSubview:navBar];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(__kWidth - __ScaleWidth(12) - 35, 20 + __kTopAddHeight + 6, 35, 32);
    [cancelBtn setTitleColor:sl_textSubColors forState:BtnNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelBtn setTitle:@"取消" forState:BtnNormal];
    cancelBtn.titleLabel.font = SLPFFont(16);
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:BtnTouchUpInside];
    [navBar addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 39, 34)];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuo_icon_sousuo"]];
    iconIv.contentMode = UIViewContentModeCenter;
    iconIv.frame = CGRectMake(16, 9, 16, 16);
    [leftview addSubview:iconIv];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 20 + __kTopAddHeight + 5, SearchTextFieldNormalWidth, 34)];
    textField.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
    textField.layer.cornerRadius = 17;
    textField.textColor = sl_textColors;
    textField.returnKeyType = UIReturnKeySearch;
    textField.layer.masksToBounds = YES;
    textField.font = SLPFFont(__ScaleWidth(14));
    textField.leftView = leftview;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜一搜" attributes:@{NSForegroundColorAttributeName:sl_textSubColors}];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.tintColor = CHHCOLOR_D(0xF0F8F8);
    textField.delegate = self;
    textField.text = _searchText;
    [textField addTarget:self action:@selector(textChange) forControlEvents:
    UIControlEventEditingChanged];
    self.textField = textField;
    [navBar addSubview:textField];
    UIButton *clearBtn =[textField valueForKey:@"_clearButton"];
    [clearBtn setImage:CImage(@"login_clear") forState:BtnNormal];

    [UIView animateWithDuration:.5 animations:^{
        textField.frame = CGRectMake(__ScaleWidth(12), textField.y, SearchTextFieldInputWidth, textField.height);
        
    }];
    [textField becomeFirstResponder];
}

-(void)textChange{
//    NSLog(@"是否改变");
    if ([self.textField.text isEqualToString:@""]) {
        [self.cancelBtn setTitleColor:sl_textSubColors forState:BtnNormal];
    }else{
        [self.cancelBtn setTitleColor:sl_normalColors forState:BtnNormal];
    }
}

- (void)initViews {
    
    UICollectionViewFlowLayout *layout = [[SLSearchingFlowLayout alloc] init];
    layout.minimumInteritemSpacing = __ScaleWidth(20);
    layout.minimumLineSpacing = __ScaleWidth(10);
    layout.sectionInset = UIEdgeInsetsMake(0, __ScaleWidth(12), __ScaleWidth(20), __ScaleWidth(12));
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionV];
    [_collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64 + __kTopAddHeight);
    }];
    [_collectionV setBackgroundColor:SLClearColor];
    _collectionV.dataSource = self;
    _collectionV.delegate = self;
    [_collectionV registerClass:[SLSearchHistoryCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionV registerClass:[SLSeachHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"resultHeader"];
    
    
    
//    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.estimatedRowHeight = 0;
//    _tableView.estimatedSectionHeaderHeight = 0;
//    _tableView.estimatedSectionFooterHeight = 0;
//    _tableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_tableView];
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(0);
//        make.top.mas_equalTo(64 + __kTopAddHeight);
//    }];
}

- (void)cancelAction {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancelSearch)]) {
        [_delegate cancelSearch];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)beginSearchWithText:(NSString *)text {
    if (_type) {
        if (_delegate && [_delegate respondsToSelector:@selector(searchText:)]) {
            [_delegate searchText:text];
        }
    } else {
        BXSLSearchResultVC *vc = [[BXSLSearchResultVC alloc]init];
        vc.searchText = text;
        [self.navigationController pushViewController:vc animated:NO];
    }
    [self cancelAction];
}

- (void)footerViewTapAction {
    if (_isAll || _searchHistorys.count <= 2) {
        [BXSLSearchManager removeSearchHistoryWithSearchText:nil];
        [_searchHistorys removeAllObjects];
    }
    _isAll = !_isAll;
    [_collectionV reloadData];
}

#pragma - mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (IsNilString(textField.text)) {
        [BGProgressHUD showInfoWithMessage:@"请输入搜索内容"];
        return NO;
    }
    
    [self beginSearchWithText:textField.text];
    
    return YES;
}




#pragma - mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isAll) {
        return _searchHistorys.count;
    } else {
        return MIN(2, _searchHistorys.count);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(ws);
    BXSLSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    if (!cell) {
        cell = [[BXSLSearchHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.text = _searchHistorys[indexPath.row];
    cell.removeText = ^(NSString *text) {
        [BXSLSearchManager removeSearchHistoryWithSearchText:text];
        [ws.searchHistorys removeObject:text];
        [tableView reloadData];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!section) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 55)];
        footerView.backgroundColor = UIColorHex(121A1E);
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = CHHCOLOR_D(0x2B3434);
        [footerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(-4);
            make.left.right.mas_equalTo(0);
        }];
        
        UILabel *textLb = [[UILabel alloc]init];
        textLb.font = CFont(14);
        textLb.textColor = CHHCOLOR_D(0x7A8181);
        textLb.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:textLb];
        [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(lineView.mas_top).offset(-15);
            make.height.mas_equalTo(20);
        }];
        
        if (_isAll || _searchHistorys.count <= 2) {
            textLb.text = @"清除全部记录";
        } else {
            textLb.text = @"全部搜索记录";
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
    if (!section && _searchHistorys.count) {
        return 55;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [self beginSearchWithText:_searchHistorys[indexPath.row]];
    }
}
#pragma mark - collectionView 代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (_isAll) {
        return _searchHistorys.count;
//    } else {
//        return MIN(2, _searchHistorys.count);
//    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SLSeachHeaderView * h = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        h = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"resultHeader" forIndexPath:indexPath];
        WS(weakSelf);
        h.cleanBtnOnClickBlock = ^{
            [weakSelf footerViewTapAction];
        };
    }
    
    return h;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SLSearchHistoryCollectionViewCell *cell = (SLSearchHistoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setHistoryString:_searchHistorys[indexPath.row]];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择");
    NSLog(@"%@",_searchHistorys[indexPath.row]);
    [self beginSearchWithText:_searchHistorys[indexPath.row]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = [UILabel getWidthWithTitle:_searchHistorys[indexPath.row] font:SLPFFont(13)];
    
    return CGSizeMake(w + __ScaleWidth(30), __ScaleWidth(30));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(__kWidth, __ScaleWidth(45));
    }
    return CGSizeMake(0, 0);
}

@end

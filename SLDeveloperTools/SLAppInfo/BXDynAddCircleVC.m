//
//  BXDynAddCircleVC.m
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynAddCircleVC.h"
#import "AddCirCleCell.h"
#import "BXDynCircleModel.h"
#import "HttpMakeFriendRequest.h"
#import "NSObject+Tag.h"
#import <ZFPlayer/ZFPlayer.h>
#import "../SLWidget/SLRefreshTool/SLRefreshTools.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "../SLMaskTools/SLMaskTools.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <YYCategories/YYCategories.h>
#import "SLAppInfoConst.h"
#import "SLAppInfoMacro.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface BXDynAddCircleVC ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *issueBtn;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *searchArray;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , assign) BOOL isResh;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger poffset;
@property (nonatomic , assign) BOOL isSearch;

@end

@implementation BXDynAddCircleVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}
#pragma mark - 下拉刷新
- (void)TableDragWithDown {
    self.page = 0;
    [self createData];

}


#pragma mark - 加载更多
- (void)loadMoreData
{
    self.page = self.dataArray.ds_Tag;
    self.isResh = NO;
    [self createData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
    [scrollView zf_scrollViewDidScroll];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [BGProgressHUD showLoadingAnimation:nil inView:self.view];
    self.dataArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    [self setNavView];
    [self searchView];
    [self setcollectionView];
    [self createData];
}
-(void)createData{
    [HttpMakeFriendRequest GetCircleWithCircle_type:@"2" page_index:[NSString stringWithFormat:@"%ld",(long)_page+1] page_size:@"20" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
       NSLog(@"%@", jsonDic);
       if (flag) {
           if (!self.page) {
               [self.dataArray removeAllObjects];
               self.dataArray.ds_Tag = 0;
               self.collectionView.hh_footerView.ignoredScrollViewContentInsetBottom = 0;
               self.collectionView.isNoMoreData = NO;
           }
           NSArray *dataArray1 = jsonDic[@"data"][@"data"];
           if (dataArray1 && dataArray1.count) {
               for (NSDictionary *dic in dataArray1) {
                   BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
                   [model updateWithJsonDic:dic];
                   [self.dataArray addObject:model];
                   
               }
                self.dataArray.ds_Tag++;
           }
       }else{
           [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
       }
      
       [self.collectionView headerEndRefreshing];
       self.collectionView.isRefresh = NO;
       self.collectionView.isNoNetwork = NO;

       [self.collectionView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
        [self.collectionView headerEndRefreshing];
        self.collectionView.isRefresh = NO;
        self.collectionView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
-(void)setcollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
//    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[AddCirCleCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
//    self.collectionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset( - __kBottomAddHeight);
    }];
    [self.collectionView addHeaderWithTarget:self action:@selector(TableDragWithDown)];
    [self.collectionView endRefreshingWithNoMoreData];
    [self TableDragWithDown];


}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"选择圈子";
    _viewTitlelabel.textColor = UIColorHex(#282828);
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];

//    _issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_issueBtn setImage:CImage(@"nav_icon_news_black") forState:BtnNormal];
//    [_issueBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [_issueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _issueBtn.backgroundColor = UIColorHex(#FF2D52);
//    _issueBtn.layer.cornerRadius = 13;
//    _issueBtn.layer.masksToBounds = YES;
//    _issueBtn.alpha = 0.3;
//    _issueBtn.contentMode = UIViewContentModeScaleAspectFit;
//    [self.navView addSubview:_issueBtn];
//    [_issueBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navView);
        make.width.mas_equalTo(__ScaleWidth(72/4*6));
        make.height.mas_equalTo(25);
        make.centerY.equalTo(_navView.mas_bottom).offset(-22);
    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20+__kTopAddHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
//    [_issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-12);
//        make.width.mas_equalTo(52);
//        make.height.mas_equalTo(26);
//        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
//    }];

}
-(void)searchView{
    
    _searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.height.mas_equalTo(34);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(5);
    }];
    [_searchBar layoutIfNeeded];

    _searchBar.layer.cornerRadius = 17;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.keyboardType = UIKeyboardAppearanceDefault;
    _searchBar.placeholder = @"搜索圈子";
    _searchBar.delegate = self;

    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.barStyle = UIBarStyleDefault;
    
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.layer.borderWidth = 1;
    _searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    
//    UIImage * searchBarBg = [UIImage new];
//    [self.searchBar setBackgroundImage:searchBarBg];
//    [self.searchBar setBackgroundColor:UIColorHex(#F5F9FC)];
//    [self.searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
//    self.searchBar.layer.cornerRadius = 17.0f;
//    self.searchBar.layer.masksToBounds = YES;
    
    UITextField * searchField = [self.searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = UIColorHex(#F5F9FC);
    searchField.layer.masksToBounds = YES;
    searchField.layer.cornerRadius = 18;
    UIButton * clearBtn = [searchField valueForKey:@"_clearButton"];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}

#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isSearch) {
        return self.searchArray.count;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AddCirCleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.isSearch) {
        
        cell.model = self.searchArray[indexPath.row];
    }else{
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearch) {
        if (self.SelCircleBlock) {
            self.SelCircleBlock([self.searchArray[indexPath.row] circle_id], [self.searchArray[indexPath.row] circle_name]);
            [self pop];
        }
    }else{
        if (self.SelCircleBlock) {
             self.SelCircleBlock([self.dataArray[indexPath.row] circle_id], [self.dataArray[indexPath.row] circle_name]);
             [self pop];
         }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    return CGSizeMake( ( __ScaleWidth(375)  - 48 ) / 3, __ScaleWidth(153));

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
        return 12;
 
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

        return 0;

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(12, 12, 12, 12);
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [HttpMakeFriendRequest SearceCircleWithCircle_type:@"2" page_index:@"1" page_size:@"50" key_words:searchBar.text Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        
        NSLog(@"%@", jsonDic);
        if (flag) {
            [self.searchArray removeAllObjects];
            NSArray *dataArray1 = jsonDic[@"data"][@"data"];
            if (dataArray1 && dataArray1.count) {
                for (NSDictionary *dic in dataArray1) {
                    BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
                    [model updateWithJsonDic:dic];
                    [self.searchArray addObject:model];
                    
                }
            }else{
                [BGProgressHUD showInfoWithMessage:@"未搜到圈子"];
            }
        }else{
            [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
        }
        self.isSearch = YES;
        [self.collectionView headerEndRefreshing];
        self.collectionView.isRefresh = NO;
        self.collectionView.isNoNetwork = NO;
        [self.collectionView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
        self.isSearch = NO;
        [self.collectionView headerEndRefreshing];
        self.collectionView.isRefresh = NO;
        self.collectionView.isNoNetwork = !error.isNetWorkConnectionAvailable;
    }];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
   
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

   
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}
-(void)clearBtnClick{
    [self.searchArray removeAllObjects];
    self.isSearch = NO;
    [self.collectionView reloadData];
}
-(void)AddClick{
    
}
-(void)backClick{
    [self pop];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页面状态"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"还没有圈子哦";
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
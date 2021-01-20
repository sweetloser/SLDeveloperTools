//
//  BXDynSearchTopicVC.m
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynSearchTopicVC.h"
#import "BXDynTopicSquareCell.h"
#import "BXDynTopicSearchCell.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynTopicModel.h"
#import "BXDynSynTopicCategoryVC.h"
#import "BXPersonFlowLayout.h"
#import "TopicUICollectionViewFlowLayout.h"
#import "../SLMaskTools/SLMaskTools.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "../SLMacro/SLMacro.h"
#import <Masonry/Masonry.h>
#import "SLAppInfoMacro.h"
#import <YYCategories/YYCategories.h>
#import <SDAutoLayout/SDAutoLayout.h>

@interface BXDynSearchTopicVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *searchDataArray;
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;

@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)NSString *searchString;

@property(nonatomic, strong)UILabel *RemenLabel;
@property(nonatomic, strong)UILabel *NewHuatiLabel;
@property(nonatomic, strong)UILabel *RecommendLabel;

@property(nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *HistoryDataArray;
@property (nonatomic,strong)NSMutableArray *titleDataArray;
@property (nonatomic,strong)NSMutableArray *topicDataArray;
@property (nonatomic,strong)NSMutableDictionary *topicDictionary;

@property(nonatomic, strong)UICollectionReusableView *HistoryView;
@property(nonatomic, strong)UICollectionReusableView *NewView;
@property(nonatomic, strong)UIButton *deleteBtn;



@end

@implementation BXDynSearchTopicVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}
-(void)createData{
    [HttpMakeFriendRequest GetTopicWithpage_index:@"1" page_size:@"6" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
//            NSArray *newdataArray = jsonDic[@"data"];
            self.topicDataArray = jsonDic[@"data"];
//            if (newdataArray && newdataArray.count) {
//                for (NSDictionary *dic in newdataArray) {
//                    NSArray *array1 = dic[@"data"];
//                    if (array1 && array1.count) {
//                        for (NSDictionary *topicdic in array1) {
//                            BXDynTopicModel *model = [[BXDynTopicModel alloc]init];
//                            [model updateWithJsonDic:topicdic];
//                            [self.topicDataArray addObject:model];
//                        }
//                        [self.topicDictionary setValue:self.topicDataArray forKey:dic[@"name"]];
//                    }
//                    [self.topicDictionary setValue:dic[@"data"] forKey:@"name"];
//                }
//            }
            [self.collectionView reloadData];
        }else{
            [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
        }
    } Failure:^(NSError * _Nonnull error) {

    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavView];
    [self searchView];
    [self createCollectionView];

    _HistoryDataArray = [NSMutableArray arrayWithArray:@[@"你哈皮", @"你好", @"lalallalalalala", @"哈哈哈哈", @"fandigang", @"meilijian哈"]];
    _titleDataArray = [[NSMutableArray alloc]init];
    _topicDataArray = [[NSMutableArray alloc]init];
    _searchDataArray = [[NSMutableArray alloc]init];
    _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = [[UIView alloc]init];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset( - __kBottomAddHeight);
    }];
    _tableview.hidden = YES;
    [self createData];
    

    
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"搜索话题";
    _viewTitlelabel.textColor = UIColorHex(#282828);
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];


    
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


}
-(void)createCollectionView{
    BXPersonFlowLayout *layout = [[BXPersonFlowLayout alloc] init];
    layout.cellType = AlignWithLeft;
    layout.betweenOfCell = 12;
//     layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 6, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[BXDynTopicSearchCell class] forCellWithReuseIdentifier:@"BXDynTopciCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HistoryView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewView"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-__kBottomAddHeight);
    }];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.searchDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableview];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BXDynTopicSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil){
        cell = [[BXDynTopicSquareCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.huatiLabel.text = [self.searchDataArray[indexPath.row] topic_name];
    cell.huatiNumLabel.text = [NSString stringWithFormat:@"%@条动态", [self.searchDataArray[indexPath.row] dynamic]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BXDynSynTopicCategoryVC *vc = [[BXDynSynTopicCategoryVC alloc]init];
    vc.model = self.searchDataArray[indexPath.row];
    [self pushVc:vc];
}


#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.topicDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (section == 0) {
//        return _HistoryDataArray.count;
//    }
//    if (section == 1) {
//        return _HistoryDataArray.count;
//        return [[self.topicDictionary objectForKey:@"name"][section] objectForKey:@"2"]];
//    }
    
    return [[self.topicDataArray[section] objectForKey:@"data"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BXDynTopicSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXDynTopciCell" forIndexPath:indexPath];
//    cell.model = [[BXDynNewModel alloc]init];
//    if (indexPath.section == 0) {
//        cell.topicStr = _HistoryDataArray[indexPath.row];
//    }
//    if (indexPath.section == 1) {
//        cell.topicStr = [self.NewDataArray[indexPath.row] topic_name];
//    }
    cell.topicStr = [[self.topicDataArray[indexPath.section] objectForKey:@"data"][indexPath.row] objectForKey:@"topic_name"];
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        BXDynSynTopicCategoryVC *vc = [[BXDynSynTopicCategoryVC alloc]init];
        BXDynTopicModel *model = [BXDynTopicModel new];
        [model updateWithJsonDic:[self.topicDataArray[indexPath.section] objectForKey:@"data"][indexPath.row]];
        vc.model = model;
        [self pushVc:vc];
    }
    else{
        BXDynSynTopicCategoryVC *vc = [[BXDynSynTopicCategoryVC alloc]init];
        BXDynTopicModel *model = [BXDynTopicModel new];
        [model updateWithJsonDic:[self.topicDataArray[indexPath.section] objectForKey:@"data"][indexPath.row]];
        vc.model = model;
        [self pushVc:vc];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//
//        NSString *str = _HistoryDataArray[indexPath.row];
//        CGFloat width = [str widthForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12]];
//        CGFloat height = 0;
//        if (width > 300) {
//            width = 300;
//            height = [str heightForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12] width:300];
//            return CGSizeMake(width + 30, height + 15);
//        }
//        return CGSizeMake(width + 30, 30);
//    }
//    if (indexPath.section == 1) {
        
        NSString *str = [[self.topicDataArray[indexPath.section] objectForKey:@"data"][indexPath.row] objectForKey:@"topic_name"];
        CGFloat width = [str widthForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12]];
        CGFloat height = 0;
        if (width > 300) {
            width = 300;
            height = [str heightForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12] width:300];
            return CGSizeMake(width + 30, height + 15);
        }
        return CGSizeMake(width + 30, 30);
//    }
//    return CGSizeMake(0, 0);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}


//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(5, 12, 15, 0);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
//        if (indexPath.section == 0) {
//            _HistoryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HistoryView" forIndexPath:indexPath];
//
//            UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 40, 20)];
//            titlelabel.text = @"历史";
//            titlelabel.textAlignment = 0;
//            titlelabel.textColor = UIColorHex(#8C8C8C);
//            titlelabel.font = [UIFont systemFontOfSize:14];
//            [_HistoryView addSubview:titlelabel];
//
//            _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            _deleteBtn.frame = CGRectMake(_HistoryView.frame.size.width - 22, 10, 10, 10);
//            [_deleteBtn setImage:CImage(@"icon_dyn_topic_delete") forState:UIControlStateNormal];
//            [_deleteBtn addTarget:self action:@selector(DeleteHistoryAct) forControlEvents:UIControlEventTouchUpInside];
//            [_HistoryView addSubview:_deleteBtn];
//            return _HistoryView;
//        }
//        else if (indexPath.section == 1) {

            UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"NewView" forIndexPath:indexPath];
            UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 60, 20)];
            titlelabel.text = [self.topicDataArray[indexPath.section] objectForKey:@"name"];
            titlelabel.textAlignment = 0;
            titlelabel.textColor = UIColorHex(#8C8C8C);
            titlelabel.font = [UIFont systemFontOfSize:14];
            [headView addSubview:titlelabel];
            return headView;
//        }
    }
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
//    if (section == 0 && _HistoryDataArray.count) {
//        
//        return CGSizeMake(SCREEN_WIDTH, 30);
//    }
//    if (section == 1 && _NewDataArray.count) {
        
        return CGSizeMake(SCREEN_WIDTH, 30);
//    }
//        return CGSizeMake(0, 0);

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
    _searchBar.placeholder = @"输入话题";
    _searchBar.delegate = self;

    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.barStyle = UIBarStyleDefault;
    
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.layer.borderWidth = 1;
    _searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    
//    UIImage * searchBarBg = [UIImage new];
//    [self.searchBar setBackgroundImage:searchBarBg];
//    [self.searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
//    [self.searchBar setBackgroundColor:UIColorHex(#F5F9FC)];
//    [[[self.searchBar.subviews objectAtIndex:0].subviews objectAtIndex:1] setBackgroundColor:UIColorHex(#F5F9FC)];
//    [[self.searchBar.subviews objectAtIndex:0].subviews objectAtIndex:1].layer.cornerRadius = 17.0f;
//    [[self.searchBar.subviews objectAtIndex:0].subviews objectAtIndex:1].layer.masksToBounds = YES;
    
    
//
//    UIView *segment = [self.searchBar.subviews objectAtIndex:0];
//    [segment removeFromSuperview];
    


//    [self.searchBar.subviews objectAtIndex:0].backgroundColor = [UIColor clearColor];
//    self.searchBar.backgroundColor = UIColorHex(#F5F9FC);
    UITextField * searchField = [self.searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = UIColorHex(#F5F9FC);
    searchField.layer.masksToBounds = YES;
    searchField.layer.cornerRadius = 18;
    UIButton * clearBtn = [searchField valueForKey:@"_clearButton"];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    

    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if ([searchBar.text isEqualToString:@""]) {
        self.tableview.hidden = YES;
    }else{
        self.tableview.hidden = NO;
    }
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if ([searchBar.text isEqualToString:@""]) {
        self.tableview.hidden = YES;
        [self.searchDataArray removeAllObjects];
        [self.tableview reloadData];
    }else{
        self.tableview.hidden = NO;
    }
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchBar.text isEqualToString:@""]) {
        self.tableview.hidden = YES;
        [self.searchDataArray removeAllObjects];
    }
    else {
         self.tableview.hidden = NO;
        [self.searchDataArray removeAllObjects];
        [HttpMakeFriendRequest SearceTopicWithpage_index:@"1" page_size:@"50" keyword:searchText Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            if (flag) {
                NSArray *hotdataArray = jsonDic[@"data"][@"data"];
                if (hotdataArray && hotdataArray.count) {
                    for (NSDictionary *dic in hotdataArray) {
                        BXDynTopicModel *model = [[BXDynTopicModel alloc]init];
                        [model updateWithJsonDic:dic];
                        [self.searchDataArray addObject:model];
                    }
                }
                else{
                    [BGProgressHUD showInfoWithMessage:@"未搜索到该话题"];
                    self.searchString = searchText;
                }
            }else{
                self.searchString = searchText;

                [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
            }
            [self.tableview reloadData];
        } Failure:^(NSError * _Nonnull error) {
            self.searchString = searchText;
            [self.tableview reloadData];
        }];
    }
}
-(void)clearBtnClick{
    [self.searchDataArray removeAllObjects];
    [self.searchBar resignFirstResponder];
    self.tableview.hidden = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
-(void)DeleteHistoryAct{
    [_HistoryDataArray removeAllObjects];
    [self.collectionView reloadData];
}
-(void)AddClick{
    
}
-(void)backClick{
    [self pop];
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

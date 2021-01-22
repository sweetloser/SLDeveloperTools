//
//  AddHuaTiFooterView.m
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "AddHuaTiFooterView.h"
#import "AddHuaTiCell.h"
#import "BXPersonFlowLayout.h"
#import "BXDynTopicSearchCell.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynTopicModel.h"
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <YYCategories/YYCategories.h>

@interface AddHuaTiFooterView()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *ItemArray;


@property(nonatomic, strong)NSString *searchString;
@property(nonatomic, assign)BOOL getSearch;

@property(nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *HotDataArray;
@property (nonatomic,strong)NSMutableArray *NewDataArray;
@property (nonatomic,strong)NSMutableDictionary *topicDic;
@property (nonatomic,strong)NSMutableArray *searchDataArray;


@property(nonatomic, strong)UICollectionReusableView *HotView;
@property(nonatomic, strong)UICollectionReusableView *NewView;
@end
@implementation AddHuaTiFooterView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self searchView];
        [self createCollectionView];
        [self initView];
        [self createData];
    }
    return self;
}
-(void)setAddDataArray:(NSMutableArray *)AddDataArray{
    _AddDataArray = AddDataArray;
}
-(void)createData{
    [HttpMakeFriendRequest GetTopicWithpage_index:@"1" page_size:@"6" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
            self.topicDic = jsonDic[@"data"];
            [self.collectionView reloadData];
        }else{
            [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}
-(void)initView{
       _ItemArray = [[NSMutableArray alloc]init];

    _HotDataArray = [[NSMutableArray alloc]init];
    _NewDataArray = [[NSMutableArray alloc]init];
    _topicDic = [[NSMutableDictionary alloc]init];
    _AddDataArray = [[NSMutableArray alloc]init];
    _searchDataArray = [[NSMutableArray alloc]init];
    _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = [[UIView alloc]init];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(- __kBottomAddHeight);
    }];
    _tableview.hidden = YES;
}
-(void)createCollectionView{
    BXPersonFlowLayout *layout = [[BXPersonFlowLayout alloc] init];
    layout.cellType = AlignWithLeft;
    layout.betweenOfCell = 20;
//     layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 6, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[BXDynTopicSearchCell class] forCellWithReuseIdentifier:@"BXDynTopciCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HotView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewView"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-__kBottomAddHeight);
    }];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_searchDataArray.count) {
        return self.searchDataArray.count;
    }
    if ([_searchString isEqualToString:@""] || !_searchString) {
        return 0;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableview];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddHuaTiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil){
        cell = [[AddHuaTiCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.searchDataArray.count) {
        cell.topicname = [self.searchDataArray[indexPath.row] topic_name];
        cell.createLabel.hidden = YES;
        cell.topicNumLabel.hidden = NO;
        cell.topicNum = [NSString stringWithFormat:@"%@", [self.searchDataArray[indexPath.row] hot]] ;
    }else{
        
        cell.topicname = _searchString;
        cell.createLabel.hidden = NO;
        cell.topicNumLabel.hidden = YES;
    }
    WS(weakSelf);
    cell.CreateHuaTi = ^(NSString * _Nonnull text) {
        if (self.AddDataArray.count > weakSelf.MAXNum || self.itemNum >= weakSelf.MAXNum) {
            [BGProgressHUD showInfoWithMessage:[NSString stringWithFormat:@"最多只能添加%ld个话题哦", (long)weakSelf.MAXNum]];
            return;
        }

        [self createTopic:text];
    };
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchDataArray.count) {
        if (self.AddDataArray.count > self.MAXNum || self.itemNum >= self.MAXNum) {
            [BGProgressHUD showInfoWithMessage:[NSString stringWithFormat:@"最多只能添加%ld个话题哦", (long)self.MAXNum]];
            return;
        }
        if (self.DidItemIndex) {
            
            self.DidItemIndex([self.searchDataArray[indexPath.row] topic_name], [self.searchDataArray[indexPath.row] topic_id]);
            [self.AddDataArray addObject:[self.searchDataArray[indexPath.row] topic_name]];
            self.itemNum++;
            [self.searchBar resignFirstResponder];
            self.tableview.hidden = YES;
        }
    }
}

#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.topicDic.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (section == 0) {
//        return _HotDataArray.count;
//    }
//    if (section == 1) {
//        return _NewDataArray.count;
//    }
//  return [[self.topicDic[section] objectForKey:@"data"] count];
    
    NSArray *arr = [self.topicDic allKeys];
    return [_topicDic[arr[section]] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BXDynTopicSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXDynTopciCell" forIndexPath:indexPath];
//    cell.model = [[BXDynNewModel alloc]init];
//    if (indexPath.section == 0) {
//        cell.topicStr = [_HotDataArray[indexPath.row] topic_name];
//    }
//    if (indexPath.section == 1) {
//        cell.topicStr = [_NewDataArray[indexPath.row] topic_name];
//    }
    NSArray *arr = [self.topicDic allKeys];
    cell.topicStr = [_topicDic[arr[indexPath.section]][indexPath.row] objectForKey:@"topic_name"];
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [self.topicDataArray[indexPath.section] objectForKey:@"data"][indexPath.row];
//    if (indexPath.section == 0) {
//        if (self.DidItemIndex) {
//            if (self.AddDataArray.count > 3 || self.itemNum >= 3) {
//                [BGProgressHUD showInfoWithMessage:@"最多只能添加三个话题哦"];
//                return;
//            }
//            self.DidItemIndex([self.HotDataArray[indexPath.row] topic_name], [self.HotDataArray[indexPath.row] topic_id]);
//            [self.AddDataArray addObject:[self.HotDataArray[indexPath.row] topic_name]];
//            self.itemNum++;
//        }
//    }
//    if (indexPath.section == 1) {
        if (self.DidItemIndex) {
//            if (self.AddDataArray.count > 3 || self.itemNum >= 3) {
//                [BGProgressHUD showInfoWithMessage:@"最多只能添加三个话题哦"];
//                return;
//            }
            NSArray *arr = [self.topicDic allKeys];
            self.DidItemIndex([_topicDic[arr[indexPath.section]][indexPath.row] objectForKey:@"topic_name"], [_topicDic[arr[indexPath.section]][indexPath.row] objectForKey:@"topic_id"]);
            
//            [self.AddDataArray addObject:[[self.topicDataArray[indexPath.section] objectForKey:@"data"][indexPath.row] objectForKey:@"topic_name"]];
//            self.itemNum++;
        }
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//
//        NSString *str = [_HotDataArray[indexPath.row] topic_name];
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
//
//        NSString *str = [_NewDataArray[indexPath.row] topic_name];
//        CGFloat width = [str widthForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12]];
//        CGFloat height = 0;
//        if (width > 300) {
//            width = 300;
//            height = [str heightForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12] width:300];
//            return CGSizeMake(width + 30, height + 15);
//        }
//        return CGSizeMake(width + 30, 30);
//    }
//    return CGSizeMake(0, 0);
    
    NSArray *arr = [self.topicDic allKeys];
    
    NSString *str = [_topicDic[arr[indexPath.section]][indexPath.row] objectForKey:@"topic_name"];
    CGFloat width = [str widthForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12]];
    CGFloat height = 0;
    if (width > 300) {
        width = 300;
        height = [str heightForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12] width:300];
        return CGSizeMake(width + 30, height + 15);
    }
    return CGSizeMake(width + 30, 30);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}


//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(5, 12, 15, 12);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
//        if (indexPath.section == 0) {
//            _HotView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HotView" forIndexPath:indexPath];
//
//            UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 60, 20)];
//            titlelabel.text = @"热门话题";
//            titlelabel.textAlignment = 0;
//            titlelabel.textColor = UIColorHex(#8C8C8C);
//            titlelabel.font = [UIFont systemFontOfSize:14];
//            [_HotView addSubview:titlelabel];
//
//
//            return _HotView;
//        }
//        else if (indexPath.section == 1) {
//
//            _NewView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"NewView" forIndexPath:indexPath];
//            UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 60, 20)];
//            titlelabel.text = @"最新话题";
//            titlelabel.textAlignment = 0;
//            titlelabel.textColor = UIColorHex(#8C8C8C);
//            titlelabel.font = [UIFont systemFontOfSize:14];
//            [_NewView addSubview:titlelabel];
//            return _NewView;
//        }
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"NewView" forIndexPath:indexPath];
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 60, 20)];
        if (indexPath.section == 0) {
            titlelabel.text = @"热门话题";
        }
        if (indexPath.section == 1) {
            titlelabel.text = @"最新话题";
        }
        if (indexPath.section == 2) {
            titlelabel.text = @"推荐话题";
        }
        
        titlelabel.textAlignment = 0;
        titlelabel.textColor = UIColorHex(#8C8C8C);
        titlelabel.font = [UIFont systemFontOfSize:14];
        [headView addSubview:titlelabel];
        return headView;
    }
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
//    if (section == 0 && _HotDataArray.count) {
//
//        return CGSizeMake(SCREEN_WIDTH, 30);
//    }
//    if (section == 1 && _NewDataArray.count) {
        
        return CGSizeMake(SCREEN_WIDTH, 30);
//    }
//        return CGSizeMake(0, 0);

}
-(void)createTopic:(NSString *)topic_name{
    WS(weakSelf);
    [HttpMakeFriendRequest AddTopicWithtopic_name:topic_name Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
            if (flag) {
                if (self.DidItemIndex) {
                    self.DidItemIndex(topic_name, [NSString stringWithFormat:@"%@", jsonDic[@"data"][@"topic_id"]]);
//                    [self.AddDataArray addObject:topic_name];
//                    self.itemNum++;
                }
                weakSelf.searchBar.text = @"";
                [weakSelf clearBtnClick];
            }else{
                [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
            }
        } Failure:^(NSError * _Nonnull error) {
            [BGProgressHUD showInfoWithMessage:@"添加失败"];
        }];
}

-(void)searchView{
    
    _searchBar = [[UISearchBar alloc]init];
    [self addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(34);
        make.top.mas_equalTo(self.mas_top).offset(5);
    }];
    [_searchBar layoutIfNeeded];

    _searchBar.layer.cornerRadius = 20;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.keyboardType = UIKeyboardAppearanceDefault;
    _searchBar.placeholder = @"输入话题";
    _searchBar.delegate = self;

    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.barStyle = UIBarStyleDefault;
    
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.layer.borderWidth = 1;
    _searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UITextField * searchField = [self.searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = UIColorHex(#F5F9FC);
    searchField.layer.masksToBounds = YES;
    searchField.layer.cornerRadius = 18;
    UIButton * clearBtn = [searchField valueForKey:@"_clearButton"];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImage * searchBarBg = [UIImage new];
//    [self.searchBar setBackgroundImage:searchBarBg];
//    [self.searchBar setBackgroundColor:UIColorHex(#F5F9FC)];
//    [self.searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
//    self.searchBar.layer.cornerRadius = 17.0f;
//    self.searchBar.layer.masksToBounds = YES;

    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
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
        self.searchString = @"";
        [self.searchDataArray removeAllObjects];
        [self.tableview reloadData];
    }else{
        self.tableview.hidden = NO;
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchBar.text isEqualToString:@""]) {
        self.tableview.hidden = YES;
        self.searchString = @"";
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
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.searchBar resignFirstResponder];
//}
@end

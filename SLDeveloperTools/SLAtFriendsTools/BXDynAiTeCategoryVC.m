//
//  BXDynAiTeCategoryVC.m
//  BXlive
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynAiTeCategoryVC.h"
#import "JXGradientView.h"
#import "JXCategoryView.h"
#import "BXDynAiTeVC.h"
#import "BXDynAiTeCell.h"
#import "HttpMakeFriendRequest.h"
#import "DynAiTeFriendModel.h"
#import "UIView+SLExtension.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>


@interface BXDynAiTeCategoryVC ()<UISearchBarDelegate,JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property(strong, nonatomic)NSArray<NSString *> *menuTitleArray;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)NSString *searchString;
@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *issueBtn;

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic, strong)NSMutableArray *selArray;
@end

@implementation BXDynAiTeCategoryVC
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
       _menuTitleArray = [NSMutableArray arrayWithObjects:@"最近联系",@"我的关注",@"我的粉丝",nil];
    [self setNavView];
    [self searchView];
    [self setJXView];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = [[UIView alloc]init];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        [self.searchBar resignFirstResponder];
//    }];
//    [_tableview addGestureRecognizer:tap];
//    _tableview.userInteractionEnabled = YES;
    [self.view addSubview:self.tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(100);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(- 64.0 - __kTopAddHeight - 49 - __kBottomAddHeight);
    }];
    self.dataArray = [NSMutableArray array];
    self.selArray = [NSMutableArray array];
    _tableview.hidden = YES;
  
    
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"选择好友";
    _viewTitlelabel.textColor = sl_textColors;
    _viewTitlelabel.textAlignment = NSTextAlignmentCenter;
    _viewTitlelabel.font = SLBFont(18);
    [_navView addSubview:_viewTitlelabel];
    
   UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];
    
    _issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_issueBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [_issueBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
    _issueBtn.backgroundColor = DynUnSendButtonBackColor;
    
    
    _issueBtn.layer.cornerRadius = 13;
    _issueBtn.layer.masksToBounds = YES;
    _issueBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.navView addSubview:_issueBtn];
    [_issueBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_viewTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navView);
        make.left.mas_equalTo(44);
        make.right.mas_equalTo(-44);
        make.height.mas_equalTo(25);
        make.centerY.equalTo(_navView.mas_bottom).offset(-22);
    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__ScaleWidth(0));
        make.width.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
    }];
    
    [_issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    self.issueBtn.userInteractionEnabled = NO;

}
-(void)searchView{
    
    _searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(__ScaleWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(-__ScaleWidth(12));
        make.height.mas_equalTo(__ScaleWidth(34));
        make.top.mas_equalTo(self.navView.mas_bottom).offset(__ScaleWidth(10));
    }];
//    _searchBar.layer.cornerRadius = __ScaleWidth(17);
//    _searchBar.layer.masksToBounds = YES;
    _searchBar.keyboardType = UIKeyboardAppearanceDefault;
    _searchBar.placeholder = @"搜索好友";
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.tintColor = sl_normalColors;
    UIView* backgroundView = [_searchBar subViewOfClassName:@"UISearchBarTextField"];
    if (backgroundView) {
        backgroundView.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
        backgroundView.layer.cornerRadius = __ScaleWidth(17);
        backgroundView.clipsToBounds = YES;
        UITextField *searchTF = (UITextField *)backgroundView;
        searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索好友" attributes:@{NSForegroundColorAttributeName: [UIColor sl_colorWithHex:0xB2B2B2],NSFontAttributeName: SLPFFont(__ScaleWidth(14))}];
        
        
    }
}
-(void)setJXView{

    _categoryView = [[JXCategoryTitleView alloc] init];
    _categoryView.titles = _menuTitleArray;
    _categoryView.cellSpacing = 0;
    _categoryView.cellWidth = __kWidth / 3.0;
//    _categoryView.averageCellSpacingEnabled = NO;
//    _categoryView.contentEdgeInsetLeft = 30;
//    _categoryView.contentEdgeInsetRight = 30;

    _categoryView.titleFont = SLPFFont(16);
    _categoryView.titleColor = sl_textSubColors;
    _categoryView.titleSelectedColor = sl_textColors;
    _categoryView.titleSelectedFont = SLBFont(16);
    _categoryView.titleColorGradientEnabled = YES;
    _categoryView.delegate = self;
    [self.view addSubview:_categoryView];
    [_categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(-0);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(45);
        make.height.mas_equalTo(40);
    }];

    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = _listContainerView;
    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
//    [self.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
//    self.listContainerView.frame = CGRectMake(0, 64+__kTopAddHeight + 44, self.view.bounds.size.width, self.view.bounds.size.height - 64.0 - __kTopAddHeight - 49 - __kBottomAddHeight);
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.categoryView.mas_bottom).offset(4);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-__kBottomAddHeight);
    }];
}
#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    WS(weakSelf);
    if (index == 0) {
        BXDynAiTeVC<JXCategoryListContentViewDelegate> *vc = nil;
        vc = [[BXDynAiTeVC alloc]init];
        vc.friendType = @"1";
        vc.aite_type = self.aite_type;
        vc.friendArray =self.friendArray;
        vc.SelFriendBlock = ^(NSString * _Nonnull user_id, NSString * _Nonnull user_name, BOOL isSelect) {
            if (isSelect) {
                [weakSelf.selArray addObject:@{@"user_id":user_id, @"user_name":user_name}];
            }else{
                [weakSelf.selArray removeObject:@{@"user_id":user_id, @"user_name":user_name}];
            }
            if (weakSelf.selArray.count) {
                [weakSelf.issueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakSelf.issueBtn.backgroundColor = [UIColor sl_colorWithHex:0xFF2D52];
                weakSelf.issueBtn.userInteractionEnabled = YES;
            }else{
                [weakSelf.issueBtn setTitleColor:[UIColor sl_colorWithHex:0x8C8C8C] forState:UIControlStateNormal];
                weakSelf.issueBtn.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
                weakSelf.issueBtn.userInteractionEnabled = NO;
            }
            

        };
        vc.ExpressFriendBlock = ^(NSString * _Nonnull user_id, NSString * _Nonnull user_name) {
            if (weakSelf.ExpressFriendBlock) {
                weakSelf.ExpressFriendBlock(user_id, user_name);
                [weakSelf pop];
            }
        };
        [self addChildViewController:vc];
        return vc;
    }
    else if (index == 1) {
        BXDynAiTeVC<JXCategoryListContentViewDelegate> *vc = nil;
        vc = [[BXDynAiTeVC alloc]init];
        vc.friendType = @"2";
        vc.friendArray = self.friendArray;
        vc.aite_type = self.aite_type;
        vc.SelFriendBlock = ^(NSString * _Nonnull user_id, NSString * _Nonnull user_name, BOOL isSelect) {
            if (isSelect) {
                
                if (weakSelf.selArray.count) {
                    for (int i = 0; i< weakSelf.selArray.count; i++) {
                        if ([[NSString stringWithFormat:@"%@", user_id] isEqualToString:[weakSelf.selArray[i] objectForKey:@"user_id"]]) {
                            [weakSelf.selArray removeObjectAtIndex:i];
                        }
                    }
                }
                [weakSelf.selArray addObject:@{@"user_id":user_id, @"user_name":user_name}];
            }else{
                [weakSelf.selArray removeObject:@{@"user_id":user_id, @"user_name":user_name}];
            }
            if (weakSelf.selArray.count) {
                
                [weakSelf.issueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakSelf.issueBtn.backgroundColor = [UIColor sl_colorWithHex:0xFF2D52];
                weakSelf.issueBtn.userInteractionEnabled = YES;
            }else{
                [weakSelf.issueBtn setTitleColor:[UIColor sl_colorWithHex:0x8C8C8C] forState:UIControlStateNormal];
                weakSelf.issueBtn.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];

                weakSelf.issueBtn.userInteractionEnabled = NO;
            }
            
//            if (weakSelf.SelFriendBlock) {
//                weakSelf.SelFriendBlock(user_id, user_name);
//                [weakSelf pop];
//            }
        };
        vc.ExpressFriendBlock = ^(NSString * _Nonnull user_id, NSString * _Nonnull user_name) {
             if (weakSelf.ExpressFriendBlock) {
                 weakSelf.ExpressFriendBlock(user_id, user_name);
                 [weakSelf pop];
             }
         };
        [self addChildViewController:vc];
        return vc;
    }
    else{
        BXDynAiTeVC<JXCategoryListContentViewDelegate> *vc = nil;
        vc = [[BXDynAiTeVC alloc]init];
        vc.friendType = @"3";
        vc.friendArray = self.friendArray;
        vc.aite_type = self.aite_type;
        vc.SelFriendBlock = ^(NSString * _Nonnull user_id, NSString * _Nonnull user_name, BOOL isSelect) {
            
            if (isSelect) {
                if (weakSelf.selArray.count) {
                        for (int i = 0; i< weakSelf.selArray.count; i++) {
                            if ([[NSString stringWithFormat:@"%@", user_id] isEqualToString:[weakSelf.selArray[i] objectForKey:@"user_id"]]) {
                                [weakSelf.selArray removeObjectAtIndex:i];
                            }
                        }
                    }
                [weakSelf.selArray addObject:@{@"user_id":user_id, @"user_name":user_name}];
            }else{
                [weakSelf.selArray removeObject:@{@"user_id":user_id, @"user_name":user_name}];
            }
            NSLog(@"%@", weakSelf.selArray);
            if (weakSelf.selArray.count) {
                
                [weakSelf.issueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakSelf.issueBtn.backgroundColor = [UIColor sl_colorWithHex:0xFF2D52];
                weakSelf.issueBtn.userInteractionEnabled = YES;
            }else{
                [weakSelf.issueBtn setTitleColor:[UIColor sl_colorWithHex:0x8C8C8C] forState:UIControlStateNormal];
                weakSelf.issueBtn.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
                weakSelf.issueBtn.userInteractionEnabled = NO;
            }
//            if (weakSelf.SelFriendBlock) {
//                weakSelf.SelFriendBlock(user_id, user_name);
//                [weakSelf pop];
//            }
        };
        vc.ExpressFriendBlock = ^(NSString * _Nonnull user_id, NSString * _Nonnull user_name) {
             if (weakSelf.ExpressFriendBlock) {
                 weakSelf.ExpressFriendBlock(user_id, user_name);
                 [weakSelf pop];
             }
         };
        [self addChildViewController:vc];
        return vc;
    }

}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.menuTitleArray.count;
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.view bringSubviewToFront:_categoryView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_searchString isEqualToString:@""] || !_searchString) {
        return 0;
    }
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:_tableview];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BXDynAiTeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil){
        cell = [[BXDynAiTeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
//    cell.huatiLabel.text = _searchString;
//
//    cell.CreateHuaTi = ^(NSString * _Nonnull text) {
//                if (self.DidItemIndex) {
//            self.DidItemIndex(text);
//        }
//    };
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *user_id = [self.dataArray[indexPath.row] user_id];
    NSString *user_name = [self.dataArray[indexPath.row] nickname];
    if (self.friendArray.count) {
        for (int i = 0; i< self.friendArray.count; i++) {
            NSString *friendid = [NSString stringWithFormat:@"%@",[self.friendArray[i] objectForKey:@"user_id"]];
            if ([[NSString stringWithFormat:@"%@", [self.dataArray[indexPath.row] user_id]] isEqualToString:friendid]) {
                [BGProgressHUD showInfoWithMessage:@"您已@过该好友了"];
                return;
            }
        }
    }
    if (self.ExpressFriendBlock) {
        self.ExpressFriendBlock(user_id, [NSString stringWithFormat:@"@%@ ",user_name]);
        [self pop];
    }
    if (self.selectFriendArray) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@{@"user_id":user_id, @"user_name":user_name}];
        self.selectFriendArray(array);
        [self pop];
    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [BGProgressHUD showLoadingAnimation];
    [HttpMakeFriendRequest SearchFriendWithKey_words:searchBar.text Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        [BGProgressHUD hidden];
        if(flag)
        {
            [self.dataArray removeAllObjects];
            NSArray *followArray = jsonDic[@"data"];
            if (followArray.count) {
                for (NSDictionary *fdict in followArray) {
                    DynAiTeFriendModel *model = [[DynAiTeFriendModel alloc]init];
                    [model updateWithJsonDic:fdict];
                    [self.dataArray addObject:model];
                }
            }
            else{
                [BGProgressHUD showInfoWithMessage:@"未搜到好友"];
            }
        }
        else{
            [BGProgressHUD showInfoWithMessage:[jsonDic valueForKey:@"msg"]];
        }
        [self.tableview reloadData];
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD hidden];
         [BGProgressHUD showInfoWithMessage:@"搜索失败"];
    }];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

        self.tableview.hidden = YES;

    [self.dataArray removeAllObjects];
    [self.tableview reloadData];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.tableview.hidden = NO;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _searchString = searchText;
//    [self.tableview reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}
-(void)AddClick{

    if (self.selectFriendArray) {
        self.selectFriendArray(self.selArray);
    }
    
    if (self.presentingViewController && (self.navigationController == nil || self.navigationController.viewControllers.count == 1)) {
        [self dismiss];
    } else {
        [self pop];
    }
    
}

-(void)backClick{
    
    if (self.presentingViewController && (self.navigationController.viewControllers.count == 1 || self.navigationController == nil)) {
        [self dismiss];
    } else {
        [self pop];
    }
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

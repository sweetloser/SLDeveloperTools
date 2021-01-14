//
//  BXDynAddHuaTiVC.m
//  BXlive
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynAddHuaTiVC.h"
#import "AddHuaTiCell.h"
#import "AddHuaTiFooterView.h"
#import "BXDynTopicDelItemCell.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynTopicModel.h"
#import "BXPersonFlowLayout.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <Masonry/Masonry.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
#import <YYCategories/YYCategories.h>

@interface BXDynAddHuaTiVC ()<UISearchBarDelegate, UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic , strong) UIView * navView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *issueBtn;


@property(nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *HotDataArray;
@property (nonatomic,strong)NSMutableArray *NewDataArray;

@property(nonatomic, strong)UICollectionReusableView *HotView;
@property(nonatomic, strong)UICollectionReusableView *NewView;
@property(nonatomic, strong)AddHuaTiFooterView *footerview;

@end

@implementation BXDynAddHuaTiVC
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
    [self.footerview.searchBar resignFirstResponder];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavView];
    [self createCollectionView];
//    [self searchView];
//    _ItemArray = [[NSMutableArray alloc]init];
    _HotDataArray = [[NSMutableArray alloc]init];
    _NewDataArray = [[NSMutableArray alloc]init];
    _ItemArray = [NSMutableArray array];
    
}
-(void)setNavView{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+__kTopAddHeight)];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    
   UILabel *_viewTitlelabel = [[UILabel alloc]init];
    _viewTitlelabel.text = @"添加话题";
    _viewTitlelabel.textColor = sl_textColors;
    _viewTitlelabel.textAlignment = 1;
    _viewTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [_navView addSubview:_viewTitlelabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:CImage(@"back_black") forState:BtnNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_backBtn];

    _issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_issueBtn setImage:CImage(@"nav_icon_news_black") forState:BtnNormal];
    [_issueBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_issueBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
    _issueBtn.backgroundColor = DynUnSendButtonBackColor;
    _issueBtn.titleLabel.font = SLPFFont(14);
    _issueBtn.layer.cornerRadius = 13;
    _issueBtn.layer.masksToBounds = YES;
    _issueBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.navView addSubview:_issueBtn];
    [_issueBtn addTarget:self action:@selector(AddClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(20 + __kTopAddHeight + 12);
    }];
    [self upDataView];

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
    [self.collectionView registerClass:[BXDynTopicDelItemCell class] forCellWithReuseIdentifier:@"BXDynTopciCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[AddHuaTiFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-__kBottomAddHeight);
    }];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.footerview.searchBar resignFirstResponder];
}
-(void)upDataView{
    if (_ItemArray.count) {
        [_issueBtn setTitleColor:DynSendButtonTitle forState:UIControlStateNormal];
        _issueBtn.backgroundColor = DynSendButtonBackColor;
        _issueBtn.userInteractionEnabled = YES;
    }else{
        [_issueBtn setTitleColor:DynUnSendButtonTitle forState:UIControlStateNormal];
        _issueBtn.backgroundColor = DynUnSendButtonBackColor;
        _issueBtn.userInteractionEnabled = NO;
    }
}
#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _ItemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BXDynTopicDelItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXDynTopciCell" forIndexPath:indexPath];

    cell.topicStr = [_ItemArray[indexPath.row] topic_name];
    WS(weakSelf);
    cell.DidDelIndex = ^{
        for (BXDynTopicModel *model in weakSelf.SelectedArray) {
            if ([[NSString stringWithFormat:@"%@", model.topic_id] isEqualToString:[NSString stringWithFormat:@"%@", [weakSelf.ItemArray[indexPath.row] topic_id]]]) {
                [weakSelf.SelectedArray removeObject:model];
                break;
            }
        }
        [weakSelf.ItemArray removeObjectAtIndex:indexPath.row];
        [weakSelf.collectionView reloadData];
        [weakSelf upDataView];
//        [weakSelf.footerview.AddDataArray removeAllObjects];
//        for (int i = 0; i<weakSelf.ItemArray.count; i++) {
//            [weakSelf.footerview.AddDataArray addObject:[weakSelf.ItemArray[i] topic_name]];
//        }
    };
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (BXDynTopicModel *model in self.SelectedArray) {
        if ([[NSString stringWithFormat:@"%@", model.topic_id] isEqualToString:[NSString stringWithFormat:@"%@", [self.ItemArray[indexPath.row] topic_id]]]) {
            [self.SelectedArray removeObject:model];
            break;
        }
    }
    [self.ItemArray removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
    [self upDataView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        NSString *str = [_ItemArray[indexPath.row]topic_name];
        CGFloat width = [str widthForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12]];
        CGFloat height = 0;
        if (width > 300) {
            width = 300;
            height = [str heightForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12] width:300];
            return CGSizeMake(width + 50, height + 15);
        }
        return CGSizeMake(width + 50, 30);
    }
    if (indexPath.section == 1) {
        
        NSString *str = [_NewDataArray[indexPath.row]topic_name];
        CGFloat width = [str widthForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12]];
        CGFloat height = 0;
        if (width > 300) {
            width = 300;
            height = [str heightForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12] width:300];
            return CGSizeMake(width + 30, height + 15);
        }
        return CGSizeMake(width + 30, 30);
    }
    return CGSizeMake(0, 0);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}


//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(5, 12, 0, 0);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        WS(weakSelf);
            _footerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        _footerview.itemNum = self.SelectedArray.count;
        _footerview.MAXNum = _MAXNumber;
        _footerview.DidItemIndex = ^(NSString * _Nonnull topic_name, NSString * _Nonnull topic_id) {
            if (weakSelf.SelectedArray.count >= weakSelf.MAXNumber) {
                [BGProgressHUD showInfoWithMessage:[NSString stringWithFormat:@"最多只能添加%ld个话题哦", (long)weakSelf.MAXNumber]];
                return;
            }
            
            for (int i = 0 ; i< weakSelf.SelectedArray.count; i++) {
                NSString *topid = [NSString stringWithFormat:@"%@", topic_id];
                NSString *itemtopid = [NSString stringWithFormat:@"%@", [weakSelf.SelectedArray[i]topic_id]];
                if ([topid isEqualToString:itemtopid]) {
                    [BGProgressHUD showInfoWithMessage:@"您已经添加过该话题啦"];
                    return;
                }
            }
            BXDynTopicModel *model = [[BXDynTopicModel alloc]init];
            model.topic_name = topic_name;
            model.topic_id = [NSString stringWithFormat:@"%@", topic_id];
            [weakSelf.ItemArray addObject:model];
            [weakSelf.SelectedArray addObject:model];
            [weakSelf.collectionView reloadData];
            [weakSelf upDataView];
//            [weakSelf.footerview.AddDataArray removeAllObjects];
//            weakSelf.itemNumber++;
//            for (int i = 0; i<weakSelf.ItemArray.count; i++) {
//                [weakSelf.footerview.AddDataArray addObject:[weakSelf.ItemArray[i] topic_name]];
//                weakSelf.itemNumber--;
//            }
        };
            return _footerview;
        
    }
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _HotDataArray.count) {
        
        return CGSizeMake(SCREEN_WIDTH, 30);
    }
    if (section == 1 && _NewDataArray.count) {
        
        return CGSizeMake(SCREEN_WIDTH, 30);
    }
        return CGSizeMake(0, 0);

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, __kHeight - 74-__kTopAddHeight - __kBottomAddHeight);
}
-(void)AddClick{
    WS(weakSelf);
    if (self.SelTopicBlock) {
        self.SelTopicBlock(weakSelf.ItemArray);
        [self pop];
    }
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

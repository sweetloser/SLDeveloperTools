//
//  BXSLSearchVC.m
//  BXlive
//
//  Created by bxlive on 2019/3/7.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXSLSearchVC.h"
#import "BXSLSearchCategoryCell.h"
#import "BXSLSearchHeaderView.h"
#import "BXSLSearchingVC.h"
#import "BXHMovieModel.h"
//#import "BXVideoPlayVC.h"
#import "BXSLSearchResultVC.h"
#import "NewHttpManager.h"
#import <MMKV/MMKV.h>
#import <Masonry/Masonry.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import "SLAppInfoConst.h"

@interface BXSLSearchVC () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YHSearchingVCDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSMutableArray *videos;

@property(nonatomic, strong) UIButton *cancelBtn;

@end

@implementation BXSLSearchVC

- (void)getHotData {
    [NewHttpManager searchIndexSuccess:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            MMKV *mmkv = [MMKV defaultMMKV];
            [mmkv setObject:jsonDic forKey:@"Search-Data"];
            [self didGetData:jsonDic];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getLocationData {
    MMKV *mmkv = [MMKV defaultMMKV];
    NSDictionary *jsonDic = [mmkv getObjectOfClass:[NSDictionary class] forKey:@"Search-Data"];
    if (jsonDic) {
        [self didGetData:jsonDic];
    }
}

- (void)didGetData:(NSDictionary *)jsonDic {
    NSDictionary *dataDic = jsonDic[@"data"];
    
    [self.videos removeAllObjects];
    NSArray *recommendsArray = dataDic[@"recommends"];
    if (recommendsArray && [recommendsArray isArray]) {
        for (NSDictionary *dic in recommendsArray) {
            BXHMovieModel *video = [[BXHMovieModel alloc]init];
            [video updateWithJsonDic:dic];
            [self.videos addObject:video];
        }
    }
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
    _videos = [NSMutableArray array];
    
    [self addSearchBar];
    [self initViews];
    
    [self getLocationData];
    [self getHotData];
}

- (void)addSearchBar {
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 64 + __kTopAddHeight)];
    [self.view addSubview:navBar];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:BtnNormal];
    backBtn.frame = CGRectMake(__ScaleWidth(12), 20 + __kTopAddHeight + 6, 32, 32);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(pop) forControlEvents:BtnTouchUpInside];
    [navBar addSubview:backBtn];
    
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 39, 34)];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuo_icon_sousuo"]];
    iconIv.contentMode = UIViewContentModeCenter;
    iconIv.frame = CGRectMake(16, 9, 16, 16);
    [leftview addSubview:iconIv];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(__ScaleWidth(41), 20 + __kTopAddHeight + 5, __ScaleWidth(294), 34)];
    textField.backgroundColor = sl_subBGColors;
    textField.layer.cornerRadius = 17;
    textField.layer.masksToBounds = YES;
    textField.font = SLPFFont(14);
    textField.leftView = leftview;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜一搜" attributes:@{NSForegroundColorAttributeName:CHHCOLOR_D(0x7A8181)}];
    [navBar addSubview:textField];
    _textField = textField;
    
//    _cancelBtn = [UIButton buttonWithFrame:CGRectZero Title:@"取消" Font:SLPFFont(16) Color:sl_normalColors Image:nil Target:self action:@selector(pop) forControlEvents:BtnTouchUpInside];
//    [navBar addSubview:_cancelBtn];
//    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(textField.mas_right);
//        make.right.equalTo(navBar);
//        make.height.equalTo(textField);
//        make.centerY.equalTo(textField);
//    }];
}

- (void)initViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 3;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64 + __kTopAddHeight);
    }];
    [_collectionView registerClass:[BXSLSearchCategoryCell class] forCellWithReuseIdentifier:@"CategoryCell"];
    [_collectionView registerClass:[BXSLSearchHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
}



#pragma - mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BXSLSearchingVC *vc = [[BXSLSearchingVC alloc]init];
    vc.delegate = self;
    vc.view.frame = self.view.frame;
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    return NO;
}

#pragma - mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _videos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BXSLSearchCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    cell.video = _videos[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BXSLSearchHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        headerView.image = CImage(@"icon_tuijianguanzhu");
        headerView.text = @"发现精彩";
        return headerView;
    }
    return nil;
}

#pragma - mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BXHMovieModel *video = _videos[indexPath.row];
    
//    BXVideoPlayVC *vc = [[BXVideoPlayVC alloc]init];
//    vc.videos = @[video];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXGo2BXVideoPlayVC object:nil userInfo:@{@"vc":self,@"movie_models":@[video],@"index":@(0)}];
}

#pragma - mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        CGFloat itemW = (__kWidth - 36) / 2;
        return CGSizeMake(itemW, itemW * 24 / 17);
    } else {
        CGFloat itemW = __ScaleWidth(114);
        CGFloat itemH = __ScaleWidth(181);
        return CGSizeMake(itemW, itemH);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section) {
        return UIEdgeInsetsMake(0, __ScaleWidth(12) , __ScaleWidth(10), __ScaleWidth(12));
    } else {
        return UIEdgeInsetsMake(0, __ScaleWidth(12) , __ScaleWidth(5), __ScaleWidth(12));
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (!section && _videos.count) {
        return CGSizeMake(__kWidth, 44);
    } else {
        return CGSizeZero;
    }
}

#pragma - mark YHSearchingVCDelegate
- (void)cancelSearch {
    self.textField.x = 16;
    self.textField.width = SearchTextFieldNormalWidth;
    [UIView animateWithDuration:.5 animations:^{
        self.textField.x = 50;
    }];
}

@end

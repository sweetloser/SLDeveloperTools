//
//  SLToolsSearchHistoryView.m
//  BXlive
//
//  Created by sweetloser on 2020/11/19.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLToolsSearchHistoryView.h"
#import "SLToolsSearchKeywordCell.h"
#import "SLSearchingFlowLayout.h"
#import "SLMacro.h"
#import <Masonry/Masonry.h>
#import <MMKV/MMKV.h>
#import "SLCategory.h"

@interface SLToolsSearchHistoryView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *historyDataSource;

@end
@implementation SLToolsSearchHistoryView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = sl_BGColors;
        _historyDataSource = [NSMutableArray new];
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionViewFlowLayout *layout = [[SLSearchingFlowLayout alloc] init];
        layout.minimumInteritemSpacing = __ScaleWidth(20);
        layout.minimumLineSpacing = __ScaleWidth(10);
        layout.sectionInset = UIEdgeInsetsMake(0, __ScaleWidth(12), __ScaleWidth(20), __ScaleWidth(12));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SLToolsSearchKeywordCell class] forCellWithReuseIdentifier:@"SLToolsSearchKeywordCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableHeader"];
        _collectionView.backgroundColor = sl_BGColors;
    }
    return self;
}

-(void)cleanHistoryBtnAction{
    NSLog(@"清除所有的历史搜索");
    
    [self.historyDataSource removeAllObjects];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.historyDataSource options:NSJSONWritingPrettyPrinted error:nil];
    
    MMKV *mk = [MMKV mmkvWithID:self.mkid];
    [mk setData:data forKey:@"search_history"];
    
    [self reloadHistoryData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cleanAllKeyword)]) {
        [self.delegate cleanAllKeyword];
    }
    
}

-(void)reloadHistoryData{
    
    if (self.mkid == nil) {
        return;
    }
    
    MMKV *mk = [MMKV mmkvWithID:self.mkid];
    NSData *data = [mk getDataForKey:@"search_history"];
    NSMutableArray *historyArr;
    if (data) {
        historyArr = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] mutableCopy];
        self.historyDataSource = historyArr;
        [self.collectionView reloadData];
    }
}

#pragma mark - collectionView 代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    点击了
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidClickWithKeyword:)]) {
        [self.delegate cellDidClickWithKeyword:self.historyDataSource[indexPath.row]];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SLToolsSearchKeywordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLToolsSearchKeywordCell" forIndexPath:indexPath];
    cell.keywordLabel.text = self.historyDataSource[indexPath.row];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _historyDataSource.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat k_w = [UILabel getWidthWithTitle:self.historyDataSource[indexPath.row] font:SLPFFont(__ScaleWidth(12))];
    return CGSizeMake(k_w + __ScaleWidth(30), __ScaleWidth(29));
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return __ScaleWidth(10);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, __ScaleWidth(12), 0, __ScaleWidth(12));
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return __ScaleWidth(15);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusableHeader" forIndexPath:indexPath];
        UILabel *label = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"搜索历史" Font:SLBFont(14) TextColor:sl_textSubColors];
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(12));
            make.bottom.mas_equalTo(-__ScaleWidth(10));
            make.height.mas_equalTo(__ScaleWidth(20));
            make.width.mas_equalTo(__ScaleWidth(120));
        }];
        
        UIButton *cleanHistoryBtn = [UIButton buttonWithFrame:CGRectZero Title:@"" Font:SLPFFont(11) Color:SLClearColor Image:CImage(@"clean_history_black") Target:self action:@selector(cleanHistoryBtnAction) forControlEvents:BtnTouchUpInside];
        [headerView addSubview:cleanHistoryBtn];
        [cleanHistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(__ScaleWidth(-12));
            make.bottom.equalTo(label);
            make.width.height.mas_equalTo(__ScaleWidth(30));
        }];
    }
    
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;{
    return CGSizeMake(__kWidth, __ScaleWidth(45));
}
@end

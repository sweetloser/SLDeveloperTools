//
//  SLToolsSearchHotView.m
//  BXlive
//
//  Created by sweetloser on 2020/11/19.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLToolsSearchHotView.h"
#import "SLToolsSearchKeywordCell.h"
#import "SLSearchingFlowLayout.h"
#import "SLMacro.h"
#import <Masonry/Masonry.h>
#import "SLCategory.h"
#import "NewHttpManager.h"

@interface SLToolsSearchHotView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *discoveryDataSource;

@property(nonatomic,assign)SLToolsSearchHotViewType type;
@end

@implementation SLToolsSearchHotView

-(instancetype)initWithFrame:(CGRect)frame type:(SLToolsSearchHotViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = sl_BGColors;
        _type = type;
        _discoveryDataSource = [NSMutableArray new];
        
        UICollectionViewFlowLayout *layout = [[SLSearchingFlowLayout alloc] init];
        layout.minimumInteritemSpacing = __ScaleWidth(20);
        layout.minimumLineSpacing = __ScaleWidth(10);
        layout.sectionInset = UIEdgeInsetsMake(0, __ScaleWidth(12), __ScaleWidth(20), __ScaleWidth(12));
        
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
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
        
//        获取数据
        if (_type == SLToolsSearchHotViewTypeSmallShop) {
            [self getSmallShopHotKeyword];
        }else if (_type == SLToolsSearchHotViewTypeTaokeThirdShop) {
            [self getThirdShopHotKeyword];
        }
    }
    return self;
}

#pragma mark - 获取热搜关键词
-(void)getThirdShopHotKeyword{
    WS(weakSelf);
    [[NewHttpManager sharedNetManager] NOSPOST:@"api/taoke.common/getHotKeywords" parameters:@{} success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if ([code integerValue] == 0) {
            NSArray *data = responseObject[@"data"];
            [weakSelf.discoveryDataSource removeAllObjects];
            for (NSDictionary *dict in data) {
                [weakSelf.discoveryDataSource addObject:dict[@"keyword"]];
            }
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败了");
    }];
}

#pragma mark - 获取热搜关键词
-(void)getSmallShopHotKeyword{
    WS(weakSelf);
    [[NewHttpManager sharedNetManager] AmwayPost:@"bxapi/Common/getHotKeywords" parameters:@{} success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if ([code integerValue] == 0) {
            NSDictionary *data = responseObject[@"data"];
            if (data && [data isDictionary]) {
                NSArray *search_keywords = data[@"search_keywords"];
                [weakSelf.discoveryDataSource addObjectsFromArray:search_keywords];
                [weakSelf.collectionView reloadData];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"失败了");
    }];
}

#pragma mark - collectionView 代理方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.discoveryDataSource[indexPath.row]);
    NSString *keyword = self.discoveryDataSource[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidClickWithKeyword:)]) {
        [self.delegate cellDidClickWithKeyword:keyword];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SLToolsSearchKeywordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLToolsSearchKeywordCell" forIndexPath:indexPath];
    cell.keywordLabel.text = self.discoveryDataSource[indexPath.row];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _discoveryDataSource.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat k_w = [UILabel getWidthWithTitle:self.discoveryDataSource[indexPath.row] font:SLPFFont(__ScaleWidth(12))];
//    return CGSizeMake(k_w+__ScaleWidth(20), __ScaleWidth(32));
    return CGSizeMake(k_w + __ScaleWidth(30), __ScaleWidth(29));
}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, __ScaleWidth(12), 0, __ScaleWidth(12));
//}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return __ScaleWidth(10);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return __ScaleWidth(15);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusableHeader" forIndexPath:indexPath];
        UILabel *label = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"搜索发现" Font:SLBFont(14) TextColor:sl_textSubColors];
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(12));
            make.bottom.mas_equalTo(__ScaleWidth(-10));
            make.height.mas_equalTo(__ScaleWidth(20));
            make.right.mas_equalTo(-__ScaleWidth(12));
        }];
    }
    
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;{
    return CGSizeMake(__kWidth, __ScaleWidth(45));
}


@end

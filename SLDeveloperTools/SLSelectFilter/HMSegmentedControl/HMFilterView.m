//
//  HMFilterView.m
//  BXlive
//
//  Created by bxlive on 2019/4/12.
//  Copyright © 2019 cat. All rights reserved.
//

#import "HMFilterView.h"
#import "../../SLCategory/SLCategory.h"
#import "../../SLMacro/SLMacro.h"
#import <MMKV/MMKV.h>
#import "../SLSelectFilterConst.h"
#import "../../SLMaskTools/SLMaskTools.h"

@interface HMFilterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation HMFilterView
- (instancetype)initWithFrame:(CGRect)frame filtersName:(NSArray *)filtersName
{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 16;
    layout.minimumInteritemSpacing = 16;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _filtersName = filtersName;
        self.dataSource = self;
        self.delegate   = self;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[HMFilterCell class] forCellWithReuseIdentifier:@"HMFilterCell"];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
       
        
    }
    return self;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self reloadData];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filtersName.count ;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(__ScaleWidth(57), __ScaleWidth(57+8+16)) ;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(__ScaleWidth(12), __ScaleWidth(0), __ScaleWidth(12), __ScaleWidth(15));
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HMFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HMFilterCell" forIndexPath:indexPath];

    cell.titleLabel.text = self.filtersName[indexPath.row][@"filter"];
    cell.titleLabel.textColor = sl_textSubColors;
    cell.imageView.image = CImage(self.filtersName[indexPath.row][@"image"]);
    
    cell.imageView.layer.borderWidth = 0.0 ;
    cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    
    if (_selectedIndex == indexPath.row) {
        cell.imageView.layer.borderWidth = 2.0 ;
        cell.imageView.layer.borderColor = sl_normalColors.CGColor;
        cell.titleLabel.textColor = sl_normalColors;
    }
    
    return cell ;
}

#pragma mark ---- UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MMKV *mmkv = [MMKV defaultMMKV];
    if ([mmkv getBoolForKey:kSaveSkipKey]) {
        [BGProgressHUD showInfoWithMessage:@"请先打开美颜开关"];
        return;
    }

    
    NSInteger indexPathRow = indexPath.row;
    if (_selectedIndex == indexPathRow) {
        return ;
    }
    _selectedIndex = indexPath.row;
    [self reloadData];
    NSString *imageName = self.filtersName[indexPath.row][@"image"];
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(filterViewDidSelectedFilter:selectedIndex:)]) {
        [self.mDelegate filterViewDidSelectedFilter:imageName selectedIndex:_selectedIndex];
    }
    
}

-(void)resetParams{
    _selectedIndex = 0;
    [self reloadData];
    
}

#pragma mark ---- UICollectionViewDelegateFlowLayout


@end


@implementation HMFilterCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, __ScaleWidth(57), __ScaleWidth(57))];
        self.imageView.layer.masksToBounds = YES ;
        self.imageView.layer.cornerRadius = 12.0 ;
        self.imageView.layer.borderWidth = 0.0 ;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor ;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, __ScaleWidth(57), __ScaleWidth(57), frame.size.height - __ScaleWidth(57))];
        self.titleLabel.textAlignment = NSTextAlignmentCenter ;
        self.titleLabel.font = SLPFFont(__ScaleWidth(11));
        [self addSubview:self.titleLabel];
        
        
        
        
    }
    return self ;
}
- (void)setSelected:(BOOL)selected{
    
}

@end

//
//  BXWaterfallFlowLayout.m
//  WaterfallFlow
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 曹化徽. All rights reserved.
//

#import "BXWaterfallFlowLayout.h"

@implementation BXWaterfallFlowLayout

#pragma mark- 懒加载
- (NSMutableDictionary *)maxYDic {
    if (!_maxYDic) {
        _maxYDic = [[NSMutableDictionary alloc] init];
    }
    return _maxYDic;
}

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

#pragma mark- 构造方法
- (instancetype)init {
    if ([super init]) {
        _columnCount = 2;
    }
    return self;
}

#pragma mark- 布局相关方法
- (void)prepareLayout {
    for (NSInteger i = 0; i < _columnCount; i++) {
        self.maxYDic[@(i)] = @(self.sectionInset.top);
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    [self.attributesArray removeAllObjects];
    //为每一个item创建一个attributes并保存在数组
    for (NSInteger i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize {
    __block NSNumber *maxIndex = @0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL * _Nonnull stop) {
        if ([self.maxYDic[maxIndex] floatValue] < [obj floatValue]) {
            maxIndex = key;
        }
    }];
    return CGSizeMake(0, [self.maxYDic[maxIndex] floatValue] + _sectionInset.bottom);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat itemWidth = (collectionViewWidth - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    
    //找出最短的那一列
    __block NSNumber *minIndex = @0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDic[minIndex] floatValue] > obj.floatValue) {
            minIndex = key;
        }
    }];
    //根据最短列的列数计算item的x值
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * minIndex.integerValue;
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.maxYDic[minIndex] floatValue] + self.rowSpacing;
    
    CGFloat itemHeight = 0;
    if (self.itemHeightBlock) {
        itemHeight = self.itemHeightBlock(itemWidth, indexPath);
    }
    
    //根据indexPath获取item的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    //更新字典中的最短列的最大y值
    self.maxYDic[minIndex] = @(CGRectGetMaxY(attributes.frame));
    return attributes;
}

//返回rect范围内item的attributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

@end

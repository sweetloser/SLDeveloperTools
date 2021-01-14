//
//  BXHHEmojiFlowLayout.m
//  BXlive
//
//  Created by bxlive on 2018/9/26.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXHHEmojiFlowLayout.h"
#import "../SLMacro/SLMacro.h"

@interface BXHHEmojiFlowLayout()

@property(nonatomic,strong) NSMutableArray *cellAttributesArray;

@end

@implementation BXHHEmojiFlowLayout

- (NSMutableArray *)cellAttributesArray{
    
    if (!_cellAttributesArray) {
        
        _cellAttributesArray = [NSMutableArray array];
    }
    return _cellAttributesArray;
}


- (void)prepareLayout {
    
    [super prepareLayout];
    
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.cellAttributesArray removeAllObjects];
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attibute = [self layoutAttributesForItemAtIndexPath:indexPath];
        NSInteger page = i / (_rowNum * _colNum);//第几页
        NSInteger row = i % _rowNum + page * _rowNum;//第几列
        NSInteger col = i / _rowNum - page * _colNum;//第几行
        
        attibute.frame = CGRectMake(row * self.itemSize.width, col * self.itemSize.height, self.itemSize.width, self.itemSize.height);
        [self.cellAttributesArray addObject:attibute];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.cellAttributesArray;
}

- (CGSize)collectionViewContentSize {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger page = ceilf(cellCount * 1.0 / (_rowNum * _colNum));
    return CGSizeMake(__kWidth * page, 0);
}


@end

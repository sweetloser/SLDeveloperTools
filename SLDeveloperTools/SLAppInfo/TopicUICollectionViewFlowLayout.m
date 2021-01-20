//
//  TopicUICollectionViewFlowLayout.m
//  BXlive
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "TopicUICollectionViewFlowLayout.h"

@implementation TopicUICollectionViewFlowLayout
//-(CGSize)collectionViewContentSize
//
//{
//    
//    CGFloat height = ceil([[self collectionView] numberOfItemsInSection:0]/5)*SCREEN_WIDTH/2;
//    
//    return CGSizeMake(SCREEN_WIDTH, height);
//    
//}//返回contentsize的总大小

//自定义布局必须YES
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds

{
    
    return YES;
    
}



//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path{}//返回每个cell的布局属性



-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect

{
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray* attributes = [NSMutableArray array];
    
    for (NSInteger i=0 ; i < [array count]; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        
    }
    
    return attributes;
    
}

@end

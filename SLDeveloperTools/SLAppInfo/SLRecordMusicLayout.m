//
//  SLRecordMusicLayout.m
//  BXlive
//
//  Created by sweetloser on 2020/7/31.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLRecordMusicLayout.h"

@implementation SLRecordMusicLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _offsetY = 0;
    }
    return self;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    
    //UICollectionViewLayoutAttributes：我称它为collectionView中的item（包括cell和header、footer这些）的《结构信息》
    //截取到父类所返回的数组（里面放的是当前屏幕所能展示的item的结构信息），并转化成不可变数组
    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    //遍历superArray，改变header结构信息中的参数，使它可以在当前section还没完全离开屏幕的时候一直显示
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        attributes.zIndex = 5;
        //如果当前item是header
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            //获取当前header的frame
            CGRect rect = attributes.frame;
            
            //当前的滑动距离 + 因为导航栏产生的偏移量，默认为64（如果app需求不同，需自己设置）
            CGFloat offset = _offsetY;
            //给rect的y赋新值，因为在最后消失的临界点要跟谁消失，所以取小
            rect.origin.y = rect.origin.y + offset;
            //给header的结构信息的frame重新赋值
            
            attributes.frame = rect;
            
            //如果按照正常情况下,header离开屏幕被系统回收，而header的层次关系又与cell相等，如果不去理会，会出现cell在header上面的情况
            //通过打印可以知道cell的层次关系zIndex数值为0，我们可以将header的zIndex设置成1，如果不放心，也可以将它设置成非常大，这里随便填了个7
            attributes.zIndex = 0;
        }
    }
    
    //转换回不可变数组，并返回
    return [superArray copy];
    
}

//return YES;表示一旦滑动就实时调用上面这个layoutAttributesForElementsInRect:方法
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}


@end

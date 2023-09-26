//
//  SLSearchingFlowLayout.m
//  BXlive
//
//  Created by sweetloser on 2020/9/5.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLSearchingFlowLayout.h"
#import "../SLMacro/SLMacro.h"
@implementation SLSearchingFlowLayout

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *attrsArry = [super layoutAttributesForElementsInRect:rect];
    
    if (!attrsArry) {
        return nil;
    }
    
    for (int i = 0;i< attrsArry.count;i++) {
        
        UICollectionViewLayoutAttributes *curAttr = attrsArry[i]; //当前attr
        
        if ([curAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            if (i != attrsArry.count-1) {
                UICollectionViewLayoutAttributes * nextAttr = attrsArry[i+1];  //下一个attr
                CGRect frame = nextAttr.frame;
                frame = CGRectMake(__ScaleWidth(20), frame.origin.y, frame.size.width, frame.size.height);
                nextAttr.frame = frame;
            }
            continue;
        }
        
        if (i != attrsArry.count-1) {
            
            
            UICollectionViewLayoutAttributes * nextAttr = attrsArry[i+1];  //下一个attr
            
            
            
//            如果是第一个
            if (i == 0) {
                CGRect frame = curAttr.frame;
                curAttr.frame = CGRectMake(__ScaleWidth(20), frame.origin.y, frame.size.width, frame.size.height);
            }
            
            //如果下一个在同一行则调整，不在同一行则跳过
            if (curAttr.frame.origin.y == nextAttr.frame.origin.y) {
                CGRect frame = nextAttr.frame;
                CGFloat x = curAttr.frame.origin.x +  curAttr.frame.size.width + __ScaleWidth(20);
                frame = CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
                nextAttr.frame = frame;
            }else{
                if ([nextAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                    continue;
                }
                CGRect frame = nextAttr.frame;
                frame = CGRectMake(__ScaleWidth(20), frame.origin.y, frame.size.width, frame.size.height);
                nextAttr.frame = frame;
            }
        }
    }
    
    return attrsArry;
    
}


@end

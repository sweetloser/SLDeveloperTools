//
//  BXWaterfallFlowLayout.h
//  WaterfallFlow
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 曹化徽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXWaterfallFlowLayout : UICollectionViewLayout

//总列数
@property (assign, nonatomic) NSInteger columnCount;
//列间距
@property (assign, nonatomic) CGFloat columnSpacing;
//行间距
@property (assign, nonatomic) CGFloat rowSpacing;
//section的边距
@property (assign, nonatomic) UIEdgeInsets sectionInset;
//保存每一列的最大Y值
@property (strong, nonatomic) NSMutableDictionary *maxYDic;
//保存每一个item的attributes
@property (strong, nonatomic) NSMutableArray *attributesArray;
//计算item的高度
@property (copy, nonatomic) CGFloat (^itemHeightBlock)(CGFloat itemWidth,NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END

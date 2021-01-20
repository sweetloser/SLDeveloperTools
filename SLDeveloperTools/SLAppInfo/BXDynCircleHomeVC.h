//
//  BXDynCircleHomeVC.h
//  BXlive
//
//  Created by mac on 2020/8/3.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXSLPageListVC.h"
#import "JXCategoryView.h"
#import "BXDynCircleModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface BXDynCircleHomeVC : BXSLPageListVC<JXCategoryListContentViewDelegate>
//@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property(nonatomic, strong)BXDynCircleModel *model;
- (void)TableDragWithDown;
@end

NS_ASSUME_NONNULL_END

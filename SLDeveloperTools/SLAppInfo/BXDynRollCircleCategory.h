//
//  BXDynRollCircleCategory.h
//  BXlive
//
//  Created by mac on 2020/8/3.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXDynCircleModel.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynRollCircleCategory : BaseVC<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic,copy)void(^DidClickCircle)(BXDynCircleModel *model);
@property(nonatomic, strong)BXDynCircleModel *model;
@property(nonatomic, assign)BOOL isOwn;
@property (nonatomic, strong) JXPagerView *pagerView;
- (JXPagerView *)preferredPagingView;
@end

NS_ASSUME_NONNULL_END

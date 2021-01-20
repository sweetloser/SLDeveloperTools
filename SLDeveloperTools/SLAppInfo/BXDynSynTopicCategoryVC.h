//
//  BXDynSynTopicCategoryVC.h
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "JXCategoryView.h"
#import "BXDynTopicModel.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN
@interface BXDynSynTopicCategoryVC : BaseVC<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic,copy)void(^DidClickTopic)(BXDynTopicModel *model);
@property (nonatomic, strong) JXPagerView *pagerView;
@property(nonatomic, strong)BXDynTopicModel *model;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
- (JXPagerView *)preferredPagingView;



@end

NS_ASSUME_NONNULL_END

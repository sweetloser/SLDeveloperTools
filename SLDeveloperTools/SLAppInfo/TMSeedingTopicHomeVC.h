//
//  TMSeedingTopicHomeVC.h
//  BXlive
//
//  Created by mac on 2020/11/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "JXCategoryView.h"
#import "BXDynTopicModel.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TMSeedingTopicHomeVC : BaseVC<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic,copy)void(^DidClickTopic)(BXDynTopicModel *model);
@property (nonatomic, strong) JXPagerView *pagerView;

@property(nonatomic, strong)NSString *topic_id;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
- (JXPagerView *)preferredPagingView;

@end

NS_ASSUME_NONNULL_END

//
//  BXDynCircleCategoryVC.h
//  BXlive
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynCircleCategoryVC : BaseVC<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) JXPagerView *pagerView;
@property(nonatomic, assign)BOOL isOwn;
- (JXPagerView *)preferredPagingView;

@end

NS_ASSUME_NONNULL_END

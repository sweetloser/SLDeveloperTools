//
//  BXAttentionVC.h
//  BXlive
//
//  Created by bxlive on 2019/2/20.
//  Copyright © 2019 cat. All rights reserved.
//



#import "BaseVC.h"
#import "JXCategoryView.h"
NS_ASSUME_NONNULL_BEGIN

/**
 首页关注模块
 */

@interface BXAttentionVC : BaseVC <JXCategoryListContentViewDelegate>

@property (nonatomic, weak) UITabBarController *tabBarController;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;


@end

NS_ASSUME_NONNULL_END

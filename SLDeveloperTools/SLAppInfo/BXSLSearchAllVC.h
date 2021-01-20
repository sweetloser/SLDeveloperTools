//
//  BXSLSearchAllVC.h
//  BXlive
//
//  Created by bxlive on 2019/3/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"
#import "JXCategoryView.h"
#import "BXSLSearchResultVC.h"

@interface BXSLSearchAllVC :  BaseVC <JXCategoryListContentViewDelegate>

@property (nonatomic, weak) BXSLSearchResultVC *searchResultVC;
@property (nonatomic, copy) void (^moreDetail)(NSInteger index);

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSIndexPath * currentIndexPath;


@end



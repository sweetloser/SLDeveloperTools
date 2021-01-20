//
//  BXDynGlobleVC.h
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "JXCategoryView.h"
#import "BXSLSearchResultVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynGlobleVC : BaseVC<JXCategoryListContentViewDelegate>
@property(nonatomic, strong)NSString *dyntype; //2:圈子 3:声音 4:我的 5:搜索 6:综合搜索
@property (nonatomic, weak) BXSLSearchResultVC *searchResultVC;
- (void)TableDragWithDown;
@end

NS_ASSUME_NONNULL_END

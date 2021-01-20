//
//  TMSeedingTopicListVC.h
//  BXlive
//
//  Created by mac on 2020/11/21.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXSLPageListVC.h"
#import "JXCategoryView.h"
#import "BXDynTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMSeedingTopicListVC : BXSLPageListVC<JXCategoryListContentViewDelegate>

@property(nonatomic, strong)NSString *topic_id;
@property(nonatomic, strong)NSString *dynType; //1:我的
@property(nonatomic, strong)NSString *user_id;
- (void)TableDragWithDown;

@end

NS_ASSUME_NONNULL_END

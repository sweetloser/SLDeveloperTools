//
//  BXDynTopicVideoVC.h
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXSLPageListVC.h"
#import "JXCategoryView.h"
#import "BXDynTopicModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface BXDynTopicVideoVC : BXSLPageListVC<JXCategoryListContentViewDelegate>
@property (copy, nonatomic) NSString *user_id;
@property (nonatomic, assign) NSInteger type;
@property(nonatomic, strong)BXDynTopicModel *model;
@end

NS_ASSUME_NONNULL_END

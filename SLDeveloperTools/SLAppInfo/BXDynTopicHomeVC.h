//
//  BXDynTopicHomeVC.h
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXSLPageListVC.h"
#import "JXCategoryView.h"
#import "BXDynTopicModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface BXDynTopicHomeVC : BXSLPageListVC<JXCategoryListContentViewDelegate>
//@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property(nonatomic, strong)BXDynTopicModel *model;
@property(nonatomic, strong)NSString *dynType; //1:我的
@property(nonatomic, strong)NSString *user_id; 
- (void)TableDragWithDown;
@end

NS_ASSUME_NONNULL_END

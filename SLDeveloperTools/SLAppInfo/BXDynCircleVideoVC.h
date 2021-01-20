//
//  BXDynCircleVideoVC.h
//  BXlive
//
//  Created by mac on 2020/8/15.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXSLPageListVC.h"
#import "JXCategoryView.h"
#import "BXDynCircleModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface BXDynCircleVideoVC : BXSLPageListVC<JXCategoryListContentViewDelegate>
@property (copy, nonatomic) NSString *user_id;
@property (nonatomic, assign) NSInteger type;
@property(nonatomic, strong)BXDynCircleModel *model;

@end

NS_ASSUME_NONNULL_END

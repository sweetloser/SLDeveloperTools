//
//  BXCommentHeaderView.h
//  BXlive
//
//  Created by bxlive on 2019/5/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GHDynCommentHeaderView : UITableViewHeaderFooterView
@property (nonatomic , strong) BXDynCommentModel * model;
@property (nonatomic , assign) BOOL isChild;
@property(nonatomic,copy)void (^toPersonHome)(NSString *userID);
@property(nonatomic,copy)void (^sectionClick)(BXDynCommentModel *model);
@property(nonatomic,copy)void (^clickZan)(BXDynCommentModel *model);
@property(nonatomic,copy)void (^SendMsgClick)(BXDynCommentModel *model);
@property(nonatomic,copy)void (^clicktipoff)(BXDynCommentModel *model);

@end

NS_ASSUME_NONNULL_END

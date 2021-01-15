//
//  BXCommentHeaderView.h
//  BXlive
//
//  Created by bxlive on 2019/5/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXCommentHeaderView : UITableViewHeaderFooterView
@property (nonatomic , strong) BXCommentModel * model;
@property(nonatomic,copy)void (^toPersonHome)(NSString *userID);
@property(nonatomic,copy)void (^sectionClick)(BXCommentModel *model);
@property(nonatomic,copy)void (^clickZan)(BXCommentModel *model);

@end

NS_ASSUME_NONNULL_END

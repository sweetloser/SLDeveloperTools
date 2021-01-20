//
//  BXDynDetailNoPicCommentView.h
//  BXlive
//
//  Created by mac on 2020/7/31.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynDetailNoPicCommentView : UIView
@property (nonatomic , strong) BXDynCommentModel * model;
@property(nonatomic,copy)void (^toPersonHome)(NSString *userID);
@property(nonatomic,copy)void (^sectionClick)(BXDynCommentModel *model);
@property(nonatomic,copy)void (^clickZan)(BXDynCommentModel *model);
@property(nonatomic,copy)void (^SendMsgClick)(BXDynCommentModel *model);
@property(nonatomic,copy)void (^clicktipoff)(BXDynCommentModel *model);
@end

NS_ASSUME_NONNULL_END

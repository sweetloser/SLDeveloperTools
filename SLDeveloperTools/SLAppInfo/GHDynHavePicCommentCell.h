//
//  GHDynHavePicCommentCell.h
//  BXlive
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BXCommentModel.h"
#import "BXDynCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GHDynHavePicCommentCell : UITableViewCell
@property (nonatomic , strong) BXDynCommentModel * model;
@property (nonatomic , copy) void(^didPicture)(NSInteger index);


@end

NS_ASSUME_NONNULL_END

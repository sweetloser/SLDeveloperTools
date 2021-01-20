//
//  BXDynCommentDetailVC.h
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXDynCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynCommentDetailVC : BaseVC

@property(nonatomic, strong)NSString *dynType;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)BXDynCommentModel *model;
@end

NS_ASSUME_NONNULL_END

//
//  BXDynRecommendCell.h
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynCircleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynRecommendCell : UITableViewCell
@property (copy, nonatomic) void (^DidPicIndex)(NSString *circle_id);
@property(nonatomic, strong)BXDynCircleModel *model;
@property(nonatomic, strong)NSArray *array;
@end

NS_ASSUME_NONNULL_END

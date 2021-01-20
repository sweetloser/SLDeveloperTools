//
//  BXDynCircleHeaderView.h
//  BXlive
//
//  Created by mac on 2020/8/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynCircleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynCircleRecommendHeaderViewcell : UITableViewCell
@property (copy, nonatomic) void (^DidPicIndex)(NSString *circle_id);
@property(nonatomic, strong)BXDynCircleModel *model;
@property(nonatomic, strong)NSArray *array;
@end

NS_ASSUME_NONNULL_END

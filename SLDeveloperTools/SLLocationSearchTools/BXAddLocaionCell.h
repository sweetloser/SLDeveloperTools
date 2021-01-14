//
//  BXAddLocaionCell.h
//  BXlive
//
//  Created by bxlive on 2019/4/16.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXLocation.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXAddLocaionCell : UITableViewCell


@property(nonatomic,strong)BXLocation *model;

+ (instancetype) cellWithTableView :(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

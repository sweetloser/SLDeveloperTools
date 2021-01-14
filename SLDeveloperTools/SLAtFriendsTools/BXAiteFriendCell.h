//
//  BXAiteFriendCell.h
//  BXlive
//
//  Created by bxlive on 2019/5/9.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXAttentFollowModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXAiteFriendCell : UITableViewCell
@property(nonatomic,strong)BXAttentFollowModel *model;
+ (instancetype)cellWithTableView :(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

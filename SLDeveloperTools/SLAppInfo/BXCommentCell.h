//
//  BXCommentCell.h
//  BXlive
//
//  Created by bxlive on 2019/5/6.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXCommentModel.h"

@interface BXCommentCell : UITableViewCell

@property (nonatomic , strong) BXCommentModel * model;
@property (nonatomic , copy) void(^toPersonHome)();

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end


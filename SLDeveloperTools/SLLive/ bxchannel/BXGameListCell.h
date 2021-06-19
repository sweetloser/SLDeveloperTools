//
//  BXGameListCell.h
//  BXlive
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXLiveChannel.h"

@interface BXGameListCell : UITableViewCell
@property(nonatomic,strong)BXLiveChannel *liveChannel;
@property(nonatomic,strong)UIView *lineView;

+ (instancetype) cellWithTableView :(UITableView *)tableView;
@end

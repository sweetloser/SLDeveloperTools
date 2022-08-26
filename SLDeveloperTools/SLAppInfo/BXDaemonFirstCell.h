//
//  BXDaemonFirstCell.h
//  BXlive
//
//  Created by bxlive on 2017/12/4.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDaemonListModel.h"
@interface BXDaemonFirstCell : UITableViewCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView;

- (void)loadCellData:(BXDaemonListModel *)model indexPath:(NSIndexPath *)indexPath;

-(void)updateUIWithDataList:(NSArray *)listModel;

@end
//
//  BXMusicCategoryTableViewCell.h
//  BXlive
//
//  Created by bxlive on 2019/4/17.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXMusicCategoryModel.h"

@interface BXMusicCategoryTableViewCell : UITableViewCell

@property (nonatomic , strong) BXMusicCategoryModel * model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end


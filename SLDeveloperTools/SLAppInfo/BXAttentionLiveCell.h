//
//  BXAttentionLiveCell.h
//  BXlive
//
//  Created by bxlive on 2019/8/2.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXSLLiveRoom.h"


NS_ASSUME_NONNULL_BEGIN


@interface BXAttentionLiveCell : UITableViewCell

@property(nonatomic,strong) BXSLLiveRoom *model;

+ (instancetype) cellWithTableView :(UITableView *)tableView;



@end

NS_ASSUME_NONNULL_END





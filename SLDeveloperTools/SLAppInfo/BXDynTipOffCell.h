//
//  BXDynTipOffCell.h
//  BXlive
//
//  Created by mac on 2020/7/18.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynTitleListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynTipOffCell : UITableViewCell
@property(nonatomic, strong)BXDynTitleListModel *model;
@property(nonatomic, strong)NSString *concentString;
@property(nonatomic, strong)UILabel *Sellabel;
@property(nonatomic, strong)NSString *Seltip;
@property(nonatomic, assign)BOOL isSelected;
@end

NS_ASSUME_NONNULL_END

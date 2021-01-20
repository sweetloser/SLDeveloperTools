//
//  SLReportToolCell.h
//  BXlive
//
//  Created by sweetloser on 2020/12/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLReportToolModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLReportToolCell : UITableViewCell

@property(nonatomic, strong)SLReportToolModel *model;
@property(nonatomic, strong)NSString *concentString;
@property(nonatomic, strong)UILabel *selLabel;
@property(nonatomic, strong)NSString *Seltip;
@property(nonatomic, assign)BOOL isSelected;
@end

NS_ASSUME_NONNULL_END

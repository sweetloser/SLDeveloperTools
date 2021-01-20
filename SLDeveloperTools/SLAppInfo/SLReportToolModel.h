//
//  SLReportToolModel.h
//  BXlive
//
//  Created by sweetloser on 2020/12/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLReportToolModel : BaseObject

@property(nonatomic, copy)NSNumber *status;
@property(nonatomic, copy)NSNumber *ctime;
@property(nonatomic, copy)NSString *img;
@property(nonatomic, copy)NSNumber *sort;
@property(nonatomic, copy)NSString *entry_name;
@property(nonatomic, copy)NSString *entry_dis;
@property(nonatomic, copy)NSNumber *report_id;
@property(nonatomic, assign)BOOL isSelected;

@end

NS_ASSUME_NONNULL_END

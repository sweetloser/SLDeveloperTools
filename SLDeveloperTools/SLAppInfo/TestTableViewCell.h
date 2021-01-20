//
//  TestTableViewCell.h
//  BXlive
//
//  Created by mac on 2020/7/2.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynNewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TestTableViewCell : UITableViewCell
@property(nonatomic, strong)BXDynNewModel *model;

@property(nonatomic, assign)BOOL unfoldflag;
@end

NS_ASSUME_NONNULL_END

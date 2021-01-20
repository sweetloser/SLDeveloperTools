//
//  BXDynCircleShutCell.h
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynCircleShutCell : UITableViewCell
@property(nonatomic,copy)void(^DidShutClick)();
@property(nonatomic, strong)BXDynMemberModel *model;
@end

NS_ASSUME_NONNULL_END

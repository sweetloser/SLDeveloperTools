//
//  BXDynPeopleAdminCell.h
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynMemberModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol AdminManagerDelegate <NSObject>

-(void)DidClickMore;

@end
@interface BXDynPeopleAdminCell : UITableViewCell
@property(nonatomic,copy)void(^DidClickMore)();
@property(nonatomic, strong)BXDynMemberModel *model;
@property(nonatomic, weak)id<AdminManagerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

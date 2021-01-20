//
//  BXDynPeopleCommonCell.h
//  BXlive
//
//  Created by mac on 2020/8/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynMemberModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol CommonManagerDelegate <NSObject>

-(void)DidClickMore:(BXDynMemberModel *)model;

@end
@interface BXDynPeopleCommonCell : UITableViewCell
@property(nonatomic,copy)void(^DidClickMore)();
@property(nonatomic, strong)BXDynMemberModel *model;
@property(nonatomic, weak)id<CommonManagerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

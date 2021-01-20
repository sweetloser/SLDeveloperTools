//
//  BXDynPeopleManagerCell.h
//  BXlive
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynMemberModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol PeopleManagerDelegate <NSObject>

-(void)DidClickMore:(BXDynMemberModel *)model;

@end
@interface BXDynPeopleManagerCell : UITableViewCell
@property(nonatomic,copy)void(^DidClickMore)();
@property(nonatomic, strong)BXDynMemberModel *model;
@property(nonatomic, weak)id<PeopleManagerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

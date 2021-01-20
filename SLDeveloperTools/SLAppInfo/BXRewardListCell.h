//
//  BXRewardListCell.h
//  BXlive
//
//  Created by bxlive on 2019/4/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXLiveUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXRewardListCell : UITableViewCell

@property(nonatomic,strong)BXLiveUser *liveUser;
@property (nonatomic, assign) NSInteger num;



@end

NS_ASSUME_NONNULL_END

//
//  BXSLLiveUserCell.h
//  BXlive
//
//  Created by bxlive on 2019/3/8.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynamicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXSLLiveUserCell : UITableViewCell

@property (nonatomic, strong) BXLiveUser *liveUser;
@property (nonatomic, strong) BXDynamicModel *dynmodel;

@end

NS_ASSUME_NONNULL_END

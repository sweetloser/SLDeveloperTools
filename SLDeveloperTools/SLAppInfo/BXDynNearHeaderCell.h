//
//  BXDynNearHeaderCell.h
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynNearHeaderCell : UICollectionViewCell
@property(nonatomic, strong)BXDynTopicModel *model;
@property(nonatomic, strong)NSString *indextype;
@end

NS_ASSUME_NONNULL_END

//
//  BXDynTopicVideoCell.h
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHMovieModel.h"
#import "BXDynCircleModel.h"
#import "BXDynTopicModel.h"
#import "BXDynamicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynTopicVideoCell : UICollectionViewCell
@property (strong, nonatomic) BXDynCircleModel *circleModel;
@property (strong, nonatomic) BXDynTopicModel *topicModel;
@property (strong, nonatomic) BXDynamicModel *dynModel;
@end

NS_ASSUME_NONNULL_END

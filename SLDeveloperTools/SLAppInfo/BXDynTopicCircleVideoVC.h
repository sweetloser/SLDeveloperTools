//
//  BXDynTopicCircleVideoVC.h
//  BXlive
//
//  Created by mac on 2020/8/15.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXBaseVideoPlayVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXDynTopicCircleVideoVC : BXBaseVideoPlayVC

@property (nonatomic, copy) NSString *videoId;
@property(nonatomic, strong)NSString *skip_type;
@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END

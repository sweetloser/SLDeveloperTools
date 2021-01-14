//
//  BXShortVideoLocationSearchVC.h
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseVC.h"
#import "BXLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface BXShortVideoLocationSearchVC : BaseVC

@property(nonatomic,strong)UIImage *backImage;

@property(nonatomic,copy)void (^locationBlock)(BXLocation *location);


@end

NS_ASSUME_NONNULL_END

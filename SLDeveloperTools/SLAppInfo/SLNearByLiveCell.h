//
//  BXHotLiveFallsCell.h
//  BXlive
//
//  Created by bxlive on 2019/5/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXSLLiveRoom.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLNearByLiveCell : UICollectionViewCell

@property (nonatomic , strong) BXSLLiveRoom * liveRoom;

@property (nonatomic , strong) UIImageView * backImageView;

@end

NS_ASSUME_NONNULL_END

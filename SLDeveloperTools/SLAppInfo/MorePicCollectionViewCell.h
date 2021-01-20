//
//  MorePicCollectionViewCell.h
//  BXlive
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynamicModel.h"
#import "FLAnimatedImage.h"
NS_ASSUME_NONNULL_BEGIN

@interface MorePicCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)FLAnimatedImageView *CoverimageView;
@property(nonatomic, strong)BXDynamicModel *model;
@property(nonatomic, strong)UIImageView *identificationImage;
@end

NS_ASSUME_NONNULL_END

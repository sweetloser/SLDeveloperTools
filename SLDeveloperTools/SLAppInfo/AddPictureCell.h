//
//  AddPictureCell.h
//  BXlive
//
//  Created by mac on 2020/7/10.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
NS_ASSUME_NONNULL_BEGIN

@interface AddPictureCell : UICollectionViewCell
@property (copy, nonatomic) void (^DelPicture)();
@property(nonatomic, strong)FLAnimatedImageView *picImage;
@property(nonatomic, strong)NSString *picurl;
@property(nonatomic, strong)NSString *type;
@property (nonatomic, strong) NSArray<UIImage *> *imageArray;
@end

NS_ASSUME_NONNULL_END

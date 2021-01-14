//
//  DetailSendcomCollectionViewCell.h
//  BXlive
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailSendcomCollectionViewCell : UICollectionViewCell
@property (copy, nonatomic) void (^DelPicture)();
@property(nonatomic, strong)UIImageView *picImage;
@property(nonatomic, strong)NSString *picurl;
@property(nonatomic, strong)NSString *type;
@end

NS_ASSUME_NONNULL_END

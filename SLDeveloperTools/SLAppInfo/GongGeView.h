//
//  GongGeView.h
//  BXlive
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^imageClickBlock)(NSInteger tag);
@interface GongGeView : UIView
@property(nonatomic, strong)NSArray *imageArray;
-(void)begainLayImage;
@property (nonatomic, copy) imageClickBlock block;
@end

NS_ASSUME_NONNULL_END

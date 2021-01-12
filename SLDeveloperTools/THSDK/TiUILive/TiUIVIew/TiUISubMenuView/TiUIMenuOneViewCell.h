//
//  TiUISubMenuOneViewCell.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/5.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIMenuPlistManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TiUIMenuOneViewCell : UICollectionViewCell

@property(nonatomic,strong) TIMenuMode *mode;
 
@property(nonatomic,copy)void(^clickOnCellBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END

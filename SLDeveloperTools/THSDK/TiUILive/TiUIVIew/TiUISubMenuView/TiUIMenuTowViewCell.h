//
//  TiUIMenuTowViewCell.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/5.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIConfig.h"

@interface TiUIMenuTowViewCell : UICollectionViewCell

@property(nonatomic,strong) TIMenuMode *mode;

@property(nonatomic,copy)void(^clickOnCellBlock)(NSInteger index);

@end
 

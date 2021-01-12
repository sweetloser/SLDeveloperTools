//
//  TiUISubMenuTowViewCell.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/5.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIConfig.h"

typedef NS_ENUM(NSInteger, TiUISubMenuTowViewCellType) {
    TI_UI_TOWSUBCELL_TYPE_ONE,
    TI_UI_TOWSUBCELL_TYPE_TWO
};
@interface TiUISubMenuTowViewCell : UICollectionViewCell

@property(nonatomic,assign) TiUISubMenuTowViewCellType cellType;

@property(nonatomic,strong)TIMenuMode *subMod;

@end
 

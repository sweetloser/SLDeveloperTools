//
//  QuickRechargeCell.h
//  BXlive
//
//  Created by bxlive on 2018/9/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MybgCodeModel.h"
@interface QuickRechargeCell : UICollectionViewCell

@property(nonatomic,strong)MybgCodeModel *model;


-(void)setSelect:(BOOL)select;




@end

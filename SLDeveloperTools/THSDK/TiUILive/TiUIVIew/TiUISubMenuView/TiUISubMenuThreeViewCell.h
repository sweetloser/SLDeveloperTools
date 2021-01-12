//
//  TiUISubMenuThreeViewCell.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/6.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIConfig.h"
#import "TIButton.h"

@interface TiUISubMenuThreeViewCell : UICollectionViewCell

@property(nonatomic,strong)TIMenuMode *subMod;
- (void)setSubMod:(TIMenuMode *)subMod WithTag:(NSInteger)tag;
 
-(void)startAnimation;
-(void)endAnimation;

@end
 

//
//  SLOnLineUserReusableView.h
//  BXlive
//
//  Created by sweetloser on 2020/8/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLOnLineUserReusableView : UICollectionReusableView

@property(nonatomic,copy)void(^guardActionBlock)(void);

-(void)updateGuardData:(NSArray *)guardData;

@end

NS_ASSUME_NONNULL_END

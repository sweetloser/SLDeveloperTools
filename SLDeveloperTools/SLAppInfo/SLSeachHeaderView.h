//
//  SLSeachHeaderView.h
//  BXlive
//
//  Created by sweetloser on 2020/7/29.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLSeachHeaderView : UICollectionReusableView

@property(nonatomic,strong)UILabel *titleL;

@property(nonatomic,strong)UIButton *clearBtn;

@property(nonatomic,copy)void(^cleanBtnOnClickBlock)(void);

@end

NS_ASSUME_NONNULL_END

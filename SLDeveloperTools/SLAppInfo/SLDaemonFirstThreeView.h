//
//  SLDaemonFirstThreeView.h
//  BXlive
//
//  Created by sweetloser on 2020/8/11.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXDaemonListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SLDaemonFirstThreeView : UIView

-(instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;

-(void)updateUIWithModel:(nullable BXDaemonListModel *)model;


@end

NS_ASSUME_NONNULL_END

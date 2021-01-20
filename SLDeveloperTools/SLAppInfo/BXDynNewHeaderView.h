//
//  BXDynNewHeaderView.h
//  BXlive
//
//  Created by mac on 2020/6/29.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynamicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynNewHeaderView : UIView
@property (copy, nonatomic) void (^DidClickMore)();
@property(nonatomic, strong)BXDynamicModel *model;
@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong)UIImageView *VoiceImageView;
@property(nonatomic, strong)UILabel *duratimelable;
- (void)rotateView;
- (void)StoprotateView;
@end

NS_ASSUME_NONNULL_END

//
//  BXDynWhisperAlertView.h
//  BXlive
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXDynamicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BXDynWhisperAlertView : UIView
@property (copy, nonatomic) void (^sendComment)(NSString *text,NSString *jsonString);
@property(nonatomic, strong)BXDynamicModel *model;
-(instancetype)initWithFrame:(CGRect)frame model:(BXDynamicModel *)model;

-(void)showWithView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

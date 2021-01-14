//
//  ExpressAlertRemoveSoundView.h
//  BXlive
//
//  Created by mac on 2020/7/16.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BXDynAlertRemoveSoundView : UIView
@property(nonatomic,copy)void(^RemoveBlock)();
@property(nonatomic,copy)void(^CancleBlock)();

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Sure:(NSString *)sure Cancle:(NSString *)cancle;

-(void)showWithView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

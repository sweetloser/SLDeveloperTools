//
//  SLPopMenuView.h
//  BXlive
//
//  Created by sweetloser on 2020/5/22.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SLPopMenuDirectionTop,
    SLPopMenuDirectionLeft,
    SLPopMenuDirectionBottom,
    SLPopMenuDirectionRight,
} SLPopMenuDirection;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SLPopMenuItemCallBack)(NSString *title);

@interface SLPopMenuView : UIView

@property(nonatomic,copy)SLPopMenuItemCallBack itemCallBack;

+(SLPopMenuView *)popMenuView:(NSArray *)titleArr;

-(void)showWithView:(UIView *)view direction:(SLPopMenuDirection)direction;
@end

NS_ASSUME_NONNULL_END

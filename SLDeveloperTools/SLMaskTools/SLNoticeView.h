//
//  SLNoticeView.h
//  BXlive
//
//  Created by sweetloser on 2020/6/23.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLNoticeViewProtocol <NSObject>

-(void)determineBtnOnClick;

-(void)cancelBtnOnClick;

@end

@interface SLNoticeView : UIView

@property(nonatomic,weak)id<SLNoticeViewProtocol> delegate;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *message;

@property(nonatomic,copy)NSString *cancelTitle;

@property(nonatomic,copy)NSString *determineTitle;

@property(nonatomic,assign)BOOL canHidden;

-(void)showWithView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END

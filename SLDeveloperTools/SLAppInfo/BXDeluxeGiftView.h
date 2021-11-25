//
//  BXDeluxeGiftView.h
//  BXlive
//
//  Created by bxlive on 2018/10/30.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXDeluxeGiftViewDelegate <NSObject>

- (void)deluxeGiftViewDidCompleted:(NSString *)giftId userId:(NSString *)userId;

@end

@interface BXDeluxeGiftView : UIView

@property (nonatomic, copy) NSString *userId;
@property (weak, nonatomic) id <BXDeluxeGiftViewDelegate> delegate;

//0：全屏 1：居底 2：居中 3：居顶
- (instancetype)initWithGiftId:(NSString *)giftId oneFrameDuration:(NSTimeInterval)oneFrameDuration layout:(NSInteger)layout;
- (void)removeWithDuration:(NSTimeInterval)duration;
- (void)animationEffectDidEnd;

@end

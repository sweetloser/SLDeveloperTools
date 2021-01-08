//
//  SharePopView.h
//  BXlive
//
//  Created by bxlive on 2019/3/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol SharePopViewDelegate <NSObject>

- (void)sharePopViewIndex:(NSInteger)index;

@end


@interface SharePopView : UIView

@property (nonatomic,weak) id<SharePopViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame topIconsNameArray:(NSArray *)topIconsNameArray  bottomIconsNameArray:(NSArray *)bottomIconsNameArray;
- (void)show;
- (void)dismiss;

@end


@interface ShareItem:UIView
@property (nonatomic, assign) NSInteger     type;
@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;
@property (nonatomic, strong) UIButton          *clickBtn;
-(void)startAnimation:(NSTimeInterval)delayTime;



@end

NS_ASSUME_NONNULL_END

//
//  SharePopView.h
//  BXlive
//
//  Created by bxlive on 2019/3/1.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynShareObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DynSharePopViewDelegate <NSObject>

- (void)sharePopViewIndex:(NSInteger)index;

@end


@interface DynSharePopView : UIView

@property (nonatomic,weak) id<DynSharePopViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame topIconsNameArray:(NSArray *)topIconsNameArray  bottomIconsNameArray:(NSArray *)bottomIconsNameArray;
- (void)show;
- (void)dismiss;

@end


@interface DynShareItem: UIView
@property (nonatomic, assign) NSInteger     type;
@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;
@property (nonatomic, strong) UIButton          *clickBtn;
-(void)startAnimation:(NSTimeInterval)delayTime;



@end

NS_ASSUME_NONNULL_END

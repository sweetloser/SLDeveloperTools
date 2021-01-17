//
//  BXTransitionAnimation.h
//  BXlive
//
//  Created by bxlive on 2019/5/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BXTransitionType) {
    BXTransitionTypePresent = 0,//管理present动画
    BXTransitionTypeDissmiss,
    BXTransitionTypePush,
    BXTransitionTypePop,
};
//处理动画转场过渡的对象
@interface BXTransitionAnimation : NSObject
<UIViewControllerAnimatedTransitioning>

//动画转场类型
@property (nonatomic,assign) BXTransitionType transitionType;

@property (nonatomic, assign) CGRect centerFrame;

@end



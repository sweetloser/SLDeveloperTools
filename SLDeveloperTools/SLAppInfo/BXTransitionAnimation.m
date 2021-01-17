//
//  BXTransitionAnimation.m
//  BXlive
//
//  Created by bxlive on 2019/5/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXTransitionAnimation.h"
#import "BXAttentionVC.h"
#import "BaseNavVC.h"
#import "BXClickVideoViewVC.h"
#import "BXAttentionVideoCell.h"
@implementation BXTransitionAnimation

//返回动画事件
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}

//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_transitionType) {
        case BXTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case BXTransitionTypeDissmiss:
            [self dismissAnimation:transitionContext];
            break;
        case BXTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        case BXTransitionTypePop:
            [self popAnimation:transitionContext];
            break;

        default:
            break;
    }
    
}

#pragma mark -- transitionType

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
    BXClickVideoViewVC * toVC = (BXClickVideoViewVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    BXAttentionVC * fromVC;
    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[BaseNavVC class]]) {
        BaseNavVC * na = (BaseNavVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromVC = na.viewControllers.lastObject;
    }else if([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[BXAttentionVC class]]){
        fromVC = (BXAttentionVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    
    //获取点击的cell
    BXAttentionVideoCell * cell = [fromVC.tableView cellForRowAtIndexPath:fromVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:toVC.view];
    CGRect initialFrame = [fromVC.tableView convertRect:cell.backView.frame toView:[fromVC.tableView superview]];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    toVC.view.center = CGPointMake(initialFrame.origin.x + initialFrame.size.width/2, initialFrame.origin.y + initialFrame.size.height/2);
    toVC.view.transform = CGAffineTransformMakeScale(initialFrame.size.width/finalFrame.size.width, initialFrame.size.height/finalFrame.size.height);
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         toVC.view.center = CGPointMake(finalFrame.origin.x + finalFrame.size.width/2, finalFrame.origin.y + finalFrame.size.height/2);
                         toVC.view.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
    BXAttentionVC * toVC;
    BXClickVideoViewVC * fromVC = (BXClickVideoViewVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[BaseNavVC class]]) {
        BaseNavVC * na = (BaseNavVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC = na.viewControllers.firstObject;
    }else if([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[BXAttentionVC class]]){
        toVC = (BXAttentionVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    
    //获取点击的cell
    BXAttentionVideoCell * cell = [toVC.tableView cellForRowAtIndexPath:toVC.currentIndexPath];
    
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor clearColor];
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView *tempView = [fromVC.containerView snapshotViewAfterScreenUpdates:NO];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.frame = [fromVC.containerView convertRect:fromVC.containerView.bounds toView:containerView];
    
    //设置初始状态
    fromVC.containerView.hidden = YES;
    //tempView 添加到containerView中
    [containerView addSubview:tempView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        tempView.frame = [cell.backView convertRect:cell.backView.bounds toView:containerView];
//        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            [tempView removeFromSuperview];
            fromVC.containerView.hidden = NO;
        }else{
            //手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            cell.backView.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
    
}



- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    
    //完成转场
    [transitionContext completeTransition:YES];
    
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //由于加入了手势必须判断
    [transitionContext completeTransition:YES];
}


@end


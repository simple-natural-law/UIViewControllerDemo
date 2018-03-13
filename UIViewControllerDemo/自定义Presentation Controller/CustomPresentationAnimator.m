//
//  CustomPresentationAnimator.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/13.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CustomPresentationAnimator.h"

@implementation CustomPresentationAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 转场过渡动画的容器view
    UIView *containerView = [transitionContext containerView];
    
    if (self.isDismissAnimation)
    {
        // fromVC
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *fromView = fromViewController.view;
        
        fromView.frame = [transitionContext finalFrameForViewController:fromViewController];
        
        fromView.transform = CGAffineTransformIdentity;
        
        [containerView addSubview:fromView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromView.transform = CGAffineTransformMakeTranslation(0.0, fromView.frame.size.height);
            
        }completion:^(BOOL finished) {
            
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
        }];
        
    }else
    {
        // toVC
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *toView = toViewController.view;
        [containerView addSubview:toView];
        
        toView.frame = [transitionContext finalFrameForViewController:toViewController];
        
        toView.transform = CGAffineTransformMakeTranslation(0.0, toView.frame.size.height);
        
        [containerView addSubview:toView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            toView.transform = CGAffineTransformIdentity;
            
        }completion:^(BOOL finished) {
            
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
        }];
    }
}

@end

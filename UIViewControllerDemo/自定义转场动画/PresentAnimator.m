//
//  PresentAnimator.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/12.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "PresentAnimator.h"

@implementation PresentAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 转场过渡动画的容器view
    UIView *containerView = [transitionContext containerView];
    
    // fromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    [containerView addSubview:fromView];
    
    // toVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    toView.hidden = YES;
    
    // fromVC的图片背景的空白view(设置和控制器的背景颜色一样，给人一种图片被调走的假象 [可以换种颜色看看效果])
    UIView *imageBackground = [[UIView alloc] initWithFrame:self.beforeFrame];
    imageBackground.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:imageBackground];
    
    // 渐变的黑色背景
    UIView *background = [[UIView alloc] initWithFrame:containerView.bounds];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.0;
    [containerView addSubview:background];
    
    // 过渡的图片
    UIImageView *transtionImageView = [[UIImageView alloc] init];
    transtionImageView.frame = self.beforeFrame;
    transtionImageView.contentMode = UIViewContentModeScaleAspectFill;
    transtionImageView.clipsToBounds = YES;
    transtionImageView.image = self.transitionImage;
    [containerView addSubview:transtionImageView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        transtionImageView.frame = self.afterFrame;
        background.alpha = 1;
        
    }completion:^(BOOL finished) {
        
        toView.hidden = NO;
        
        [imageBackground removeFromSuperview];
        [background removeFromSuperview];
        [transtionImageView removeFromSuperview];
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end

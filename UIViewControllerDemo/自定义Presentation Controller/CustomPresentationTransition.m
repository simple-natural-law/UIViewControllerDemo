//
//  CustomPresentationTransition.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/13.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CustomPresentationTransition.h"
#import "CustomPresentationViewController.h"
#import "CustomPresentationAnimator.h"

@implementation CustomPresentationTransition

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    CustomPresentationViewController *vc = [[CustomPresentationViewController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    
    return vc;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    CustomPresentationAnimator *animator = [[CustomPresentationAnimator alloc] init];
    
    animator.isDismissAnimation = YES;
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    CustomPresentationAnimator *animator = [[CustomPresentationAnimator alloc] init];
    
    animator.isDismissAnimation = NO;
    
    return animator;
}

@end

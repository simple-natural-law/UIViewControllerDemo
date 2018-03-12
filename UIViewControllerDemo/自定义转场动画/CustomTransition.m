//
//  CustomTransition.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/12.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CustomTransition.h"
#import "PresentAnimator.h"
#import "DismissAnimator.h"

@implementation CustomTransition

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    DismissAnimator *aniamtor = [[DismissAnimator alloc] init];
    
    return aniamtor;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    PresentAnimator *animator = [[PresentAnimator alloc] init];
    
    return animator;
}

@end

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


@interface CustomTransition ()

@property (nonatomic, assign) CGRect animationStartFrame;

@property (nonatomic, strong) UIImage *transitionImage;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveAnimator;

@end

@implementation CustomTransition


- (void)setTransitionImage:(UIImage *)transitionImage animationStartFrame:(CGRect)animationStartFrame
{
    self.animationStartFrame = animationStartFrame;
    
    self.transitionImage = transitionImage;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    DismissAnimator *animator = [[DismissAnimator alloc] init];
    
    animator.endFrame = self.animationStartFrame;
    
    animator.transitionImage = self.transitionImage;
    
    return animator;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    PresentAnimator *animator = [[PresentAnimator alloc] init];
    
    animator.startFrame = self.animationStartFrame;
    
    animator.transitionImage = self.transitionImage;
    
    return animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveAnimator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveAnimator;
}

- (void)finishInteractiveTransition
{
    [self.interactiveAnimator finishInteractiveTransition];
}

- (void)cancelInteractiveTransition
{
    [self.interactiveAnimator cancelInteractiveTransition];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [self.interactiveAnimator updateInteractiveTransition:percentComplete];
}

- (UIPercentDrivenInteractiveTransition *)interactiveAnimator
{
    if (_interactiveAnimator == nil)
    {
        _interactiveAnimator = [[UIPercentDrivenInteractiveTransition alloc] init];
    }
    
    return _interactiveAnimator;
}

@end

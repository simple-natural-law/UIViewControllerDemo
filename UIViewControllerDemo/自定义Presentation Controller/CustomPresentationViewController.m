//
//  CustomPresentationViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/13.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CustomPresentationViewController.h"

@interface CustomPresentationViewController ()

@property (nonatomic, strong) UIView *backgroundView;

@end


@implementation CustomPresentationViewController


// 覆写此方法来设置呈现的视图控制器的尺寸
- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect presentedViewFrame = CGRectZero;
    
    CGRect containerBounds = self.containerView.bounds;
    
    presentedViewFrame.size = CGSizeMake(containerBounds.size.width, floorf(containerBounds.size.height / 2.0));
    
    presentedViewFrame.origin.y = containerBounds.size.height - presentedViewFrame.size.height;
    
    return presentedViewFrame;
}

- (void)presentationTransitionWillBegin
{
    self.backgroundView = [[UIView alloc] initWithFrame:self.containerView.frame];
    
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    
    self.backgroundView.alpha = 0.0;
    
    [self.containerView insertSubview:self.backgroundView atIndex:0];
    
    UIViewController *presentedViewController = [self presentedViewController];
    
    if ([presentedViewController transitionCoordinator])
    {
        [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
            self.backgroundView.alpha = 1.0;
            
        } completion:nil];
    }else
    {
        self.backgroundView.alpha = 1.0;
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed)
    {
        [self.backgroundView removeFromSuperview];
        
        self.backgroundView = nil;
    }
}

- (void)dismissalTransitionWillBegin
{
    UIViewController *presentedViewController = [self presentedViewController];
    
    if ([presentedViewController transitionCoordinator])
    {
        [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
            self.backgroundView.alpha = 0.0;
            
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
            [self.backgroundView removeFromSuperview];
            
            self.backgroundView = nil;
        }];
    }else
    {
        self.backgroundView.alpha = 0.0;
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (!completed)
    {
        [self.backgroundView removeFromSuperview];
        
        self.backgroundView = nil;
    }
}

@end

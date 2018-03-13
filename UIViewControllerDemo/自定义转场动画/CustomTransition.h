//
//  CustomTransition.h
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/12.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomTransition : NSObject<UIViewControllerTransitioningDelegate>

- (void)setTransitionImage:(UIImage *)transitionImage animationStartFrame:(CGRect)animationStartFrame;

- (void)finishInteractiveTransition;

- (void)cancelInteractiveTransition;

- (void)updateInteractiveTransition:(CGFloat)percentComplete;

@end

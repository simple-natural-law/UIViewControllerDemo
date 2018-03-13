//
//  CustomPresentationTransition.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/13.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CustomPresentationTransition.h"
#import "CustomPresentationViewController.h"

@implementation CustomPresentationTransition

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    CustomPresentationViewController *vc = [[CustomPresentationViewController alloc] init];
    
    return vc;
}

@end

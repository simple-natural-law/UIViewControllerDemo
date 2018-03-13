//
//  CustomPresentationAnimator.h
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/13.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomPresentationAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isDismissAnimation;

@end

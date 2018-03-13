//
//  DismissAnimator.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/12.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "DismissAnimator.h"

@implementation DismissAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    //图片背景的空白view (设置和控制器的背景颜色一样，给人一种图片被调走的假象)
    UIView *imgBgWhiteView = [[UIView alloc] initWithFrame:self.endFrame];
    imgBgWhiteView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:imgBgWhiteView];
    
    //有渐变的黑色背景
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 1;
    [containerView addSubview:bgView];
    
    //过渡的图片
    UIImageView *transitionImgView = [[UIImageView alloc] init];
    transitionImgView.frame = [self getFullScreenImageRectWithImage:self.transitionImage];
    transitionImgView.contentMode = UIViewContentModeScaleAspectFill;
    transitionImgView.clipsToBounds = YES;
    transitionImgView.image = self.transitionImage;
    [transitionContext.containerView addSubview:transitionImgView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        transitionImgView.frame = self.endFrame;
        bgView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        
        [imgBgWhiteView removeFromSuperview];
        [bgView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (CGRect)getFullScreenImageRectWithImage:(UIImage *)image
{
    CGSize size = image.size;
    
    CGFloat scaleX = [UIScreen mainScreen].bounds.size.width/size.width;
    
    CGFloat scaleY = [UIScreen mainScreen].bounds.size.height/size.height;
    
    if (scaleX > scaleY)
    {
        CGFloat width = size.width * scaleY;
        
        return CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 - width/2.0, 0.0, width, [UIScreen mainScreen].bounds.size.height);
        
    }else
    {
        CGFloat height = size.height * scaleX;
        
        return CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2.0 - height/2.0, [UIScreen mainScreen].bounds.size.width, height);
    }
}

@end

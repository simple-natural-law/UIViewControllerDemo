//
//  CustomTransitionDemoViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/12.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CustomTransitionDemoViewController.h"
#import "CustomTransition.h"

@interface CustomTransitionDemoViewController ()

@property (nonatomic, strong) CustomTransition *customTransition;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CustomTransitionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _customTransition = nil;
}


- (IBAction)tapAction:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.customTransition setTransitionImage:self.imageView.image animationStartFrame:[self.view convertRect:self.imageView.frame toView:[UIApplication sharedApplication].delegate.window]];
        
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailsViewController"];
        vc.transitioningDelegate = self.customTransition;
        
        [self presentViewController:vc animated:YES completion:^{
            
            NSLog(@"呈现此视图控制器的请求被路由到：%@，由它来呈现此视图控制器。",vc.presentingViewController);
        }];
    }
}

- (IBAction)panAction:(UIPanGestureRecognizer *)sender
{
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self.customTransition setTransitionImage:self.imageView.image animationStartFrame:[self.view convertRect:self.imageView.frame toView:[UIApplication sharedApplication].delegate.window]];
            
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailsViewController"];
            
            vc.transitioningDelegate = self.customTransition;
            
            [self presentViewController:vc animated:YES completion:^{
                
                NSLog(@"呈现此视图控制器的请求被路由到：%@，由它来呈现此视图控制器。",vc.presentingViewController);
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [sender translationInView:self.view];
            
            // 根据手指拖动的距离计算一个百分比，切换的动画效果也随着这个百分比来走
            CGFloat percentComplete = fabs(translation.x / self.view.frame.size.width);
            
            [self.customTransition updateInteractiveTransition:percentComplete];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint translation = [sender translationInView:self.view];
            
            // 根据手指拖动的距离计算一个百分比，切换的动画效果也随着这个百分比来走
            CGFloat percentComplete = fabs(translation.x / self.view.frame.size.width);
            
            // 移动超过 2/5 就强制完成
            if (percentComplete > 0.3)
            {
                [self.customTransition finishInteractiveTransition];
            }else
            {
                [self.customTransition cancelInteractiveTransition];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self.customTransition cancelInteractiveTransition];
        }
            break;
        default:
            break;
    }
}


- (CustomTransition *)customTransition
{
    if (_customTransition == nil)
    {
        _customTransition = [[CustomTransition alloc] init];
    }
    
    return _customTransition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

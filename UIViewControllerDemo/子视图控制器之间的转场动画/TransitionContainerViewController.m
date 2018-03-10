//
//  TransitionContainerViewController.m
//  UIViewControllerDemo
//
//  Created by 张诗健 on 2018/3/10.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "TransitionContainerViewController.h"
#import "CustomChildViewController.h"

@interface TransitionContainerViewController ()

@property (assign, nonatomic) BOOL didShowDetail;

@end

@implementation TransitionContainerViewController

- (void)dealloc
{
    NSLog(@"\n *** dealloc *** : %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.didShowDetail = NO;
    
    UIBarButtonItem *transitionItem = [[UIBarButtonItem alloc] initWithTitle:@"transition" style:UIBarButtonItemStylePlain target:self action:@selector(performTransition)];
    
    self.navigationItem.rightBarButtonItem = transitionItem;
}

- (void)performTransition
{
    UIViewController *currentVC = self.childViewControllers.firstObject;
    
    UIViewController *toVC = self.didShowDetail ? [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomChildViewController"] : [[CustomChildViewController alloc] init];
    
    [currentVC willMoveToParentViewController:nil];
    
    [self addChildViewController:toVC];
    
    toVC.view.frame = currentVC.view.frame;
    
    toVC.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [self transitionFromViewController:currentVC toViewController:toVC duration:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [currentVC removeFromParentViewController];
        
        [toVC didMoveToParentViewController:self];
        
        self.didShowDetail = !self.didShowDetail;
    }];
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

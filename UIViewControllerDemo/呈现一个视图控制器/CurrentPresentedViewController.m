//
//  CurrentPresentedViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/12.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CurrentPresentedViewController.h"

@interface CurrentPresentedViewController ()

@end

@implementation CurrentPresentedViewController

- (void)dealloc
{
    NSLog(@"\n *** dealloc *** : %@", self);
}

- (instancetype)initWithTransitionStyle:(UIModalTransitionStyle)transitionStyle
{
    self = [super init];
    
    if (self)
    {
        self.modalTransitionStyle = transitionStyle;
        
        self.view.backgroundColor = [UIColor greenColor];
    }
    
    return self;
}

- (instancetype)initWithPresentationStyle:(UIModalPresentationStyle)PresentationStyle
{
    self = [super init];
    
    if (self)
    {
        self.modalPresentationStyle = PresentationStyle;
            
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    dismissButton.backgroundColor = [UIColor blueColor];
    
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [dismissButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dismissButton];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:dismissButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:dismissButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:dismissButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:dismissButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[width,height,centerX,centerY]];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

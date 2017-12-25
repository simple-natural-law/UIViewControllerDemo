//
//  ViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2017/12/7.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "ViewController.h"
#import "SplitViewController.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30.0, 30.0);
    [leftItem setTitle:@"显示" forState:UIControlStateNormal];
    [leftItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(showBar) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
}


- (void)showBar
{
    SplitViewController *vc = (SplitViewController *)self.navigationController.parentViewController;
    
    [vc show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  SplitViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2017/12/20.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "SplitViewController.h"

@interface SplitViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sideBarViewCenterX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeViewLeading;

@end


@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)show
{
    UIViewController *sideBarVC = self.childViewControllers.firstObject;
    
    self.sideBarViewCenterX.constant = sideBarVC.view.frame.size.width/2.0;
    
    self.homeViewLeading.constant = sideBarVC.view.frame.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
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

//
//  ContainerViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/12.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end


@implementation ContainerViewController

- (void)dealloc
{
    NSLog(@"\n *** dealloc *** : %@", self);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)dismissViewController:(id)sender
{
#warning- 不知为何，在视图控制器A呈现的视图控制器未移除时，直接移除此视图控制器，会导致视图控制器A和呈现的视图控制器不走dealloc方法
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.childViewControllers.firstObject.presentedViewController dismissViewControllerAnimated:NO completion:nil];
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

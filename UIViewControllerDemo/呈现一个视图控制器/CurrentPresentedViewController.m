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
    
    dismissButton.frame = CGRectMake(0, 0, 100, 40);
    
    dismissButton.center = self.view.center;
    
    dismissButton.backgroundColor = [UIColor blueColor];
    
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [dismissButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dismissButton];
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

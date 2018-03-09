//
//  CustomChildViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/9.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CustomChildViewController.h"

@interface CustomChildViewController ()

@property (strong, nonatomic) NSString *identifier;

@end

@implementation CustomChildViewController

- (void)dealloc
{
    NSLog(@"\n *** dealloc *** : %@---%@", self.identifier,self);
}

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    
    if (self)
    {
        self.identifier = identifier;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    
    NSLog(@"%@ --- viewDidLoad",self.identifier);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@ --- viewWillAppear",self.identifier);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%@ --- viewDidAppear",self.identifier);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"%@ --- viewWillDisappear",self.identifier);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSLog(@"%@ --- viewDidDisappear",self.identifier);
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

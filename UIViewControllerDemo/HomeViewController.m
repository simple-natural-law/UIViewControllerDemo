//
//  HomeViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2017/12/7.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomContainerViewController.h"
#import "CustomChildViewController.h"


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.restorationIdentifier = NSStringFromClass([self class]);
    
    self.title = @"UIViewControllerDemo";
    
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    self.dataSource = @[@{@"title":@"实现一个自定义容器视图控制器",@"target":@"CustomContainerViewController"},
                        @{@"title":@"子视图控制器之间的转场动画",@"target":@"TransitionContainerViewController"},
                        @{@"title":@"呈现一个视图控制器",@"target":@"PresentingViewController"},
                        @{@"title":@"自定义转场动画",@"target":@"CustomTransitionDemoViewController"},
                        @{@"title":@"自定义Presentation Controller",@"target":@"CustomPresentationViewController"}];
}


#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        NSArray *titleArray = @[@"标题A",@"标题B",@"标题C",@"标题D"];
        
        CustomChildViewController *childA = [[CustomChildViewController alloc] initWithIdentifier:@"childA"];
        CustomChildViewController *childB = [[CustomChildViewController alloc] initWithIdentifier:@"childB"];
        CustomChildViewController *childC = [[CustomChildViewController alloc] initWithIdentifier:@"childC"];
        CustomChildViewController *childD = [[CustomChildViewController alloc] initWithIdentifier:@"childD"];
        NSArray *viewControllers = @[childA,childB,childC,childD];
        
        CustomContainerViewController *containerViewController = [[CustomContainerViewController alloc] initWithTitleArray:titleArray viewControllers:viewControllers];
        
        [self.navigationController pushViewController:containerViewController animated:YES];
        
    }else
    {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:self.dataSource[indexPath.row][@"target"]];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

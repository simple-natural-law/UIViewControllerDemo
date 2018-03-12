//
//  PresentingViewController.m
//  UIViewControllerDemo
//
//  Created by 张诗健 on 2018/3/10.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "PresentingViewController.h"
#import "CurrentPresentedViewController.h"


@interface PresentingViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) NSArray *titleArray;

@end


@implementation PresentingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleArray = @[@[@"UIModalPresentationFullScreen",@"UIModalPresentationPopover",@"UIModalPresentationOverFullScreen",@"自定义呈现样式"],@[@"UIModalTransitionStyleCoverVertical"]];
}

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return @"呈现样式";
        }
            break;
        case 1:
        {
            return @"转场动画样式";
        }
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UIViewController *vc = [[CurrentPresentedViewController alloc] initWithPresentationStyle:UIModalPresentationFullScreen];
                    
                    [self presentViewController:vc animated:YES completion:^{
                        
                        NSLog(@"呈现此视图控制器的请求被路由到：%@，由它来呈现此视图控制器。",vc.presentingViewController);
                    }];
                }
                    break;
                case 1:
                {
                    UIViewController *vc = [[CurrentPresentedViewController alloc] initWithPresentationStyle:UIModalPresentationPopover];
                    // 设置视图控制器的尺寸
                    vc.preferredContentSize = CGSizeMake(200, 200);
                    
                    vc.popoverPresentationController.backgroundColor = [UIColor whiteColor];
                    
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    vc.popoverPresentationController.sourceView = cell.contentView;
                    
                    vc.popoverPresentationController.sourceRect = cell.contentView.bounds;
                    
                    vc.popoverPresentationController.delegate = self;
                    
                    [self presentViewController:vc animated:YES completion:^{
                        
                        NSLog(@"呈现此视图控制器的请求被路由到：%@，由它来呈现此视图控制器。",vc.presentingViewController);
                    }];
                }
                    break;
                case 2:
                {
                    UIViewController *vc = [[CurrentPresentedViewController alloc] initWithPresentationStyle:UIModalPresentationOverFullScreen];
                    
                    vc.view.backgroundColor = [UIColor clearColor];
                    
                    [self presentViewController:vc animated:YES completion:^{
                        
                        NSLog(@"呈现此视图控制器的请求被路由到：%@，由它来呈现此视图控制器。",vc.presentingViewController);
                    }];
                }
                    break;
                case 3:
                {
                    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContainerViewController"];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark- UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
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

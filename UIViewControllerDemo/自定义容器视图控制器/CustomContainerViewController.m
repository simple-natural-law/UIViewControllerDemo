//
//  CustomContainerViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/1/18.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CustomContainerViewController.h"

@interface CustomContainerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIScrollView *contentView;

@property (strong, nonatomic) NSArray<NSString *> *titleArray;

@property (strong, nonatomic) NSArray<UIViewController *> *viewControllers;

@end


@implementation CustomContainerViewController

- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray viewControllers:(NSArray <UIViewController *>*)viewControllers
{
    self = [super init];
    
    if (self)
    {
        self.titleArray = titleArray;
        
        self.viewControllers = viewControllers;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"自定义容器视图控制器";
    
    [self setUI];
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *titleLabel = [cell.contentView viewWithTag:10086];
    
    if (titleLabel == nil)
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 60.0)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = 10086;
        [cell.contentView addSubview:titleLabel];
    }
    
    titleLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row----> %ld",indexPath.row);
}

#pragma mark- Methods
- (void)setUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(90.0, 50.0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height == self.view.frame.size.height ? self.navigationController.navigationBar.subviews.firstObject.frame.size.height : 0.0, self.view.frame.size.width, 50.0) collectionViewLayout:flowLayout];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator   = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.collectionView.frame.origin.y - self.collectionView.frame.size.height)];
    self.contentView.delegate = self;
    self.contentView.showsHorizontalScrollIndicator = YES;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.contentSize = CGSizeMake(self.viewControllers.count*self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.contentView.pagingEnabled = YES;
    self.contentView.bounces = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    UIViewController *vc = self.viewControllers.firstObject;
    
    [self displayChildViewController:vc atIndex:0];
}

- (void)displayChildViewController:(UIViewController *)childViewController atIndex:(NSInteger)index
{
    [self addChildViewController:childViewController];
    
    childViewController.view.frame = CGRectMake(self.contentView.frame.size.width*index, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    [self.contentView addSubview:childViewController.view];
    
    [childViewController didMoveToParentViewController:self];
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

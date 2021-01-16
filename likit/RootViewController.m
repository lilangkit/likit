//
//  RootViewController.m
//  likit
//
//  Created by 李浪 on 2021/1/16.
//

#import "RootViewController.h"

#import "LKBaseNavigationController.h"
#import "LKHomeViewController.h"
#import "LKMineViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 首页
    LKHomeViewController *homeVC = [[LKHomeViewController alloc] init];
    LKBaseNavigationController *homeNavVC = [[LKBaseNavigationController alloc] initWithRootViewController:homeVC];
    homeNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                         image:[[UIImage imageNamed:@"home_icon_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                 selectedImage:[[UIImage imageNamed:@"home_icon_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                            ];
    
    // 我的
    LKMineViewController *mineVC = [[LKMineViewController alloc] init];
    LKBaseNavigationController *mineNavVC = [[LKBaseNavigationController alloc] initWithRootViewController:mineVC];
    mineNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                         image:[[UIImage imageNamed:@"mine_icon_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                 selectedImage:[[UIImage imageNamed:@"mine_icon_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                            ];
    
    NSArray *viewControllers = @[homeNavVC, mineNavVC];
    [self setViewControllers:viewControllers];
}

@end

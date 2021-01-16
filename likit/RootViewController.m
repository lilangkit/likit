//
//  RootViewController.m
//  likit
//
//  Created by 李浪 on 2021/1/16.
//

#import "RootViewController.h"

#import "LKBaseNavigationController.h"
#import "LKHomeViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 首页
    LKHomeViewController *homeVC = [[LKHomeViewController alloc] init];
    LKBaseNavigationController *homeNavVC = [[LKBaseNavigationController alloc] initWithRootViewController:homeVC];
    homeNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"home_icon_normal"] selectedImage:[UIImage imageNamed:@"home_icon_selected"]];
    
    NSArray *viewControllers = @[homeNavVC];
    [self setViewControllers:viewControllers];
}

@end

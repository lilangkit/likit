//
//  LKBaseTabBarController.m
//  likit
//
//  Created by 李浪 on 2021/1/16.
//

#import "LKBaseTabBarController.h"

@interface LKBaseTabBarController ()

@end

@implementation LKBaseTabBarController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 修改tabBar高度
    if (![LKDeviceUtil safeArea]) {
        CGRect frame = self.tabBar.frame;
        frame.size.height = 56;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        self.tabBar.frame = frame;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end

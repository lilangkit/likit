//
//  LKBaseNavigationController.m
//  likit
//
//  Created by 李浪 on 2021/1/16.
//

#import "LKBaseNavigationController.h"

@interface LKBaseNavigationController ()

@end

@implementation LKBaseNavigationController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 调整tabBarItem字体
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarappearance = [UITabBarAppearance new];
        UIInterfaceOrientation interfaceOrientation = [LKDeviceUtil interfaceOrientation];
        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            tabBarappearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffsetMake(0, -3);
            tabBarappearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffsetMake(0, -3);
        }
        tabBarappearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:K_TAB_BAR_ITEM_FOREGROUND_COLOR_NORMAL,
                                                                               NSForegroundColorAttributeName,
                                                                               [UIFont systemFontOfSize:11.0],
                                                                               NSFontAttributeName,
                                                                               nil];
        tabBarappearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:K_TAB_BAR_ITEM_FOREGROUND_COLOR_SELECTED,
                                                                                 NSForegroundColorAttributeName,
                                                                                 [UIFont systemFontOfSize:11.0],
                                                                                 NSFontAttributeName,
                                                                                 nil];
        self.tabBarItem.standardAppearance = tabBarappearance;
        
        self.tabBarController.tabBar.tintColor = K_TAB_BAR_ITEM_FOREGROUND_COLOR_SELECTED;
        self.tabBarController.tabBar.unselectedItemTintColor = K_TAB_BAR_ITEM_FOREGROUND_COLOR_NORMAL;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end

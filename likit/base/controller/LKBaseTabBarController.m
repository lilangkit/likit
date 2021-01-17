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
    // 设备方向
    UIInterfaceOrientation interfaceOrientation = [LKDeviceUtil interfaceOrientation];
    // 竖屏
    BOOL portrait = interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
    // tabBarItem文字位置
    UIOffset titlePositionAdjustment;
    if (portrait) {
        titlePositionAdjustment = UIOffsetMake(0, -3);
        // tabBar高度
        if (![LKDeviceUtil safeArea]) {// 非刘海屏
            CGRect frame = self.tabBar.frame;
            frame.size.height = 56;
            frame.origin.y = self.view.frame.size.height - frame.size.height;
            self.tabBar.frame = frame;
        }
    } else {
        titlePositionAdjustment = UIOffsetMake(0, 0);
    }
    // tabBarItem文字字体、颜色
    NSDictionary<NSAttributedStringKey, id> *titleTextAttributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:K_TAB_BAR_ITEM_FOREGROUND_COLOR_NORMAL,
                                                                          NSForegroundColorAttributeName,
                                                                          [UIFont systemFontOfSize:11.0],
                                                                          NSFontAttributeName,
                                                                          nil];
    NSDictionary<NSAttributedStringKey, id> *titleTextAttributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:K_TAB_BAR_ITEM_FOREGROUND_COLOR_SELECTED,
                                                                            NSForegroundColorAttributeName,
                                                                            [UIFont systemFontOfSize:11.0],
                                                                            NSFontAttributeName,
                                                                            nil];
    // tabBar颜色
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarAppearance = [UITabBarAppearance new];
        // 文字位置
        tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = titlePositionAdjustment;
        tabBarAppearance.stackedLayoutAppearance.selected.titlePositionAdjustment = titlePositionAdjustment;
        // 文字字体、颜色
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = titleTextAttributesNormal;
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = titleTextAttributesSelected;
        // tabBar背景颜色
        tabBarAppearance.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
        // tabBar分隔线颜色
        tabBarAppearance.shadowColor = K_SEPARATOR_COLOR;
        // 设置
        self.tabBar.standardAppearance = tabBarAppearance;
        // 横屏tabBarItem文字字体、颜色
        self.tabBar.tintColor = K_TAB_BAR_ITEM_FOREGROUND_COLOR_SELECTED;
        self.tabBar.unselectedItemTintColor = K_TAB_BAR_ITEM_FOREGROUND_COLOR_NORMAL;
    } else {
        for (UIViewController *viewController in self.viewControllers) {
            UITabBarItem *tabBarItem = viewController.tabBarItem;
            // 文字位置
            [tabBarItem setTitlePositionAdjustment:titlePositionAdjustment];
            // 文字字体、颜色
            [tabBarItem setTitleTextAttributes:titleTextAttributesNormal
                                      forState:UIControlStateNormal];
            [tabBarItem setTitleTextAttributes:titleTextAttributesSelected
                                      forState:UIControlStateSelected];
        }
        // 背景颜色
        self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
        // 分隔线颜色
        self.tabBar.shadowImage = [UIImage imageWithColor:K_SEPARATOR_COLOR];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end

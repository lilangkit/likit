//
//  AppDelegate.m
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

#import "AppDelegate.h"

#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置控件的默认属性
    [self configAppearance];
    
    //创建window
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    // 初始化第三方SDK
    
    // 进入主界面
    [self enterMainUI];
    
    return YES;
}

/**
 * 设置控件的默认属性
 */
- (void)configAppearance {
    
}

/**
 * 进入主界面
 */
- (void)enterMainUI {
    _window.rootViewController = [[RootViewController alloc] init];
}

@end

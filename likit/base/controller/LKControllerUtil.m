//
//  LKControllerUtil.m
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

#import "LKControllerUtil.h"

@implementation LKControllerUtil

+ (UIViewController *)currentViewController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}

+ (UIViewController *)presentedViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

+ (UINavigationController *)navigationViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)window.rootViewController;
    } else if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectVc = [((UITabBarController *)window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)selectVc;
        }
    }
    
    return nil;
}

+ (UIViewController *)topViewController {
    UINavigationController *nav = [self navigationViewController];
    
    return nav.topViewController;
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    @autoreleasepool {
        viewController.hidesBottomBarWhenPushed = YES;
        UINavigationController *navigationViewController = [self navigationViewController];
        if (navigationViewController) {
            [navigationViewController pushViewController:viewController animated:animated];
        } else {
            [self presentViewController:viewController animated:animated completion:nil];
        }
    }
}

+ (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    @autoreleasepool {
        UINavigationController *navigationViewController = [self navigationViewController];
        if (navigationViewController) {
            return [navigationViewController popViewControllerAnimated:animated];
        }
    }
    
    return nil;
}

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    @autoreleasepool {
        UIViewController *topViewController = [self topViewController];
        if (topViewController) {
            [topViewController presentViewController:topViewController animated:animated completion:completion];
        } else {
            UIViewController *presentedViewController = [self presentedViewController];
            if (presentedViewController) {
                [presentedViewController presentViewController:viewController animated:animated completion:completion];
            }
        }
    }
}

+ (void)dismissViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    UINavigationController *navigationViewController = [self navigationViewController];
    if (navigationViewController && viewController.navigationController == navigationViewController) {
        [navigationViewController popViewControllerAnimated:animated];
    } else {
        [viewController dismissViewControllerAnimated:animated completion:completion];
    }
}

@end

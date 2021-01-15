//
//  LKControllerUtil.h
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LKControllerUtil : NSObject

+ (UIViewController *)currentViewController;

+ (UIViewController *)presentedViewController;

+ (UINavigationController *)navigationViewController;

+ (UIViewController *)topViewController;

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (UIViewController *)popViewControllerAnimated:(BOOL)animated;

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

+ (void)dismissViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

@end

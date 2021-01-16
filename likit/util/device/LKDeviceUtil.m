//
//  LKDeviceUtil.m
//  likit
//
//  Created by 李浪 on 2021/1/17.
//

#import "LKDeviceUtil.h"

@implementation LKDeviceUtil

/**
 * 判断是否刘海手机
 */
+ (BOOL)safeArea {
    BOOL safeArea = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return safeArea;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) {
            safeArea = YES;
        }
    }
    return safeArea;
}

/**
 * 读取设备反向
 */
+ (UIInterfaceOrientation)interfaceOrientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

@end

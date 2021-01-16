//
//  LKDeviceUtil.h
//  likit
//
//  Created by 李浪 on 2021/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKDeviceUtil : NSObject

/**
 * 判断是否刘海手机
 */
+ (BOOL)safeArea;

/**
 * 读取设备反向
 */
+ (UIInterfaceOrientation)interfaceOrientation;

@end

NS_ASSUME_NONNULL_END

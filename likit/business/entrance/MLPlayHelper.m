//
//  MLPlayHelper.m
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

#import "MLPlayHelper.h"

#import "DongSDKObject.h"

#import "MLPlayViewController.h"

@implementation MLPlayHelper

/**
 * 打开视频门禁
 *
 *  @param deviceInfo 设备信息 字符串 或 对象
 *  @param intranet 是否局域网
 */
+ (void)openMLPlayWithDeviceInfo:(id)deviceInfo intranet:(BOOL)intranet {
    DeviceInfo *deviceInfoObject = nil;
    if ([deviceInfo isKindOfClass:[DeviceInfo class]]) {
        deviceInfoObject = deviceInfo;
    } else {
        deviceInfoObject = [DeviceInfo modelWithJSON:deviceInfo];
    }
    if (deviceInfoObject) {
        MLPlayViewController *playViewController = [[MLPlayViewController alloc] init];
        playViewController.deviceInfo = deviceInfoObject;
        playViewController.intranet = intranet;
        [LKControllerUtil pushViewController:playViewController animated:YES];
    }
}

@end

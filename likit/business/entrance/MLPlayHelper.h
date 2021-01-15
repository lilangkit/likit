//
//  MLPlayHelper.h
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

#import <Foundation/Foundation.h>

@interface MLPlayHelper : NSObject

/**
 * 打开视频门禁
 *
 *  @param deviceInfo 设备信息 字符串 或 对象
 *  @param intranet 是否局域网
 */
+ (void)openMLPlayWithDeviceInfo:(id)deviceInfo intranet:(BOOL)intranet;

@end

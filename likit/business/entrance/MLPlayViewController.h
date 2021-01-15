//
//  MLPlayViewController.h
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

#import "LKBaseViewController.h"

@class DeviceInfo;

NS_ASSUME_NONNULL_BEGIN

@interface MLPlayViewController : LKBaseViewController

// 设备信息
@property (nonatomic, strong) DeviceInfo *deviceInfo;
// 是否局域网
@property (nonatomic, assign) BOOL intranet;

@end

NS_ASSUME_NONNULL_END

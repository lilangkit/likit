//
//  LKBaseViewController.h
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKBaseViewController : UIViewController

// 是否忽略鉴权 默认：NO
@property (nonatomic, assign) BOOL ignoreAuth;
// 是否忽略自动结束编辑 默认：NO
@property (nonatomic, assign) BOOL ignoreAutoEndEditing;
// 是否忽略点击结束编辑 默认：NO
@property (nonatomic, assign) BOOL ignoreTouchEndEditing;

// 是否监听账户状态变化 默认：NO
//@property (nonatomic, assign) BOOL listenAccountStatus;
// 是否监听账户数据变化 默认：NO
//@property (nonatomic, assign) BOOL listenAccountData;
// 是否监听设备方向变化 默认：NO
//@property (nonatomic, assign) BOOL listenDeviceDirection;

// 线程队列
@property (nonatomic, strong) dispatch_group_t dispatchGroup;
// 网络会话
@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> *sessionDataTasks;

/**
 * 释放线程队列
 */
- (void)releaseDispatchGroup;

/**
 * 初始化
 */
- (void)initialize;

/**
 * 加载自定义视图
 */
- (void)addCustomSubViews;

/**
 * 布局自定义视图
 */
- (void)layoutCustomSubviews;

/**
 * 加载数据
 */
- (void)loadData;

/**
 * 账户状态变化
 */
//- (void);

/**
 * 账户数据变化
 */
//- (void);

/**
 * 设备方向变化
 */
//- (void);

/**
 * 清理
 */
- (void)clean;

@end

NS_ASSUME_NONNULL_END

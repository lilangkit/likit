//
//  LKBaseViewController.m
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

#import "LKBaseViewController.h"

@interface LKBaseViewController ()

@end

@implementation LKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self initialize];
    // 加载自定义视图
    [self addCustomSubViews];
    // 布局自定义视图
    [self layoutCustomSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_ignoreAutoEndEditing) {
        [self.view endEditing:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 清理
    [self clean];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_ignoreTouchEndEditing) {
        [self.view endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 清理
    [self clean];
}

- (void)dealloc {
    // 释放线程队列
    [self releaseDispatchGroup];
    // 移除所有监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"<%@:%p>%@控制器销毁了", NSStringFromClass([self class]), self, (self.title == nil || self.title.length == 0) ? @"未知名": self.title);
}

/**
 * 创建线程队列
 */
- (dispatch_group_t)dispatchGroup {
    if (!_dispatchGroup) {
        _dispatchGroup = dispatch_group_create();
    }
    return _dispatchGroup;
}

/**
 * 释放线程队列
 */
- (void)releaseDispatchGroup {
    if (_dispatchGroup) {
        _dispatchGroup = nil;
    }
}

/**
 * 初始化
 */
- (void)initialize {
    // 设置默认数据
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 * 加载自定义视图
 */
- (void)addCustomSubViews {
    // 加载统一视图
}

/**
 * 布局自定义视图
 */
- (void)layoutCustomSubviews {
    // 布局统一视图
}

/**
 * 清理
 */
- (void)clean {
    // 清理网络会话
    if (_sessionDataTasks) {
        for (NSURLSessionDataTask *sessionDataTask in _sessionDataTasks) {
            [sessionDataTask cancel];
        }
        [_sessionDataTasks removeAllObjects];
    }
}

@end

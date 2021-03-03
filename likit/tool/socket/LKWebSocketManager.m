//
//  LKWebSocketManager.m
//  likit
//
//  Created by 李浪 on 2021/3/3.
//

#import "LKWebSocketManager.h"

@interface LKWebSocketManager ()<SRWebSocketDelegate>

// 心跳定时器
@property (nonatomic, strong) NSTimer *heartBeatTimer;
// 没有网络的时候检测网络定时器
@property (nonatomic, strong) NSTimer *networkTestTimer;
// 重连时间
@property (nonatomic, assign) NSTimeInterval reConnectTime;
// 存储要发送给服务端的数据
//@property (nonatomic, strong) NSMutableArray *sendDataArray;
// 用于判断是否主动关闭长连接，如果是主动断开连接，连接失败的代理中，就不用执行 重新连接方法
@property (nonatomic, assign) BOOL isActivelyClose;

@end

@implementation LKWebSocketManager

+ (instancetype)sharedManager {
    static LKWebSocketManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _reConnectTime = 0;
        _isActivelyClose = NO;
        //        _sendDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 * 建立长连接
 */
- (void)connectServer {
    if (!_urlString) {
        return;
    }
    _isActivelyClose = NO;
    
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:_urlString]];
    _webSocket.delegate = self;
    [_webSocket open];
}

/**
 * 重新连接
 */
- (void)reConnectServer {
    if (_webSocket && _webSocket.readyState == SR_OPEN) {
        return;
    }
    // 重连10次 2^10 = 1024
    if (_reConnectTime > 1024) {
        _reConnectTime = 0;
        return;
    }
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weak_self.webSocket && weak_self.webSocket.readyState == SR_OPEN && weak_self.webSocket.readyState == SR_CONNECTING) {
            return;
        }
        [weak_self connectServer];
        // 重连时间2的指数级增长
        if (weak_self.reConnectTime == 0) {
            weak_self.reConnectTime = 2;
        } else {
            weak_self.reConnectTime *= 2;
        }
    });
}

/**
 * 关闭长连接
 */
- (void)closeServer {
    _isActivelyClose = YES;
    _isConnect = NO;
    _connectType = LKWebSocketDefault;
    if (_webSocket) {
        [_webSocket close];
        _webSocket = nil;
    }
    // 关闭心跳定时器
    [self destoryHeartBeat];
    // 关闭网络检测定时器
    [self destoryNetworkStartTest];
}

/**
 * 发送ping数据
 */
- (void)sendPing:(NSData *)data {
    [_webSocket sendPing:data];
}

/**
 * 发送数据给服务器
 */
- (void)sendDataToServer:(id _Nullable)data {
    //    if (data) {
    //        [_sendDataArray addObject:data];
    //    }
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {// 没有网络
        // 开启网络检测定时器
        [self noNetworkStartTestTimer];
    } else {// 有网络
        if (_webSocket) {
            if (_webSocket.readyState == SR_OPEN) {
                //                if (_sendDataArray.count > 0) {
                //                    data = _sendDataArray[0];
                // 发送数据
                [_webSocket send:data];
                //                    [_sendDataArray removeObjectAtIndex:0];
                //                    if (_sendDataArray.count > 0) {
                //                        [self sendDataToServer:nil];
                //                    }
                //                }
            } else if (_webSocket.readyState == SR_CONNECTING) {// 正在连接
                NSLog(@"[WebSocket]正在连接中，重连后会去自动同步数据");
            } else if (_webSocket.readyState == SR_CLOSING || _webSocket.readyState == SR_CLOSED) {// 断开连接
                // 重连
                [self reConnectServer];
            }
        } else {
            // 连接服务器
            [self connectServer];
        }
    }
}

#pragma mark - SRWebSocketDelegate
/**
 * 连接成功
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"[WebSocket]连接成功");
    _isConnect = YES;
    _connectType = LKWebSocketConnect;
    // 历史消息检测
    //    if (_sendDataArray.count > 0) {
    //        [self sendDataToServer:nil];
    //    }
    // 开始心跳
    [self initHeartBeat];
}

/**
 * 连接失败
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"[WebSocket]连接失败");
    _isConnect = NO;
    _connectType = LKWebSocketDisconnect;
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {// 没有网络
        // 开启网络检测定时器
        [self noNetworkStartTestTimer];
    } else {// 有网络
        // 重连
        [self reConnectServer];
    }
}

/**
 * 关闭连接
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    _isConnect = NO;
    if (_isActivelyClose) {
        _connectType = LKWebSocketDefault;
        return;
    } else {
        _connectType = LKWebSocketDisconnect;
    }
    NSLog(@"[WebSocket]被关闭连接，code:%ld, reason:%@, wasClean:%d", code, reason, wasClean);
    // 销毁心跳
    [self destoryHeartBeat];
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {// 没有网络
        // 开启网络检测
        [self noNetworkStartTestTimer];
    } else {// 有网络
        NSLog(@"[WebSocket]关闭连接");
        _webSocket = nil;
        // 重连
        [self reConnectServer];
    }
}

/**
 * 接受到pong数据
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongData {
    NSLog(@"[WebSocket]接受pong数据==>%@", pongData);
}

/**
 * 接收消息
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"[WebSocket]接收到消息==>%@", message);
    if ([_delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:)]) {
        [_delegate webSocketManagerDidReceiveMessage:message];
    }
}

#pragma mark - 定时器
/**
 * 初始化心跳
 */
- (void)initHeartBeat {
    // 心跳没有被关闭
    if (_heartBeatTimer) {
        return;
    }
    [self destoryHeartBeat];
    @weakify(self);
    dispatch_main_async_safe(^{
        weak_self.heartBeatTimer  = [NSTimer scheduledTimerWithTimeInterval:10 target:weak_self selector:@selector(senderheartBeat) userInfo:nil repeats:true];
        [[NSRunLoop currentRunLoop] addTimer:weak_self.heartBeatTimer forMode:NSRunLoopCommonModes];
    });
}

/**
 * 发送心跳
 */
- (void)senderheartBeat {
    @weakify(self);
    dispatch_main_async_safe(^{
        if (weak_self.webSocket && weak_self.webSocket.readyState == SR_OPEN) {
            [weak_self sendPing:nil];
        }
    });
}

/**
 * 取消心跳
 */
- (void)destoryHeartBeat {
    @weakify(self);
    dispatch_main_async_safe(^{
        if (weak_self.heartBeatTimer) {
            [weak_self.heartBeatTimer invalidate];
            weak_self.heartBeatTimer = nil;
        }
    });
}

/**
 * 网络检测
 */
- (void)noNetworkStartTestTimer {
    @weakify(self);
    dispatch_main_async_safe(^{
        weak_self.networkTestTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weak_self selector:@selector(noNetworkStartTest) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:weak_self.networkTestTimer forMode:NSDefaultRunLoopMode];
    });
}

/**
 * 定时检测网络
 */
- (void)noNetworkStartTest {
    // 有网络
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        // 关闭网络检测定时器
        [self destoryNetworkStartTest];
        // 开始重连
        [self reConnectServer];
    }
}

/**
 * 取消网络检测
 */
- (void)destoryNetworkStartTest {
    @weakify(self);
    dispatch_main_async_safe(^{
        if (weak_self.networkTestTimer) {
            [weak_self.networkTestTimer invalidate];
            weak_self.networkTestTimer = nil;
        }
    });
}

@end

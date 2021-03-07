//
//  LKWebSocketManager.h
//  likit
//
//  Created by 李浪 on 2021/3/3.
//

#import <Foundation/Foundation.h>

#import "SRWebSocket.h"

@class LKWebSocketManager;

typedef NS_ENUM(NSUInteger, LKWebSocketConnectType) {
    LKWebSocketDefault = 0,  //初始状态，未连接
    LKWebSocketConnect,      //已连接
    LKWebSocketDisconnect    //连接后断开
};

@protocol LKWebSocketManagerDelegate <NSObject>

@optional

- (void)webSocketManagerDidReceiveMessage:(id _Nullable)message;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LKWebSocketManager : NSObject

@property (nonatomic, strong) SRWebSocket *_Nullable webSocket;

@property (nonatomic, weak) id<LKWebSocketManagerDelegate> delegate;
// 连接地址
@property (nonatomic, copy) NSString *urlString;
// 是否连接
@property (nonatomic, assign) BOOL isConnect;
// 连接类型
@property (nonatomic, assign) LKWebSocketConnectType connectType;

+ (instancetype)sharedManager;

/**
 * 建立长连接
 */
- (void)connectServer;

/**
 * 重新连接
 */
- (void)reConnectServer;

/**
 * 关闭长连接
 */
- (void)closeServer;

/**
 * 发送数据给服务器
 */
- (void)sendDataToServer:(id _Nullable)data;

@end

NS_ASSUME_NONNULL_END

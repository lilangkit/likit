//
//  LKWebView.h
//  likit
//
//  Created by 李浪 on 2021/3/6.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class LKWebView;

NS_ASSUME_NONNULL_BEGIN

@protocol LKWebViewDelegate <NSObject>

@optional

- (void)webViewDidStartLoad:(LKWebView *)webView;

- (void)webViewDidFinishLoad:(LKWebView *)webView;

- (void)webView:(LKWebView *)webView didFailLoadWithError:(NSError*)error;

- (BOOL)webView:(LKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)webView:(LKWebView *)webView updateProgress:(CGFloat)progress;

- (void)webView:(LKWebView *)webView updateTitle:(NSString *)title;

@end

@interface LKWebView : UIView

@property (nonatomic, weak) id<LKWebViewDelegate> delegate;

// WebView
@property (nonatomic, readonly) WKWebView *webView;

@property (nonatomic, readonly) NSURLRequest *currentRequest;

@property (nonatomic, readonly, copy) NSString *title;

@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) BOOL canGoBack;

@property (nonatomic, readonly) BOOL canGoForward;

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request;

- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

- (nullable WKNavigation *)goBack;

- (nullable WKNavigation *)goForward;

- (nullable WKNavigation *)reload;

- (nullable WKNavigation *)reloadFromOrigin;

- (void)stopLoading;

- (NSInteger)countOfHistory;

- (void)goBackWithStep:(NSInteger)step;

/**
 * 添加网页进行交互方法
 */
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;

/**
 * 添加网页进行交互方法
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name;

/**
 * 执行网页交互事件
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;

- (NSString *)evaluateJavaScript:(NSString*)javaScriptString;

@end

NS_ASSUME_NONNULL_END

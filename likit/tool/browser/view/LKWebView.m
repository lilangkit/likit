//
//  LKWebView.m
//  likit
//
//  Created by 李浪 on 2021/3/6.
//

#import "LKWebView.h"

@interface LKWebView ()<WKNavigationDelegate, WKUIDelegate>

// WebView
@property (nonatomic, strong) WKWebView *webView;
// 估计进度
@property (nonatomic, assign) double estimatedProgress;
// 来源请求
@property (nonatomic, strong) NSURLRequest *originRequest;
// 当前请求
@property (nonatomic, strong) NSURLRequest *currentRequest;
// 标题
@property (nonatomic, copy) NSString *title;

@end

@implementation LKWebView

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化
        [self initialize];
        // 加载自定义视图
        [self addCustomSubViews];
        // 布局自定义视图
        [self layoutCustomSubviews];
    }
    return self;
}

/**
 * 初始化
 */
- (void)initialize {

}

/**
 * 加载自定义视图
 */
- (void)addCustomSubViews {
    // webView
    [self addSubview:self.webView];
}

/**
 * 布局自定义视图
 */
- (void)layoutCustomSubviews {
    // webView
    [self.webView setFrame:self.bounds];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

/**
 * webView
 */
- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.allowsAirPlayForMediaPlayback = YES;
        configuration.allowsPictureInPictureMediaPlayback = YES;
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        configuration.userContentController = userContentController;
        
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        if (@available(iOS 13.0, *)) {
            WKWebpagePreferences *webpagePreferences = [[WKWebpagePreferences alloc] init];
            configuration.defaultWebpagePreferences = webpagePreferences;
        }
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        for (UIView *subview in _webView.scrollView.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                subview.hidden = YES;
                subview.backgroundColor = [UIColor clearColor];
                ((UIImageView *)subview).image = nil;
            }
        }
        
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

/**
 * KVO
 */
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        if ([self.delegate respondsToSelector:@selector(webView:updateProgress:)]) {
            [self.delegate webView:self updateProgress:self.estimatedProgress];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = change[NSKeyValueChangeNewKey];
        if ([self.delegate respondsToSelector:@selector(webView:updateTitle:)]) {
            [self.delegate webView:self updateTitle:self.title];
        }
    } else {
        [self willChangeValueForKey:keyPath];
        [self didChangeValueForKey:keyPath];
    }
}

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request {
    self.originRequest = request;
    self.currentRequest = request;
    
    return [self.webView loadRequest:request];
}

- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL {
    
    return [self.webView loadHTMLString:string baseURL:baseURL];
}

- (NSURLRequest *)currentRequest {
    return _currentRequest;
}

- (NSURL *)URL {
    return self.webView.URL;
}

- (BOOL)isLoading {
    return self.webView.isLoading;
}

- (BOOL)canGoBack {
    return self.webView.canGoBack;
}

- (BOOL)canGoForward {
    return self.webView.canGoForward;
}

- (nullable WKNavigation *)goBack {
    return [self.webView goBack];
}

- (nullable WKNavigation *)goForward {
    return [self.webView goForward];
}

- (nullable WKNavigation *)reload {
    return [self.webView reload];
}

- (nullable WKNavigation *)reloadFromOrigin {
    return [self.webView reloadFromOrigin];
}

- (void)stopLoading {
    [self.webView stopLoading];
}

- (NSInteger)countOfHistory {
    return self.webView.backForwardList.backList.count;
}

- (void)goBackWithStep:(NSInteger)step {
    if (self.canGoBack == NO) {
        return;
    }
    
    if (step > 0) {
        NSInteger historyCount = self.countOfHistory;
        if (step >= historyCount) {
            step = historyCount - 1;
        }
        WKBackForwardListItem *backItem = self.webView.backForwardList.backList[step];
        [self.webView goToBackForwardListItem:backItem];
    } else {
        [self goBack];
    }
}

/**
 * 添加网页进行交互方法
 */
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name {
    [self removeScriptMessageHandlerForName:name];
    WKWebViewConfiguration *configuration = self.webView.configuration;
    WKUserContentController *userContentController = configuration.userContentController;
    [userContentController addScriptMessageHandler:scriptMessageHandler name:name];
}

/**
 * 添加网页进行交互方法
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name {
    WKWebViewConfiguration *configuration = self.webView.configuration;
    WKUserContentController *userContentController = configuration.userContentController;
    [userContentController removeScriptMessageHandlerForName:name];
}

/**
 * 执行网页交互事件
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler {
    [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

- (NSString *)evaluateJavaScript:(NSString*)javaScriptString {
    __block NSString *result = nil;
    __block BOOL isExecuted = NO;
    [self.webView evaluateJavaScript:javaScriptString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        result = obj;
        isExecuted = YES;
    }];
    
    while (isExecuted == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return result;
}

#pragma mark - 私有方法
// 判断当前加载的URL是否是WKWebView不能打开的协议类型
- (BOOL)isLoadingWKWebViewDisableScheme:(NSURL*)URL {
    BOOL isLoadingDisableScheme = NO;
    // 判断是否正在加载WKWebview不能识别的协议类型：phone numbers, email address, maps, etc.
    NSString *scheme = URL.scheme;
    if ([scheme isEqualToString:@"tel"] || [scheme isEqualToString:@"mailto"]) {
        UIApplication *application = [UIApplication sharedApplication];
        if ([application canOpenURL:URL]) {
            [application openURL:URL options:[[NSDictionary alloc] init] completionHandler:nil];
            isLoadingDisableScheme = YES;
        }
    }
    return isLoadingDisableScheme;
}

- (void)callbackWebViewDidFinishLoad {
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
}

- (void)callbackWebViewDidStartLoad {
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}

- (void)callbackWebViewDidFailLoadWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

- (BOOL)callbackWebViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType {
    BOOL resultBOOL = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        if (navigationType == -1) {
            navigationType = UIWebViewNavigationTypeOther;
        }
        resultBOOL = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return resultBOOL;
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message == nil ? @"" : message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message == nil ? @"" : message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields[0];
        NSString *text = textField.text;
        completionHandler(text == nil ? @"" : text);
    }])];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    NSURL *URL = request.URL;
    WKNavigationType navigationType = navigationAction.navigationType;
    
    BOOL resultBOOL = [self callbackWebViewShouldStartLoadWithRequest:request navigationType:navigationType];
    BOOL isLoadingDisableScheme = [self isLoadingWKWebViewDisableScheme:URL];
    
    if (resultBOOL && !isLoadingDisableScheme) {
        self.currentRequest = request;
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self callbackWebViewDidStartLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self callbackWebViewDidFinishLoad];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self callbackWebViewDidFailLoadWithError:error];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self callbackWebViewDidFailLoadWithError:error];
}

#pragma mark - 清理
- (void)dealloc {
    WKWebView *webView = _webView;
    webView.UIDelegate = nil;
    webView.navigationDelegate = nil;
    webView.scrollView.delegate = nil;
    
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [webView removeObserver:self forKeyPath:@"title"];
    [webView stopLoading];
    [webView loadHTMLString:@"" baseURL:nil];
    [webView stopLoading];
    [webView removeFromSuperview];
    _webView = nil;
    
    [self cleanCacheAndCookie];
}

- (void)cleanCacheAndCookie {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in storage.cookies) {
        [storage deleteCookie:cookie];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

@end

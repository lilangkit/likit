//
//  MLPlayViewController.m
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

#import "MLPlayViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "DongSDKObject.h"
#import "ServiceControlCenter.h"
#import "ServerLanSearchControl.h"

// 多媒体类型
typedef NS_ENUM(NSInteger, MLMultimediaType) {
    MLMultimediaTypeAudio = 1,
    MLMultimediaTypeVideo = 2,
    MLMultimediaTypeIntercom = 4,
};

@interface MLPlayViewController ()<DPlayManagerDelegate>

// 画面显示视图
@property (nonatomic, strong) UIImageView *playImageView;
// 音频控制按钮
@property (nonatomic, strong) UIButton *audioButton;
// 视频控制按钮
@property (nonatomic, strong) UIButton *videoButton;
// 对讲控制按钮
@property (nonatomic, strong) UIButton *intercomButton;
// 门禁控制按钮
@property (nonatomic, strong) UIButton *entranceButton;

@end

@implementation MLPlayViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 停止音频
    [self realtimeStop:MLMultimediaTypeAudio];
    // 停止视频
    [self realtimeStop:MLMultimediaTypeVideo];
    // 停止对讲
    [self realtimeStop:MLMultimediaTypeIntercom];
    // 释放控制器
    [self destoryPlayView];
}

/**
 * 初始化
 */
- (void)initialize {
    [super initialize];
    // 设置标题
    self.title = @"视频开锁";
    // 默认扬声器模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    // 设置代理
    [self initPlayViewWithDelegate:self];
    // 选择当前设备
    [self selectDeviceInfo:_deviceInfo viewType:ViewTypeRealtime];
}

/**
 * 加载自定义视图
 */
- (void)addCustomSubViews {
    [super addCustomSubViews];
    // 画面显示视图
    [self.view addSubview:self.playImageView];
    // 音频控制按钮
    [self.view addSubview:self.audioButton];
    // 视频控制按钮
    [self.view addSubview:self.videoButton];
    // 对讲控制按钮
    [self.view addSubview:self.intercomButton];
    // 门禁控制按钮
    [self.view addSubview:self.entranceButton];
    
    // 退出按钮
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    @weakify(self);
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = weak_self.view;
        make.left.mas_equalTo(superView.mas_left).offset(20);
        make.top.mas_equalTo(weak_self.audioButton.mas_bottom).offset(40);
        make.width.height.mas_equalTo(80);
    }];
}

/**
 * 画面显示视图
 */
- (UIImageView *)playImageView {
    if (_playImageView == nil) {
        _playImageView = [[UIImageView alloc] init];
        _playImageView.contentMode = UIViewContentModeScaleAspectFit;
        _playImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _playImageView;
}

/**
 * 音频控制按钮
 */
- (UIButton *)audioButton {
    if (_audioButton == nil) {
        _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioButton setImage:[UIImage imageNamed:@"entrance_audio_open"] forState:UIControlStateNormal];
        [_audioButton setImage:[UIImage imageNamed:@"entrance_audio_open"] forState:UIControlStateHighlighted];
        [_audioButton setImage:[UIImage imageNamed:@"entrance_audio_close"] forState:UIControlStateSelected];
        [_audioButton setImage:[UIImage imageNamed:@"entrance_audio_close"] forState:UIControlStateSelected | UIControlStateSelected];
        [_audioButton addTarget:self action:@selector(audioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioButton;
}

/**
 * 视频控制按钮
 */
- (UIButton *)videoButton {
    if (_videoButton == nil) {
        _videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoButton setImage:[UIImage imageNamed:@"entrance_video_open"] forState:UIControlStateNormal];
        [_videoButton setImage:[UIImage imageNamed:@"entrance_video_open"] forState:UIControlStateHighlighted];
        [_videoButton setImage:[UIImage imageNamed:@"entrance_video_close"] forState:UIControlStateSelected];
        [_videoButton setImage:[UIImage imageNamed:@"entrance_video_close"] forState:UIControlStateSelected | UIControlStateSelected];
        [_videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoButton;
}

/**
 * 对讲控制按钮
 */
- (UIButton *)intercomButton {
    if (_intercomButton == nil) {
        _intercomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_intercomButton setImage:[UIImage imageNamed:@"intercom_answer"] forState:UIControlStateNormal];
        [_intercomButton setImage:[UIImage imageNamed:@"intercom_answer"] forState:UIControlStateHighlighted];
        [_intercomButton setImage:[UIImage imageNamed:@"intercom_hangup"] forState:UIControlStateSelected];
        [_intercomButton setImage:[UIImage imageNamed:@"intercom_hangup"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_intercomButton addTarget:self action:@selector(intercomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _intercomButton;
}

/**
 * 门禁控制按钮
 */
- (UIButton *)entranceButton {
    if (_entranceButton == nil) {
        _entranceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_entranceButton setImage:[UIImage imageNamed:@"entrance_door_open"] forState:UIControlStateNormal];
        [_entranceButton setImage:[UIImage imageNamed:@"entrance_door_open"] forState:UIControlStateHighlighted];
        [_entranceButton addTarget:self action:@selector(entranceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _entranceButton;
}

/**
 * 布局自定义视图
 */
- (void)layoutCustomSubviews {
    [super layoutCustomSubviews];
    @weakify(self);
    // 画面显示视图
    [_playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = weak_self.view;
        make.left.mas_equalTo(superView.mas_left);
        make.top.mas_equalTo(superView.mas_top).offset(weak_self.navigationController ? 0 : 44);
        make.right.mas_equalTo(superView.mas_right);
        make.height.mas_equalTo(superView.mas_height).multipliedBy(0.5);
    }];
    // 音频控制按钮
    [_audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = weak_self.view;
        make.left.mas_equalTo(superView.mas_left).offset(20);
        make.top.mas_equalTo(weak_self.playImageView.mas_bottom).offset(40);
        make.width.height.mas_equalTo(80);
        
    }];
    // 视频控制按钮
    [_videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = weak_self.view;
        make.top.mas_equalTo(weak_self.audioButton.mas_top);
        make.centerX.mas_equalTo(superView.mas_centerX);
        make.width.height.mas_equalTo(weak_self.audioButton);
    }];
    // 对讲控制按钮
    [_intercomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = weak_self.view;
        make.right.mas_equalTo(superView.mas_right).offset(-20);
        make.top.mas_equalTo(weak_self.audioButton.mas_top);
        make.width.height.mas_equalTo(weak_self.audioButton);
    }];
    // 门禁控制按钮
    [_entranceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = weak_self.view;
        make.top.mas_equalTo(weak_self.audioButton.mas_bottom).offset(40);
        make.centerX.mas_equalTo(superView.mas_centerX);
        make.width.height.mas_equalTo(weak_self.audioButton);
    }];
}

#pragma mark - 私有方法
/**
 * 设置代理
 */
- (void)initPlayViewWithDelegate:(id<DPlayManagerDelegate>)delegate {
    if (_intranet) {
        [[LanSearchControlCenter sharedInstance] initPlayViewWithDelegate:delegate];
    } else {
        [[UserControlCenter sharedInstance] initPlayViewWithDelegate:delegate];
    }
}

/**
 * 释放控制器
 */
- (void)destoryPlayView {
    if (_intranet) {
        [[LanSearchControlCenter sharedInstance] destoryPlayView];
    } else {
        [[UserControlCenter sharedInstance] destoryPlayView];
    }
}

/**
 * 选择当前设备
 */
- (int)selectDeviceInfo:(DeviceInfo *)devInfo viewType:(ViewType)type {
    if (_intranet) {
        return [[LanSearchControlCenter sharedInstance] selectDeviceInfo:devInfo viewType:type];
    } else {
        return [[UserControlCenter sharedInstance] selectDeviceInfo:devInfo viewType:type];
    }
}

/**
 * 实时播放
 */
- (int)realtimePlay:(int)type {
    if (_intranet) {
        return [[LanSearchControlCenter sharedInstance] realtimePlay:type];
    } else {
        return [[UserControlCenter sharedInstance] realtimePlay:type];
    }
}

/**
 * 停止播放
 */
- (int)realtimeStop:(int)type {
    if (_intranet) {
        return [[LanSearchControlCenter sharedInstance] realtimeStop:type];
    } else {
        return [[UserControlCenter sharedInstance] realtimeStop:type];
    }
}

#pragma mark - 私有控制方法
/**
 * 音频播放翻转
 */
- (void)audioButtonAction:(UIButton *)button {
    if (button.selected) {
        [self realtimeStop:MLMultimediaTypeAudio];
    } else {
        [self realtimePlay:MLMultimediaTypeAudio];
    }
    button.selected = !button.selected;
}

/**
 * 视频播放翻转
 */
- (void)videoButtonAction:(UIButton *)button {
    if (button.selected) {
        [self realtimeStop:MLMultimediaTypeVideo];
    } else {
        [self realtimePlay:MLMultimediaTypeVideo];
    }
    button.selected = !button.selected;
}

/**
 * 对讲翻转
 */
- (void)intercomButtonAction:(UIButton *)button {
    // 检查麦克风权限
    // TODO
    // 自动打开音频
    if (!_audioButton.selected) {
        [self audioButtonAction:_audioButton];
    }
    if (button.selected) {
        [self realtimeStop:MLMultimediaTypeIntercom];
    } else {
        [self realtimePlay:MLMultimediaTypeIntercom];
    }
    button.selected = !button.selected;
}

/**
 * 门禁控制
 */
- (void)entranceButtonAction:(UIButton *)button {
    if (_intranet) {
        [[LanSearchControlCenter sharedInstance] doControl];
    } else {
        [[UserControlCenter sharedInstance] doControl];
    }
}

#pragma mark DPlayManagerDelegate
/**
 * 连接成功
 */
- (void)dPlayManager:(DPlayManager *)dPlayManager dongDeviceID:(int)dDeviceID connect:(ChannelType)type {
    
}

/**
 * 认证成功
 */
- (void)dPlayManager:(DPlayManager *)dPlayManager dongDeviceID:(int)dDeviceID authenticate:(ChannelType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 播放音频
        if (!_audioButton.selected) {
            [self audioButtonAction:_audioButton];
        }
        // 播放视频
        if (!_videoButton.selected) {
            [self videoButtonAction:_videoButton];
        }
    });
}

/**
 * 播放错误回应
 */
- (void)dPlayManager:(DPlayManager *)dPlayManager dongDeviceID:(int)dDeviceID playError:(int)errNo userName:(NSString *)userName  {
    [self dealErrorMegplayError:errNo];
}

/**
 * 播放中解锁设备回应
 */
- (void)dPlayManager:(DPlayManager *)dPlayManager dongDeviceID:(int)dDeviceID onOpenDo:(int)reason {
    
}

/**
 * 视频解码后数据
 */
- (void)dPlayManager:(DPlayManager *)dPlayManager dongDeviceID:(int)dDeviceID videoDataImage:(UIImage *)image {
    // 显示到视图
    [_playImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
}

/**
 * 处理异常事件
 * 1.没有播放权限
 * 2.对方已挂断
 * 3.设备占线，无法播放
 * 4.音频播放已被其他用户占用
 * 5.音频当前正常播放
 */
- (void)dealErrorMegplayError:(int)errNo {
    if (errNo == 5) return;
    // 退出控制器
    [self exit];
}

/**
 * 退出控制器
 */
- (void)exit {
    [LKControllerUtil dismissViewController:self animated:YES completion:^{
        
    }];
}

@end

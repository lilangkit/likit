target 'likit' do
  platform :ios, '10.0'
  inhibit_all_warnings!
  
  pod 'YYKit', '~> 1.0.9'
  pod 'Masonry', '~> 1.1.0'
  pod 'AFNetworking', '~> 4.0.1'
  pod 'SDWebImage', '~> 5.10.2'
  pod 'BoringSSL', '~> 10.0.6'
  pod 'IQKeyboardManager', '~> 6.5.6'
  pod 'SocketRocket', '~> 0.5.1'
  pod 'MJRefresh', '~> 3.5.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 10.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
  end
end

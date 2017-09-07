# Uncomment this line to define a global platform for your project


source 'https://github.com/CocoaPods/Specs.git'


# platform :ios, '9.0'

target 'LDAContactApp' do
  
pod 'React', :path => '../js/node_modules/react-native', :subspecs => [
  'Core',
  'RCTImage',
  'RCTNetwork',
  'RCTText',
  'RCTWebSocket',
]

pod 'Firebase'
pod 'Firebase/Database'
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'Google-Mobile-Ads-SDK'


pod 'Whisper'
pod 'AKPickerView-Swift'


pod 'SDWebImage', '~>3.8'
pod 'Eureka', '~> 2.0.0-beta.1'
pod 'Simplicity'

pod 'ILLoginKit'

pod 'TKSubmitTransition'

pod 'FDTake'

  # Pods for URLEmbeddedViewSample
  pod "URLEmbeddedView"

# Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LDAContactApp

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end






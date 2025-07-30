# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'PokemonCodeid' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PokemonCodeid
  pod 'Alamofire'
  pod 'Kingfisher', '~> 8.0'
  pod 'RxSwift', '~> 6.9.0'
  pod 'RxCocoa', '~> 6.9.0'
  pod 'MBProgressHUD'
  pod 'XLPagerTabStrip', '~> 9.0'
  pod 'RealmSwift', '~> 10.44.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end

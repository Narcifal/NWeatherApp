# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NWeatherApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'GoogleMaps'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'GoogleSignIn', '5.0.2'

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
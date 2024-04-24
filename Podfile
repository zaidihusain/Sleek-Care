# Uncomment the next line to define a global platform for your project

platform :ios, '15.6'

target 'SleekCare' do
  use_frameworks!
  pod 'GoogleMLKit/DigitalInkRecognition', '~> 3.2.0'
#
  pod 'FirebaseAuth'

  # Pods for SleekCare

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end


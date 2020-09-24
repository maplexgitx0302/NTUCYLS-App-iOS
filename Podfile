# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end

target 'ntucylsapp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ntucylsapp

  target 'ntucylsappTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ntucylsappUITests' do
    # Pods for testing
  end

  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'

end

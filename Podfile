platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!
workspace 'Nouter'

def utilPods 
  pod 'R.swift'
  pod 'SwiftKeychainWrapper'
  pod 'SwiftLint'
end

def uiPods 
  pod "VisualEffectView"
end

def networkPods
  pod "Alamofire"
end

def dataBase
  pod 'RealmSwift'
end

def firebase 
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
end


target 'Nouter' do
  utilPods
  networkPods
  uiPods
  dataBase
  firebase
  pod 'YandexMobileMetrica'
end

target 'NouterWidgetExtension' do
  dataBase
end

target 'NouterIntentUI' do
  dataBase
end


post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
  end
end

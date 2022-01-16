# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxGesture'
end
def ui
  pod 'MBProgressHUD'
  pod 'SnapKit'
end

def testing
  pod 'Quick'
  pod 'Nimble'
end

def network
  pod 'Alamofire'
  pod 'Kingfisher', '~> 7.0'
end

def mapping
  pod 'ObjectMapper'
end

target '42Race' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for 42Race
rx
network
mapping
ui

end

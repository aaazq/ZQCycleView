#
# Be sure to run `pod lib lint ZQCycleView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZQCycleView'
  s.version          = '0.1.0'
  s.summary          = '椭圆形的轮播图'

  s.description      = '封装了轮播图和view的分类,将传入的图片url动态展示，可一行代码初始化并使用，设置代理可以回调点击事件'

  s.homepage         = 'https://github.com/aaazq/ZQCycleView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '13525505765@163.com' => '13525505765@163.com' }
  s.source           = { :git => 'https://github.com/aaazq/ZQCycleView.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZQCycleView/Classes/**/*'
  
  s.resource_bundles = {
    'ZQCycleView' => ['ZQCycleView/Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'SDWebImage'
end

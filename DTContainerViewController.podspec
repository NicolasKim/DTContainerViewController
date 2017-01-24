Pod::Spec.new do |s|
  s.name             = 'DTContainerViewController'
  s.version          = '1.0.1'
  s.summary          = '一个pure容器控制器'
  s.description      = <<-DESC
    使用了系统的转场方式，支持手势滑动，索引选择。
                       DESC
  s.homepage         = 'https://github.com/NicolasKim'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DreamTracer' => 'jinqiucheng1006@live.cn' }
  s.source           = { :git => 'https://github.com/NicolasKim/DTContainerViewController.git', :tag => s.version }
  s.ios.deployment_target = '7.0'
  s.source_files = 'DTContainerViewController/Classes/**/*'
  s.public_header_files = 'DTContainerViewController/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.header_dir = 'DTFamily'
end

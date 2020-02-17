Pod::Spec.new do |s|
  s.name             = 'ADCoordinator'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ADCoordinator.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/faberNovel/Coordinator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pierre Felgines' => 'pierre.felgines@fabernovel.com' }
  s.source           = { :git => 'https://github.com/faberNovel/Coordinator.git', :tag => "v#{s.version}" }
  s.social_media_url = 'https://twitter.com/fabernovel'
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.framework    = 'Foundation', 'UIKit'
  s.swift_version = '5.1'
  s.source_files = 'ADCoordinator/Classes/**/*'
end

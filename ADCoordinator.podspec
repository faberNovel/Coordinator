Pod::Spec.new do |s|
  s.name             = 'ADCoordinator'
  s.version          = '1.1.0'
  s.summary          = 'An implementation of the coordinator pattern used at Fabernovel.'
  s.description      = <<-DESC
Coordinators are a powerful pattern to decouple the navigation from the view controllers in an app.
This library provides a base class `Coordinator` and a mecanism to retain and release coordinators easily.
                       DESC
  s.homepage         = 'https://github.com/faberNovel/Coordinator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pierre Felgines' => 'pierre.felgines@fabernovel.com' }
  s.source           = { :git => 'https://github.com/faberNovel/Coordinator.git', :tag => "v#{s.version}" }
  s.social_media_url = 'https://twitter.com/fabernovel'
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  s.framework    = 'Foundation', 'UIKit'
  s.swift_version = '5.7'
  s.source_files = 'ADCoordinator/Classes/**/*'
end

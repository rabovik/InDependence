Pod::Spec.new do |s|
  s.name         = "RS_InDependence"
  s.version      = "0.0.2"
  s.summary      = "A Dependency Injection (DI) framework for iOS written in Objective-C"
  s.homepage     = "https://github.com/rabovik/InDependence"
  s.license      = 'MIT'
  s.author       = { "Yan Rabovik" => "yan@rabovik.ru" }
  s.source       = { :git => "https://github.com/rabovik/InDependence.git", :commit => "06bfc3e20738bb877948ea3b3602d8aef911022c" }
  s.platform     = :ios, '5.0'
  s.source_files = 'InDependence', 'InDependence/**/*.{h,m}', 'ExperimentalExtensions'
  s.public_header_files = 'InDependence/InDependence.h', 'InDependence/Core/*.h', 'InDependence/Core/**/*.h', 'InDependence/Extensions/*.h', 'InDependence/Extensions/**/*.h', 'ExperimentalExtensions/*.h'
  s.frameworks = 'Foundation'
  s.requires_arc = true
  s.xcconfig = { 'CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS' => 'YES' }
end

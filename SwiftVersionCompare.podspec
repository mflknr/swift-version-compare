Pod::Spec.new do |s|
  s.name = 'SwiftVersionCompare'
  s.version = '1.0.4'
  s.summary = 'Create and compare semantic versions in swift.'
  s.homepage = 'https://github.com/mflknr/SwiftVersionCompare'
  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author = 'mflknr'
  s.documentation_url = 'https://mflknr.github.io/SwiftVersionCompare/'
  s.source = { :git => 'https://github.com/mflknr/SwiftVersionCompare.git', :tag => s.version.to_s }
  s.source_files = 'Sources/SwiftVersionCompare/**/*'

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.watchos.deployment_target = '7.0'
  s.tvos.deployment_target = '13.0'

  s.swift_version = '5.0'

  s.cocoapods_version = '>= 0.36'
end

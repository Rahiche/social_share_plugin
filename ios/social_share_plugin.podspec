#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint social_share_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'social_share_plugin'
  s.version          = '0.4.1'
  s.summary          = 'Social Share to Twitter Flutter plugin.'
  s.description      = <<-DESC
Social Share to Twitter Flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/romatroskin/social_share_plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'

  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

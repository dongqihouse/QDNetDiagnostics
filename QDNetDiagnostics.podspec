#
# Be sure to run `pod lib lint QDNetDiagnostics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QDNetDiagnostics'
  s.version          = '0.1.0'
  s.summary          = 'Net Diagnostics'


  s.description      = 'Net Diagnostics'

  s.homepage         = 'https://github.com/dongqihouse/QDNetDiagnostics'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qd' => '244514311@qq.com' }
  s.source           = { :git => 'https://github.com/dongqihouse/QDNetDiagnostics.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'QDNetDiagnostics/Classes/**/*'
  
  # s.resource_bundles = {
  #   'QDNetDiagnostics' => ['QDNetDiagnostics/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreTelephony'
  s.library = 'resolv'
  # s.dependency 'AFNetworking', '~> 2.3'
end

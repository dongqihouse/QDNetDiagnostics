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
  s.summary          = '网络测试小工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '网络测试小工具'

  s.homepage         = 'https://github.com/dongqihouse/QDNetDiagnostics'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qd' => '244514311@qq.com' }
  s.source           = { :git => 'https://github.com/dongqihouseQDNetDiagnostics.git', :tag => s.version.to_s }
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

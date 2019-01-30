#
# Be sure to run `pod lib lint JNSession.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JNSession'
  s.version          = '0.3.3'
  s.swift_version    = '4.2'
  s.summary          = 'Simplify URLSession.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
JNSession is a class that simplify URLSession built in ios which create http requests.
                       DESC

  s.homepage         = 'https://github.com/gemgemo/JNSession'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jamal' => 'gamalal3yk@gmail.com' }
  s.source           = { :git => 'https://github.com/gemgemo/JNSession.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/@jamalelayeq'

  s.ios.deployment_target = '11.0'

  s.source_files = 'JNSession/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JNSession' => ['JNSession/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

#
# Be sure to run `pod lib lint MSRichLinkPreview.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MSRichLinkPreview'
  s.version          = '0.1.1'
  s.summary          = 'MSRichLinkPreview will retrieve metadata from the website.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'MSRichLinkPreview will retrieve metadata from the website.'
                       DESC

  s.homepage         = 'https://github.com/Mayur312/MSRichLinkPreview'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mayur312' => 'mayurshirsale0312@gmail.com' }
  s.source           = { :git => 'https://github.com/Mayur312/MSRichLinkPreview.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mayur0312'

  s.ios.deployment_target = '12.1'

  s.swift_version = '5.0'
  s.platforms = {
      "ios": "12.1"
  }
  s.source_files = 'Source/**/*'
  
  # s.resource_bundles = {
  #   'MSRichLinkPreview' => ['MSRichLinkPreview/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Kanna', '5.2.4'
end

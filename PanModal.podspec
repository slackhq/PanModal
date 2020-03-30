#
# Be sure to run `pod lib lint PanModal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PanModal'
  s.version          = '1.2.7'
  s.summary          = 'PanModal is an elegant and highly customizable presentation API for constructing bottom sheet modals on iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'PanModal is an elegant and highly customizable presentation API for constructing bottom sheet modals on iOS.'
  s.homepage         = 'https://github.com/slackhq/PanModal'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'slack' => 'opensource@slack.com' }
  s.source           = { :git => 'https://github.com/slackhq/PanModal.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/slackhq'
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'PanModal/**/*.{swift,h,m}'
end

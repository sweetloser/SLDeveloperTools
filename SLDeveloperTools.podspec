#
# Be sure to run `pod lib lint SLDeveloperTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SLDeveloperTools'
  s.version          = '0.1.3'
  s.summary          = 'A short description of SLDeveloperTools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sweetloser/SLDeveloperTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sweetloser' => '18272160172@163.com' }
  s.source           = { :git => 'https://github.com/sweetloser/SLDeveloperTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SLDeveloperTools/Classes/SLDeveloperTools.h'
  s.public_header_files = 'SLDeveloperTools/Classes/SLDeveloperTools.h'

  s.subspec 'SLCategory' do |category|
      category.source_files = 'SLDeveloperTools/Classes/SLCategory/*.{h,m}'
      category.public_header_files = 'SLDeveloperTools/Classes/SLCategory/*.h'
      category.dependency 'MJRefresh'
  end

  s.subspec 'SLUtilities' do |utils|
      utils.source_files = 'SLDeveloperTools/Classes/SLUtilities/*.{h,m}'
      utils.public_header_files = 'SLDeveloperTools/Classes/SLUtilities/*.h'
  end

  s.subspec 'SLWidget' do |widget|
      widget.source_files = 'SLDeveloperTools/Classes/SLWidget/*.{h,m}'
      widget.public_header_files = 'SLDeveloperTools/Classes/SLWidget/*.h'
      widget.dependency 'Masonry'
      widget.dependency 'SLDeveloperTools/SLCategory'
      widget.dependency 'MJRefresh'
  end

  s.resource     = 'SLDeveloperTools/SLDeveloperTools.bundle'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MMKV'
end

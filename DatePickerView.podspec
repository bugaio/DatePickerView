#
# Be sure to run `pod lib lint DatePickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DatePickerView'
  s.version          = '1.0.0'
  s.summary          = '一款简单配置的时间选择器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '是一款提供多种类型时间选择器, 简单配置,容易上手'

  s.homepage         = 'https://github.com/bugaio'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '骑猪o0o找牛' => 'wyj317005934@163.com' }
  s.source           = { :git => 'https://github.com/bugaio/DatePickerView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DatePickerView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DatePickerView' => ['DatePickerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  end

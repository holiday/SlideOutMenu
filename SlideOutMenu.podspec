#
# Be sure to run `pod lib lint SlideOutMenu.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SlideOutMenu"
  s.version          = "1.0.0"
  s.summary          = "Slide out menu for iOS"
  s.description      = <<-DESC
                          Customizable slide out menu for iOS. Since it relies on UIViews and 
                          uses view containment, this library is very versatile in terms of 
                          customizabiliy and configuration. 
                        DESC
  s.homepage     = "https://github.com/holiday/SlideOutMenu"
  s.license          = 'MIT'
  s.author           = { "rashaad ramdeen" => "rashaad.ramdeen@gmail.com" }
  s.source           = { :git => "https://github.com/holiday/SlideOutMenu.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/1337holiday'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'SlideOutMenu' => ['Pod/Assets/*.png']
  }
end

Pod::Spec.new do |s|

  s.name         = "VirtualView"
  s.version      = "1.2.7"
  s.summary      = "A solution to create & release UI component dynamically."
  s.homepage     = "https://github.com/alibaba/VirtualView-iOS"
  s.license      = { :type => 'MIT' }
  s.author       = { "HarrisonXi" => "gpra8764@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source       =  { :git => "https://github.com/alibaba/VirtualView-iOS.git", :tag => '1.2.7' }
  s.source_files = 'VirtualView/**/*.{h,m}' 
  s.prefix_header_contents = '#import "VVDefines.h"'

  s.dependency 'SDWebImage', '~> 4.2'

end

Pod::Spec.new do |s|
  s.name         = "NZQBaseKit"
  s.version      = "0.0.3"
  s.summary      = "NZQ iOS开发基础常用框架"


  s.description  = <<-DESC
  基础框架
                   DESC


  s.homepage     = "https://github.com/pasmall/NZQBaseKit"


  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Lyric" => "851443090@qq.com" }

  
  s.ios.deployment_target = "10.3"
  s.swift_version = "4.1"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  #  s.source       = { :git => "http://EXAMPLE/NZQBaseKit.git", :tag => "#{s.version}" }
  s.source           = { :git => 'https://github.com/pasmall/NZQBaseKit.git', :branch => 'master' }

  #  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.source_files = 'NZQBaseKit/Classes/**/*'

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"



  s.frameworks    = 'UIKit'
  s.dependency 'MJRefresh'
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
  s.dependency 'AlamofireImage'
  s.dependency 'SnapKit'
  s.dependency 'Hero'
  s.dependency 'CollectionKit'
  s.dependency 'ESTabBarController-swift'
  


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  

end

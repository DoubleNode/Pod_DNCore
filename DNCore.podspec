Pod::Spec.new do |s|

  s.name         = "DNCore"
  s.version      = "0.0.14"
  s.summary      = "A base collection of DNCore headers and utilities."

  s.description  = <<-DESC
                    A base collection of DNCore headers and utilities used as the base for numerous Workers.
                   DESC

  s.homepage     = "https://github.com/DoubleNode/Pod_DNCore"
  s.license      = { :type => "PRIVATE", :file => "README.md" }

  s.author             = { "Darren Ehlers" => "me@darrenehlers.com" }
  s.social_media_url   = "http://twitter.com/ehlersd"

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/DoubleNode/Pod_DNCore.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{h,m,swift}"
  s.exclude_files = "Classes/Exclude"

  s.public_header_files = "Classes/**/*.h"

s.requires_arc = true

  s.dependency "AFNetworking", "~> 3.0"
  s.dependency "ColorUtils"
  s.dependency "NSLogger"
  s.dependency "SDVersion"

end

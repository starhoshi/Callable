Pod::Spec.new do |s|
  s.name               = "Callable"
  s.version            = "0.5.1"
  s.summary            = "Type-safe Firebase HTTPS Callable Functions client using Decodable"
  s.homepage           = "https://github.com/starhoshi/Callable"
  s.license            = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "star__hoshi" => "kensuke1751@gmail.com" }
  s.social_media_url   = "https://twitter.com/star__hoshi"
  s.platform           = :ios, "10.0"
  s.source             = { :git => "https://github.com/starhoshi/Callable.git", :tag => "#{s.version}" }
  s.source_files       = "Callable/**/*.swift"
  s.requires_arc       = true
  s.static_framework   = true

  s.dependency "Firebase/Functions"
  s.dependency "Result"
end

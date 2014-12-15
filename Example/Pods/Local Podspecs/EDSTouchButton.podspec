Pod::Spec.new do |s|
  s.name             = "EDSTouchButton"
  s.version          = "0.0.1"
  s.summary          = "Animated Button mimicking Material Design animation using Pop"
  s.homepage         = "https://github.com/edsancha/EDSTouchButton"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Eduardo Diaz Sancha" => "edsancha@gmail.com" }
  s.source           = { :git => "https://github.com/edsancha/EDSTouchButton.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/edsancha'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'

  s.dependency 'pop'

end

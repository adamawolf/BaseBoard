Pod::Spec.new do |s|
  s.name     = 'BaseBoard'
  s.version  = '0.9.7'
  s.license  = 'MIT'
  s.summary  = 'An implementation of Apple\'s iOS keyboard as a third party keyboard extension.'
  s.homepage = 'http://github.com/adamawolf/BaseBoard'
  s.social_media_url = 'https://twitter.com/adamawolf'
  s.authors  = { 'Adam A. Wolf' => 'hi@adamawolf.com' }
  s.source       = { :git => 'https://github.com/adamawolf/BaseBoard.git', :tag => '0.9.7' }
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.public_header_files = 'BaseBoard/*.h'
  s.source_files = 'BaseBoard/*.{h,m}'
  s.resources = 'BaseBoard/Resources/*.png'
end
Pod::Spec.new do |s|
  s.name     = 'BaseBoard'
  s.version  = '0.9.4'
  s.license  = 'MIT'
  s.summary  = 'An basic implementation of the standard iOS keyboard as a keyboard extension.'
  s.homepage = 'http://github.com/adamawolf/BaseBoard'
  s.social_media_url = 'https://twitter.com/adamawolf'
  s.authors  = { 'Adam A. Wolf' => 'hi@adamawolf.com' }
  s.source       = { :git => 'git@github.com:adamawolf/BaseBoard.git', :tag => '0.9.4' }
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.public_header_files = 'BaseBoard/*.h'
  s.source_files = 'BaseBoard/*.{h,m}'
  s.resources = 'BaseBoard/Resources/*.png'
end
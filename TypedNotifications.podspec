Pod::Spec.new do |spec|
  spec.name         = 'TypedNotifications'
  spec.version      = '1.0'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://github.com/mergesort/TypedNotifications'
  spec.authors      =  { 'Joe Fabisevich' => 'github@fabisevi.ch' }
  spec.summary      = 'A wrapper around NotificationCenter for sending typed notifications with payloads across your iOS app.'
  spec.source       =   { :git => 'https://github.com/mergesort/TypedNotifications', :tag => "#{spec.version}" }
  spec.source_files = 'Source/*.swift'
  spec.framework    = 'Foundation'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/mergesort'
  spec.ios.deployment_target = '8.0'
end

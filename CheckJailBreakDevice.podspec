Pod::Spec.new do |s|
  s.name         = 'CheckJailBreakDevice'
  s.version      = '1.0.0'
  s.summary      = 'A pod to detect whether a device is jailbroken in swift.'
  s.description  = 'CheckJailBreakDevice provides functionality to check if a iOS device is jailbroken.'
  s.homepage     = 'https://github.com/SachinSabat/CheckJailBreakDevice'
 s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Sachin Sabat' => 'your.email@example.com' }
  s.source       = { :git => 'https://github.com/SachinSabat/CheckJailBreakDevice.git', :tag => s.version.to_s }
  s.source_files = "CheckJailBreakDevice", "CheckJailBreakDevice/**/*.{h,m,swift}"
  s.requires_arc = true
end
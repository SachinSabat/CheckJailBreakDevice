Pod::Spec.new do |spec|

  spec.name         = "CheckJailBreakDevice"
  spec.version      = "1.0.0"
  spec.summary      = "Detect JailBreak Device in Swift 5 (iOS) programmatically"

  spec.description  = <<-DESC
Detect Jail break device| iOS| Avoid Attackers to intrude in your application by all means possible in a single page| Supported to Swift (world first Protocol Oriented Language 🤘)
                   DESC

  spec.homepage     = "https://github.com/SachinSabat/CheckJailBreakDevice.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Sachin Sabat" => "sabat.sachin33@gmail.com" }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/SachinSabat/CheckJailBreakDevice.git", :tag => "#{spec.version}" }
  spec.source_files  = "CheckJailBreakDevice/**/*.{h,m,swift}"

end

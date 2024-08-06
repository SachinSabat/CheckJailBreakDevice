Pod::Spec.new do |s|
          #1.
          s.name               = "CheckJailBreakDevice"
          #2.
          s.version            = "1.0.5"
          #3.  
          s.summary         = "A pod to detect whether a device is jailbroken in swift."
          #4.
          s.homepage        = "https://github.com/SachinSabat/CheckJailBreakDevice"
          #5.
          s.license              = "MIT"
          #6.
          s.author               = "Sachin Sabat"
          #7.
          s.platform            = :ios, "12.0"
          #8.
          s.source              = { :git => "https://github.com/SachinSabat/CheckJailBreakDevice.git", :tag => "1.0.5" }
          #9.
          s.source_files     = "CheckJailBreakDevice", "CheckJailBreakDevice/**/*.{h,m,swift}"
	  #10.
	  s.swift_version    = '5.0'
    end
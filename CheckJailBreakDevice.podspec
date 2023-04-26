Pod::Spec.new do |s|
          #1.
          s.name               = "CheckJailBreakDevice"
          #2.
          s.version            = "1.0.0"
          #3.  
          s.summary         = "Detect JailBreak Device in Swift 5 (iOS) programmatically."
          #4.
          s.homepage        = "https://github.com/SachinSabat/CheckJailBreakDevice"
          #5.
          s.license              = "MIT"
          #6.
          s.author               = "Sachin Sabat"
          #7.
          s.platform            = :ios, "10.0"
          #8.
          s.source              = { :git => "https://github.com/SachinSabat/CheckJailBreakDevice.git", :tag => "1.0.0" }
          #9.
          s.source_files     = "CheckJailBreakDevice", "CheckJailBreakDevice/**/*.{h,m,swift}"
    end

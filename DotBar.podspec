

Pod::Spec.new do |spec|


  spec.name         = "DotBar"
  spec.version      = "0.0.1"
  spec.summary      = "A CocoaPods libarry written in Swift for DotBar."


  spec.description  = <<-DESC
  The DotBar is a specialized ProgressBar with Dots. Dots enable you to visualize the checkpoints on the progress bar.
                   DESC

  spec.homepage     = "https://github.com/narangkishore98/DotBar"


  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Kishore Narang" => "contact@kishorenarang.com" }
 


  spec.platform     = :ios, "12.0"
  spec.swift_version = "4.2"


  spec.source       = { :git => "https://github.com/narangkishore98/DotBar.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes", "Classes/**/*.{h,m}", "DotBar/**/*.{h,m,swift}"

end

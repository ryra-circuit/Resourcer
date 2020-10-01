Pod::Spec.new do |spec|

  spec.name          = "Resourcer"
  spec.version       = "0.1.0.1"
  spec.summary       = "This is communication, maps, file/media options based library."
  spec.description   = "This is communication based library with several types of communication, maps, file/media service supports."
  spec.homepage      = "https://github.com/ryra-circuit/Resourcer"
  spec.license       = "MIT (example)"
  spec.license       = { :type => "MIT", :file => "LICENSE" }
  spec.author        = { "RYRA Circuit" => "ryracircuit@gmail.com" }
  spec.platform      = :ios, "11.0"
  spec.swift_version = "5.0"
  spec.source        = { :git => "https://github.com/ryra-circuit/Resourcer.git", :tag => "0.1.0.1" }
  spec.source_files  = 'Resourcer/*.{h}', 'Resourcer/Classes/Maps/*.{swift}', 'Resourcer/Classes/Files/*.{swift}', 'Resourcer/Classes/Communication/*.{swift}', 'Resourcer/Classes/MediaPicker/*.{swift}', 'Resourcer/Classes/Utility/*.{swift}'
  spec.frameworks    = 'Alamofire'
  spec.static_framework = true
  spec.dependency 'Alamofire'

end
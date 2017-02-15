Pod::Spec.new do |s|
    s.name             = "VMPayment"
    s.version          = "0.0.1"
    s.summary          = "A simple payment solution."
    s.description      = <<-DESC
                        A Payment pod
                       DESC

    s.homepage         = "https://github.com/vmouta/VMPayment"
    s.license          = { :type => "MIT", :file => "LICENSE" }
    s.author           = { "Vasco Mouta" => "vasco.mouta@gmail.com" }
    s.source           = { :git => "https://github.com/vmouta/VMPayment.git", :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/vmouta'

    s.platform     = :ios, '8.0'
    s.requires_arc = true

    s.source_files = 'Pod/Classes/**/*'

    s.framework  = "Foundation"

end

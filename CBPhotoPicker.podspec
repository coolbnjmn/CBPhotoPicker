Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "CBPhotoPicker"
s.summary = "CBPhotoPicker is a customizable photo picker view controller for iOS -- Swift"
s.requires_arc = true

# 2
s.version = "0.1.28"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Benjamin Hendricks" => "hendricksbenjamin@gmail.com" }

# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/coolbnjmn/CBPhotoPicker"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/coolbnjmn/CBPhotoPicker.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"

# 8
s.source_files = "CBPhotoPicker/**/*.{swift}"

# 9
s.resources = "CBPhotoPicker/**/*.{png,jpeg,jpg,storyboard,xib}"
end

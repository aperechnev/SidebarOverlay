Pod::Spec.new do |s|
  s.name         = "SidebarOverlay"
  s.version      = "1.1.2"
  s.summary      = "Yet another implementation of sidebar menu, but here your menu appears over the top view controller."
  
  s.description  = "Yet another implementation of sidebar menu, but here your menu appears over the top view controller. You questions and pull requests are wolcome."

  s.homepage     = "https://github.com/aperechnev/SidebarOverlay"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Alexander Perechnev" => "herfleisch@me.com" }
  s.source       = { :git => "https://github.com/aperechnev/SidebarOverlay.git", :tag => "1.1.2" }

  s.platform     = :ios, '8.0'
  s.source_files = 'SidebarOverlay/SidebarOverlay/*.{h,m,swift}'
  s.requires_arc = true
end

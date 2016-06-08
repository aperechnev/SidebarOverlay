Pod::Spec.new do |s|
  s.name         = "SidebarOverlay"
  s.version      = "3.0.0"
  s.summary      = "Yet another implementation of sidebar menu, but here your menu appears over the top view controller."

  s.description  = "Yet another implementation of sidebar menu, but here your menu appears over the top view controller. You questions and pull requests are wolcome."

  s.homepage     = "https://github.com/alexkrzyzanowski/SidebarOverlay"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Alex Krzyzanowski" => "alexkrzyzanowski@icloud.com" }
  s.source       = { :git => "https://github.com/alexkrzyzanowski/SidebarOverlay.git", :tag => "3.0.0" }

  s.platform     = :ios, '8.0'
  s.source_files = 'SidebarOverlay/SidebarOverlay/*.{h,m,swift}'
  s.requires_arc = true
end

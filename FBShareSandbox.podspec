
Pod::Spec.new do |s|

s.name         = "FBShareSandbox"
s.version      = "0.1.0"
s.summary      = "分享自己应用手机沙盒文件"
s.description  = "一款小demo 在开发的时候 分享自己app 沙盒文件"

s.homepage     = "https://github.com/zhangxueyang/FBShareSandbox"
s.license      = "MIT"

s.author             = { "cocoazxy" => "cocoazxy@gmail.com" }
s.source       = { :git => "https://github.com/zhangxueyang/FBShareSandbox.git", :tag => "#{s.version}" }

s.source_files  = "Classes", "FBObjcTool/Classes/**/*.{h,m}"

s.platform     = :ios, '7.0'
s.requires_arc = true

end


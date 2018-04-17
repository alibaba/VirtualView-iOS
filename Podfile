source "https://github.com/CocoaPods/Specs.git"
# source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios, '8.0'

target 'VirtualViewDemo' do
    project 'VirtualViewDemo/VirtualViewDemo.xcodeproj'
    pod 'VirtualView', :path => './'
end

target 'RealtimePreview' do
	project 'RealtimePreview/RealtimePreview.xcodeproj'
    pod 'VirtualView', :path => './'
    pod 'Masonry'
    pod 'XLForm'
end

target 'VirtualViewTest' do
    project 'VirtualViewTest/VirtualViewTest.xcodeproj'
    pod 'VirtualView', :path => './'
    pod 'OCHamcrest'
end

workspace 'VirtualView'

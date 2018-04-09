[![CocoaPods](https://img.shields.io/cocoapods/v/VirtualView.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/p/VirtualView.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/l/VirtualView.svg)]()

# VirtualView 

A solution to create & release UI component dynamically.

It a part of our [Tangram](https://github.com/alibaba/Tangram-iOS) solution. And it can be used as a standalone library.

这是一个动态化创建和发布 UI 组件的方案。

它是我们 [Tangram](https://github.com/alibaba/Tangram-iOS) 方案的一部分。当然它也可以独立使用。

中文介绍：[VirtualView iOS](http://pingguohe.net/2018/02/23/virtualview-ios-1.2.html)

中文文档：[VirtualView通用文档](http://tangram.pingguohe.net/docs/virtualview/about-virtualview)，[VirtualView iOS文档](http://tangram.pingguohe.net/docs/ios/use-virtualview)

## Features

![feature](https://github.com/alibaba/VirtualView-iOS/raw/master/README/feature.png)

1. Write component via XML.
2. Compile XML to a .out (binary) file.
3. Load .out file in iOS application.
4. Create component from loaded template and bind data to it.
5. Show the component.

简单总结起来就是用 XML 描述一个组件，用我们提供的工具编译成 .out 二进制文件，在集成了 VirtualView 的 App 里直接加载 .out 文件就可以得到一个组件，然后像使用普通 UIView 一样使用它就好了。

## Install

### CocoaPods

Use VirtualView alone:

    pod 'VirtualView'

Use VirtualView with [Tangram](https://github.com/alibaba/Tangram-iOS):

    pod 'Tangram'

CocoaPods will install VirtualView as a part of Tangram 2.x.

### Source codes

Or you can download source codes from [releases page](https://github.com/alibaba/VirtualView-iOS/releases) and put them into your project.

## How to use

1. Load component template from .out file.

```objective-c
if (![[VVTemplateManager sharedManager].loadedTypes containsObject:@"icon_type"]) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_file" ofType:@"out"];
    [[VVTemplateManager sharedManager] loadTemplateFile:path forType:@"type_alias"];
}
```

2. Create component.

```objective-c
self.viewContainer = [VVViewContainer viewContainerWithTemplateType:@"icon_type"];
[self.view addSubview:self.viewContainer];
```

3. Bind data and calc the layout (fixed size).

```objective-c
self.viewContainer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1000);
[self.viewContainer update:@{
    @"type" : @"icon-type",
    @"imgUrl" : @"https://test.com/test.png"
}];
```

4. If you want to clac size.

```objective-c
[self.viewContainer updateData:@{
    @"type" : @"icon-type",
    @"imgUrl" : @"https://test.com/test.png"
}];
CGSize size = CGSizeMake(MAX_WIDTH, MAX_HEIGHT);
size = [self.viewContainer estimatedSize:size];
self.viewContainer.frame = CGRectMake(0, 0, size.width, size.height);
[self.viewContainer updateLayout];
```

See more details in the demo project.

## XML Compile Tools

An executable jar (need Java 1.8) is in the CompileTool path. In the demo project, we use bash script to sync XML template changes. You can find the script here:

![compile_tools_script](https://github.com/alibaba/VirtualView-iOS/raw/master/README/compile_tools_script.png)

See more details [here](https://github.com/alibaba/virtualview_tools).

# 微信群

![](https://img.alicdn.com/tfs/TB11_2_kbSYBuNjSspiXXXNzpXa-167-167.png)

搜索 `tangram_` 或者扫描以上二维码添加 Tangram 为好友，以便我们邀请你入群。

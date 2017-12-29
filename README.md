[![CocoaPods](https://img.shields.io/cocoapods/v/VirtualView.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/p/VirtualView.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/l/VirtualView.svg)]()

# VirtualView 

A solution to create & release UI component dynamically.

It a part of our [Tangram](https://github.com/alibaba/Tangram-iOS) solution. And it can be used as a standalone library.

这是一个动态化创建和发布 UI 组件的方案。

它是我们 [Tangram](https://github.com/alibaba/Tangram-iOS) 方案的一部分。当然它也可以独立使用。

中文站点：[VirtualView](http://tangram.pingguohe.net/docs/virtualview/about-virtualview)

## Features

![xml](https://github.com/alibaba/VirtualView-iOS/raw/master/README/feature.png)

1. Write component via XML.
2. Compile XML to a out (binary) file.
3. Load out file in iOS application.
4. Create component from loaded template and bind data to it.
5. Show the component.

简单总结起来就是用 XML 描述一个组件，用我们提供的工具编译成 out 二进制文件，在集成了 VirtualView 的 App 里直接加载 out 文件就可以得到一个组件，像使用普通 UIView 一样显示它就好了。

## Install

### CocoaPods

Use VirtualView alone:

    pod 'VirtualView', '~> 1.0'

Use VirtualView with [Tangram](https://github.com/alibaba/Tangram-iOS):

    pod 'Tangram', '~> 2.0'

CocoaPods will install VirtualView as a part of Tangram 2.0.

### Source codes

Or you can download source codes from [release page](https://github.com/alibaba/VirtualView-iOS/releases) and put them into your project.

## How to use

1. Load component template from out file.

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"out"];
NSData *buffer = [NSData dataWithContentsOfFile:path];
[[VVBinaryLoader shareInstance] loadFromBuffer:buffer];
```

2. Create component.

```objective-c
self.container = (VVViewContainer *)[[VVViewFactory shareFactoryInstance] obtainVirtualWithKey:@"icon"];
[self.view addSubview:self.container];
```

3. Bind data and calc the layout.

```objective-c
self.container.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1000);
[self.container update:@{
    @"type" : @"icon",
    @"imgUrl" : @"https://test.com/test.png"
}];
```

See more details in the demo project.

## Tools

See more details [here](https://github.com/alibaba/virtualview_tools).
//
//  PageViewController.m
//  VirtualViewDemo
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "PageViewController.h"
#import <VirtualView/VVTemplateManager.h>

@implementation PageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[VVTemplateManager sharedManager].loadedTypes containsObject:@"PageItem"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PageItem" ofType:@"out"];
        [[VVTemplateManager sharedManager] loadTemplateFile:path forType:nil];
    }
}

- (NSDictionary *)params
{
    return @{
        @"type" : @"Page",
        @"data" : @[
            @{
                @"type" : @"PageItem",
                @"imgUrl" : @"https://img.alicdn.com/imgextra/i1/1910146537/TB2Xluvad3nyKJjSZFEXXXTTFXa_!!1910146537.jpg",
                @"title" : @"title1",
                @"action" : @"action1"
            },
            @{
                @"type" : @"PageItem",
                @"imgUrl" : @"https://img.alicdn.com/imgextra/i4/2215696389/TB2uXtXXGZPyuJjy1zcXXXp1FXa_!!2215696389.jpg",
                @"title" : @"title2",
                @"action" : @"action2"
            },
            @{
                @"type" : @"PageItem",
                @"imgUrl" : @"https://img.alicdn.com/imgextra/i3/1709193846/TB2W5neXHAlyKJjSZFwXXXtqpXa_!!1709193846.jpg",
                @"title" : @"title3",
                @"action" : @"action3"
            }
        ]
    };
}

@end

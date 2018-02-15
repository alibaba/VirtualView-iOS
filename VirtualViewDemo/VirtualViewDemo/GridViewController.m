//
//  GridViewController.m
//  VirtualViewDemo
//
//  Created by HarrisonXi on 2018/2/14.
//  Copyright © 2018年 tmall. All rights reserved.
//

#import "GridViewController.h"
#import <VirtualView/VVTemplateManager.h>

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[VVTemplateManager sharedManager].loadedTypes containsObject:@"GridItem"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"GridItem" ofType:@"out"];
        [[VVTemplateManager sharedManager] loadTemplateFile:path forType:nil];
    }
}

- (NSDictionary *)params
{
    return @{
        @"type" : @"Grid",
        @"data" : @[
            @{
                @"type" : @"GridItem",
                @"imgUrl" : @"https://img.alicdn.com/imgextra/i1/1910146537/TB2Xluvad3nyKJjSZFEXXXTTFXa_!!1910146537.jpg",
                @"title" : @"title1"
            },
            @{
                @"type" : @"GridItem",
                @"imgUrl" : @"https://img.alicdn.com/imgextra/i4/2215696389/TB2uXtXXGZPyuJjy1zcXXXp1FXa_!!2215696389.jpg",
                @"title" : @"title2"
            },
            @{
                @"type" : @"GridItem",
                @"imgUrl" : @"https://img.alicdn.com/imgextra/i3/1709193846/TB2W5neXHAlyKJjSZFwXXXtqpXa_!!1709193846.jpg",
                @"title" : @"title3"
            }
        ]
    };
}

@end

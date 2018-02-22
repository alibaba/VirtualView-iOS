//
//  ContainerViewController.m
//  VirtualViewDemo
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "ContainerViewController.h"
#import <VirtualView/VVViewContainer.h>

@interface ContainerViewController () <VirtualViewDelegate>

@property (nonatomic, strong) VVViewContainer *container;

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.container.delegate = self;
}

- (void)virtualViewClickedWithAction:(NSString *)action andValue:(NSString *)value
{
    if (action) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"tap" message:action preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)virtualViewLongPressedWithAction:(NSString *)action andValue:(NSString *)value
{
    if (action) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"long press" message:action preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

- (NSDictionary *)params
{
    return @{
        @"type" : @"Container",
        @"content" : @[
            @{
                @"imgUrl" : @"https://img.alicdn.com/imgextra/i1/1910146537/TB2Xluvad3nyKJjSZFEXXXTTFXa_!!1910146537.jpg",
                @"title" : @"title1"
            },
            @{
                @"imgUrl" : @"https://img.alicdn.com/imgextra/i4/2215696389/TB2uXtXXGZPyuJjy1zcXXXp1FXa_!!2215696389.jpg",
                @"title" : @"title2"
            },
            @{
                @"imgUrl" : @"https://img.alicdn.com/imgextra/i3/1709193846/TB2W5neXHAlyKJjSZFwXXXtqpXa_!!1709193846.jpg",
                @"title" : @"title3"
            }
        ]
    };
}

@end

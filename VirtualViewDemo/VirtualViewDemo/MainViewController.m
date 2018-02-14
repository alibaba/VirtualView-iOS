//
//  MainViewController.m
//  VirtualViewDemo
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "MainViewController.h"
#import "TestViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) NSArray <NSString *> *demoArray;

@end

@implementation MainViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"VirtualViewDemo";
        self.demoArray = @[@"FrameLayout", @"VHLayout", @"VH2Layout", @"GridLayout", @"RatioLayout", @"NText", @"NLine", @"NImage", @"Container"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.demoArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *demoFilename = self.demoArray[indexPath.row];
    TestViewController *vc = [[TestViewController alloc] initWithFilename:demoFilename];
    if ([demoFilename isEqualToString:@"Container"]) {
        vc.params = @{
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
    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  MainViewController.m
//  VirtualViewDemo
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "MainViewController.h"
#import "TestViewController.h"
#import "ContainerViewController.h"
#import "GridViewController.h"
#import "PageViewController.h"
#import "TableViewController.h"
#import <VirtualView/VVNodeClassMapper.h>
#import <VirtualView/VVBinaryStringMapper.h>

@interface MainViewController ()

@property (nonatomic, strong) NSArray <NSString *> *demoArray;

@end

@implementation MainViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"VirtualViewDemo";
        self.demoArray = @[@"FrameLayout", @"VHLayout", @"VH2Layout", @"GridLayout", @"RatioLayout", @"NText", @"NLine", @"NImage", @"NFrameLayout", @"NVHLayout", @"NVH2Layout", @"NGridLayout", @"NRatioLayout", @"Container", @"Grid", @"Page", @"TableViewCell", @"Dot9Image"];
        
        [self registerVV];
    }
    return self;
}

- (void)registerVV
{
    [VVNodeClassMapper registerClassName:@"Dot9ImageView" forID:1001];
    [VVBinaryStringMapper registerString:@"dot9Left"];
    [VVBinaryStringMapper registerString:@"dot9Top"];
    [VVBinaryStringMapper registerString:@"dot9Right"];
    [VVBinaryStringMapper registerString:@"dot9Bottom"];
    [VVBinaryStringMapper registerString:@"dot9Scale"];
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
    NSString *demoName = self.demoArray[indexPath.row];
    UIViewController *vc;
    if ([demoName isEqualToString:@"Container"]) {
        vc = [[ContainerViewController alloc] initWithFilename:demoName];
    } else if ([demoName isEqualToString:@"Grid"]) {
        vc = [[GridViewController alloc] initWithFilename:demoName];
    } else if ([demoName isEqualToString:@"Page"]) {
        vc = [[PageViewController alloc] initWithFilename:demoName];
    } else if ([demoName isEqualToString:@"TableViewCell"]) {
        vc = [[TableViewController alloc] init];
   } else {
        vc = [[TestViewController alloc] initWithFilename:demoName];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end

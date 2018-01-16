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
        self.demoArray = @[ @"NText", @"NImage", @"TmallComponent2" ];
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
    if ([demoFilename isEqualToString:@"TmallComponent2"]) {
        vc.params = @{
                      @"type" : demoFilename,
                      @"imgUrl" : @"https://gw.alicdn.com/tps/TB1Nin9JFXXXXbXaXXXXXXXXXXX-224-224.png",
                      @"title" : @"test title"
                      };
    } else {
        vc.params = @{ @"type" : demoFilename };
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end

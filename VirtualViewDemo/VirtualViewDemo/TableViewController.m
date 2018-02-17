//
//  TableViewController.m
//  VirtualViewDemo
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "TableViewController.h"
#import <VirtualView/VVTemplateManager.h>
#import <VirtualView/VVViewFactory.h>
#import <VirtualView/VVViewContainer.h>

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) VVViewContainer *publicContainer;

@end

@implementation TableViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"TableViewCell";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (![[VVTemplateManager sharedManager].loadedTypes containsObject:@"TextCell"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TextCell" ofType:@"out"];
        [[VVTemplateManager sharedManager] loadTemplateFile:path forType:nil];
    }
    
    _dataArray = [NSMutableArray array];
    _heightArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        [_dataArray addObject:@{@"imgUrl" : @"right_arrow",
                                @"title" : @"line 1, line 1, line 1, line 1, line 1, line 1"}];
        [_heightArray addObject:@(0)];
        [_dataArray addObject:@{@"size" : @"16",
                                @"title" : @"line 2, line 2, line 2, line 2, line 2, line 2, line 2, line 2, line 2, line 2"}];
        [_heightArray addObject:@(0)];
        [_dataArray addObject:@{@"imgUrl" : @"https://www.tmall.com/favicon.ico",
                                @"title" : @"line 3, line 3, line 3, line 3, line 3, line 3, line 3, line 3, line 3, line 3, line 3, line 3, line 3, line 3"}];
        [_heightArray addObject:@(0)];
        [_dataArray addObject:@{@"title" : @"line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4, line 4"}];
        [_heightArray addObject:@(0)];
    }
    
    _publicContainer = [VVViewContainer viewContainerWithTemplateType:@"TextCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[_heightArray objectAtIndex:indexPath.row] floatValue];
    if (height <= 0) {
        CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
        CGSize size = CGSizeMake(viewWidth, 1000);
        [_publicContainer updateData:[_dataArray objectAtIndex:indexPath.row]];
        size = [_publicContainer estimatedSize:size];
        height = ceil(size.height);
        [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(height)];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        VVViewContainer *container = [VVViewContainer viewContainerWithTemplateType:@"TextCell" alwaysRefresh:NO];
        container.tag = 1000;
        [cell addSubview:container];
    }
    VVViewContainer *container = [cell viewWithTag:1000];
    if (container) {
        CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        container.frame = CGRectMake(0, 0, viewWidth, height);
        [container update:[_dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

@end

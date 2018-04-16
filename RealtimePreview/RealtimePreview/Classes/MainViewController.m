//
//  MainViewController.m
//  VirtualViewDemo
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "MainViewController.h"
#import "TestViewController.h"
#import "ScanViewController.h"
#import "SettingsViewController.h"
#import "HotReloadService.h"
#import <VirtualView/VVTemplateManager.h>

static NSString *const kTemplateFileName = @"templatelist.properties";

@interface MainViewController () <ScanViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray <NSString *> *demoArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *templatesArray;

@end

@implementation MainViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"VVPlayground";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan"] style:UIBarButtonItemStyleDone target:self action:@selector(openScanViewController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStyleDone target:self action:@selector(openSettingsViewController)];
    
    
    _demoArray = [NSMutableArray new];
    
    // 读取当前templatelist.properties内容
    NSString *templatelistContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"templatelist" ofType:@"properties"] encoding:NSUTF8StringEncoding error:nil];
    NSArray <NSString *> *lines = [templatelistContent componentsSeparatedByString:@"\n"];
    
    for (NSString *line in lines) {
        NSString *templateName = [line componentsSeparatedByString:@"="].firstObject;
        if (templatelistContent.length == 0) {
            continue;
        }
        
        // 加载模板数据
        if (![[VVTemplateManager sharedManager].loadedTypes containsObject:templateName]) {
            NSString *path = [[NSBundle mainBundle] pathForResource:templateName ofType:@"out"];
            [[VVTemplateManager sharedManager] loadTemplateFile:path forType:nil];
        }
        
        // 保存模板名称
        [_demoArray addObject:templateName];
    }
    
    // 读取 VVTool 模版目录
    __weak typeof(self) weakSelf = self;
    [HotReloadService fetchTemplateNameListWithCallback:^(NSArray *array) {
        weakSelf.templatesArray = [array copy];
        [weakSelf.tableView reloadData];
    }];
    
    self.tableView.rowHeight = 60;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView reloadData];
}

- (void)openScanViewController {
    ScanViewController *scanViewController = [ScanViewController new];
    scanViewController.delegate = self;
    [self.navigationController pushViewController:scanViewController animated:YES];
}

- (void)openSettingsViewController {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _demoArray.count;
    }else if (section == 1) {
        return _templatesArray.count;
    }else{
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section ? @"现有模版" : @"基础组件";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.demoArray[indexPath.row];
    }else{
        cell.textLabel.text = self.templatesArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *demoFilename = self.demoArray[indexPath.row];
        TestViewController *vc = [[TestViewController alloc] initWithFilename:demoFilename];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1) {
        NSString *templateName = self.templatesArray[indexPath.row];
        TestViewController *vc = [[TestViewController alloc] initWithHotReloadTemplateName:templateName];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark <ScanViewControllerDelegate>

- (void)scanViewController:(UIViewController *)scanViewController didScanContent:(NSString *)content {
    NSURL *url = [NSURL URLWithString:content];
    if (url) {
        TestViewController *vc = [[TestViewController alloc] initWithTemplateBaseURL:url];
        [self.navigationController pushViewController:vc animated:YES];
        
        // 移除扫描 VC
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:scanViewController];
        self.navigationController.viewControllers = allViewControllers;
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

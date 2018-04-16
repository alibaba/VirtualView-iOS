//
//  TestViewController.m
//  VirtualViewDemo
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "TestViewController.h"
#import <VirtualView/VVTemplateManager.h>
#import "VVViewContainer.h"
#import "VVViewFactory.h"
#import "HotReloadService.h"
#import <SafariServices/SFSafariViewController.h>

@interface TestViewController () <VirtualViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) VVViewContainer *container;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSURL *templateDataJsonURL;
@end

@implementation TestViewController

- (instancetype)initWithFilename:(NSString *)filename {
    if (self = [super init]) {
        self.title = filename;
        
    }
    return self;
}

- (instancetype)initWithHotReloadTemplateName:(NSString *)templateName {
    if (self = [super init]) {
        self.hotReload = YES;
        self.title = templateName;
    }
    return self;
}

- (instancetype)initWithTemplateBaseURL:(NSURL *)templateBaseURL {
    if (self = [super init]) {
        self.templateDataJsonURL = templateBaseURL;
        self.title = [[templateBaseURL URLByDeletingLastPathComponent] lastPathComponent];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    [self refresh];
    
    // 临时测试 （MTL问题）
    if (!self.templateDataJsonURL && !self.hotReload) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self refresh];
        });
    }
}

- (void)refresh {
    [self loadTemplate];
    
    [self.view layoutSubviews];
}

- (void)loadTemplate {
    __weak typeof(self) weakSelf = self;
    
    HotReloadServiceTemplateBlock fetchTemplateDataCallback = ^(NSArray<NSData *> *templates, NSDictionary *params) {
        for (NSData *templateData in templates) {
            [[VVTemplateManager sharedManager] loadTemplateData:templateData forType:self.title];
        }
        weakSelf.data = params;
        
        [weakSelf reloadUI];
    };
    
    if (self.hotReload) {
        [HotReloadService fetchTemplateByName:self.title callback:fetchTemplateDataCallback];
    }else if (self.templateDataJsonURL) {
        [HotReloadService fetchTemplateByDataJsonURL:self.templateDataJsonURL callback:fetchTemplateDataCallback];
    }else{
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.title ofType:@"json"]];
        if (data) {
            _data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }
        [self reloadUI];
    }
}

/**
 刷新 UI
 */
- (void)reloadUI {
    if (!_data) {
        _data = @{};
    }
    
    // 先移除旧的
    [_container removeFromSuperview];
    [_scrollView removeFromSuperview];
    
    _container = [VVViewContainer viewContainerWithTemplateType:self.title];
    _container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _container.clipsToBounds = YES;
    _container.delegate = self;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_scrollView addSubview:_container];
    [self.view addSubview:_scrollView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.scrollView.frame = self.view.bounds;
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGSize size = CGSizeMake(viewWidth, 1000);
    size = [self.container estimatedSize:size];
    self.scrollView.contentSize = size;
    self.container.frame = CGRectMake(0, 0, size.width, size.height);
    [self.container update:self.data];
}

//#pragma mark - VirtualViewDelegate
//
//- (void)virtualView:(VVViewObject *)virtualView clickWithAction:(NSString *)action bindData:(NSDictionary *)bindData {
//    NSLog(@"click: %@, %@, %@, %@", virtualView, action, bindData, virtualView.tag);
//    [ASCProgressHUD showText:action];
//
//    NSURL *url = [NSURL URLWithString:action];
//    if (url) {
//        if ([url.absoluteString hasPrefix:@"http"]) {
//            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
//            [self presentViewController:safariVC animated:YES completion:nil];
//        }else{
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }
//}
//
//- (void)virtualView:(VVViewObject *)virtualView longPressedWithGesture:(UILongPressGestureRecognizer *)gesture {
//    NSLog(@"long press: %@", virtualView);
//}

@end

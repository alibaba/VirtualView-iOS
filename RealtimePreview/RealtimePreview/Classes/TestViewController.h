//
//  TestViewController.h
//  VirtualViewDemo
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, assign) BOOL hotReload;


/**
 文件名
 */
- (instancetype)initWithFilename:(NSString *)filename;

/**
 文件名
 */
- (instancetype)initWithHotReloadTemplateName:(NSString *)templateName;

/**
 URL
 */
- (instancetype)initWithTemplateBaseURL:(NSURL *)templateBaseURL;

@end

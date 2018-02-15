//
//  TestViewController.h
//  VirtualViewDemo
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

@property (nonatomic, strong, readonly) NSDictionary *params;

- (instancetype)initWithFilename:(NSString *)filename;

@end

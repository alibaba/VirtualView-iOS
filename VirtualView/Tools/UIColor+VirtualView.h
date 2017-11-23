//
//  UIColor+VirtualView.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (VirtualView)

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue;

+ (UIColor *)colorWithString:(NSString *)string;

@end

//
//  UIColor+VirtualView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "UIColor+VirtualView.h"

@implementation UIColor (VirtualView)

+ (UIColor *)vv_colorWithRGB:(NSUInteger)rgb
{
    CGFloat red = ((rgb & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((rgb & 0xFF00) >> 8) / 255.0;
    CGFloat blue = (rgb & 0xFF) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)vv_colorWithARGB:(NSUInteger)argb
{
    CGFloat alpha = ((argb & 0xFF000000) >> 24) / 255.0;
    CGFloat red = ((argb & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((argb & 0xFF00) >> 8) / 255.0;
    CGFloat blue = (argb & 0xFF) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)vv_colorWithString:(NSString *)string
{
    if (!string || string.length == 0) {
        return nil;
    }
    
    if ([string hasPrefix:@"0x"]) {
        string = [string substringFromIndex:2];
    } else if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    }
    if (string.length == 8) {
        unsigned int argb = 0;
        NSScanner *scanner = [NSScanner scannerWithString:string];
        if ([scanner scanHexInt:&argb]) {
            return [UIColor vv_colorWithARGB:argb];
        }
    } else if (string.length == 6) {
        unsigned int rgb = 0;
        NSScanner *scanner = [NSScanner scannerWithString:string];
        if ([scanner scanHexInt:&rgb]) {
            return [UIColor vv_colorWithRGB:rgb];
        }
    }
    return nil;
}

@end

//
//  UIColor+VirtualView.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "UIColor+VirtualView.h"

@implementation UIColor (VirtualView)

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue
{
    return [self colorWithHexValue:hexValue alpha:255];
}

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(NSUInteger)alpha
{
    CGFloat r = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    CGFloat g = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    CGFloat b = (hexValue & 0x000000FF) / 255.0;
    CGFloat a = alpha / 255.0;
    return [self colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *)colorWithString:(NSString *)string
{
    NSUInteger len = [string length];
    NSUInteger hexValue = 0;
    NSUInteger alpha = 1;
    if (len == 8 || (len == 9 && [string characterAtIndex:0] == (unichar)'#')) {
        hexValue = [UIColor hexValueOfString:string];
        alpha = (hexValue & 0xFF000000) >> 24;
        hexValue = hexValue & 0x00FFFFFF;
    } else if (len == 6 || (len == 7 && [string characterAtIndex:0] == (unichar)'#')) {
        hexValue = [UIColor hexValueOfString:string];
        alpha = 255;
    } else if (len == 3 || (len == 4 && [string characterAtIndex:0] == (unichar)'#')) {
        hexValue = [UIColor hexValueOfString:string];
        alpha = 255;
    }
    return [UIColor colorWithHexValue:hexValue alpha:alpha];
}

+ (NSUInteger)hexValueOfString:(NSString *)string
{
    NSString *newString = [string lowercaseString];
    if ([newString hasPrefix:@"#"]) {
        newString = [string substringFromIndex:1];
    }
    if (newString.length == 3) {
        unichar str[6] = {0};
        for (int i = 0; i < 3; i++) {
            unichar ch = [newString characterAtIndex:i];
            str[i * 2] = ch;
            str[i * 2 + 1] = ch;
        }
        newString = [NSString stringWithCharacters:str length:6];
    }
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:newString];
    [scanner scanHexInt:&result];
    return result;
}

@end

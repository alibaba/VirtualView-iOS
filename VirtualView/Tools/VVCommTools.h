//
//  VVCommTools.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VVCommTools : NSObject
+ (void)convertShortToLittleEndian:(short *)data;
+ (void)convertIntToLittleEndian:(int *)data;
+ (UIColor *)pixelColorFromImage:(UIImage *)image;
@end

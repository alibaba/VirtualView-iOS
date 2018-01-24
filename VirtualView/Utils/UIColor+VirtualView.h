//
//  UIColor+VirtualView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (VirtualView)

/**
 0xFF0000   => red
 0x00FF00   => green
 0x0000FF   => blue
 0xFFFF0000 => red (alpha = 1)
 0x00FF0000 => red (alpha = 1)
 
 Alpha value will be discarded.

 @param  rgb  UInteger value.
 @return      Color.
 */
+ (nonnull UIColor *)vv_colorWithRGB:(NSUInteger)rgb;

/**
 0xFFFF0000 => red
 0xFF00FF00 => green
 0xFF0000FF => blue
 0xFF0000   => clear (alpha = 0)
 0x00FF00   => clear (alpha = 0)
 
 Alpha value always take effect.

 @param  argb  UInteger value.
 @return       Color.
 */
+ (nonnull UIColor *)vv_colorWithARGB:(NSUInteger)argb;

/**
 @"#FF0000"    => red
 @"#FF00FF00"  => green
 @"0x0000FF"   => blue
 @"0x00FFFFFF" => clear (alpha = 0)
 @"FFFFFF"     => white
 @"00FFFFFF"   => clear (alpha = 0)
 
 @param  string  String value.
 @return         Color. Will return nil if string is invalid.
 */
+ (nullable UIColor *)vv_colorWithString:(nonnull NSString *)string;

@end

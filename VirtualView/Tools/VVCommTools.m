//
//  VVCommTools.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVCommTools.h"
#import "UIColor+VirtualView.h"

@implementation VVCommTools

+ (void)convertShortToLittleEndian:(short *)data
{
    *data = ((*data & 0xff00) >> 8) | ((*data & 0x00ff) << 8);
}


+ (void)convertIntToLittleEndian:(int *)data
{
    *data = ((*data & 0xff000000) >> 24)
    | ((*data & 0x00ff0000) >>  8)
    | ((*data & 0x0000ff00) <<  8)
    | ((*data & 0x000000ff) << 24);
}

+ (UIColor *)pixelColorFromImage:(UIImage *)image
{
    CGImageRef imageRef = [image CGImage];
    if(!imageRef)
    {
        return [UIColor colorWithString:@"#E1E2DF"];
    }
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    if (!rawData)
    {
        return [UIColor colorWithString:@"#E1E2DF"];
    }
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);

    NSUInteger byteIndex = (bytesPerRow * 1) + 1 * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    byteIndex += bytesPerPixel;
    UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    if(acolor)
    {
        return acolor;
    }
    else
    {
        return [UIColor colorWithString:@"#E1E2DF"];
    }
}
@end

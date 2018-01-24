//
//  FrameView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "FrameView.h"

@implementation FrameView

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.layer.borderWidth = lineWidth;
}

- (void)setBorderRadius:(CGFloat)borderRadius
{
    _borderRadius = borderRadius;
    self.layer.cornerRadius = borderRadius;
}

@end

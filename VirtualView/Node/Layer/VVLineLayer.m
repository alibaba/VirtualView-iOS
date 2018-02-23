//
//  VVLineLayer.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVLineLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface VVLineLayer () {
    CGFloat _width;
    CGFloat _height;
}

@property (nonatomic, assign, readonly) CGSize vv_size;

@end

@implementation VVLineLayer

@dynamic vv_size;

- (instancetype)init
{
    if (self = [super init]) {
        _vv_lineWidth = 1;
        _vv_lineColor = [UIColor blackColor];
        VVSetNeedsDisplayObserve(vv_size);
        VVSetNeedsDisplayObserve(vv_lineColor);
        VVSetNeedsDisplayObserve(vv_lineWidth);
    }
    return self;
}

- (void)dealloc
{
    [self vv_removeAllObservers];
}

- (void)setVv_lineWidth:(CGFloat)vv_lineWidth
{
    _vv_lineWidth = vv_lineWidth > 0 ? vv_lineWidth : 0;
}

- (void)setFrame:(CGRect)frame
{
    [self willChangeValueForKey:@"vv_size"];
    [super setFrame:frame];
    _width = CGRectGetWidth(frame);
    _height = CGRectGetHeight(frame);
    [self didChangeValueForKey:@"vv_size"];
}

- (CGSize)vv_size
{
    return CGSizeMake(_width, _height);
}

- (void)createPath:(CGContextRef)context
{
    if (_width > _height) {
        CGFloat midY = _height / 2;
        CGContextMoveToPoint(context, 0, midY);
        CGContextAddLineToPoint(context, _width, midY);
    } else {
        CGFloat midX = _width / 2;
        CGContextMoveToPoint(context, midX, 0);
        CGContextAddLineToPoint(context, midX, _height);
    }
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextClearRect(context, CGRectMake(0, 0, _width, _height));
    
    if (self.vv_lineWidth > 0
        && self.vv_lineColor
        && [self.vv_lineColor isEqual:[UIColor clearColor]] == NO) {
        CGContextSetLineWidth(context, self.vv_lineWidth);
        CGContextSetStrokeColorWithColor(context, self.vv_lineColor.CGColor);
        [self createPath:context];
        CGContextStrokePath(context);
    }
}

@end

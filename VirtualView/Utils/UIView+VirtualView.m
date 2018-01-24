//
//  UIView+VirtualView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "UIView+VirtualView.h"

@implementation UIView (VirtualView)

- (CGFloat)vv_left {
    return self.frame.origin.x;
}

- (void)setVv_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)vv_top {
    return self.frame.origin.y;
}

- (void)setVv_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)vv_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setVv_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)vv_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setVv_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)vv_centerX {
    return self.center.x;
}

- (void)setVv_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)vv_centerY {
    return self.center.y;
}

- (void)setVv_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)vv_width {
    return self.frame.size.width;
}

- (void)setVv_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)vv_height {
    return self.frame.size.height;
}

- (void)setVv_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end

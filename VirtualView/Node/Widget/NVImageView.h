//
//  NVImageView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"

@interface NVImageView : VVBaseNode

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong) NSString *src;
@property (nonatomic, assign) VVScaleType scaleType;
@property (nonatomic, assign) CGFloat ratio;

@end

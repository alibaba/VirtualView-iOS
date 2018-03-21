//
//  VVLayout.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"
#import "VVLayer.h"

@interface VVLayout : VVBaseNode

@property (nonatomic, strong) VVLayer *canvasLayer;
@property (nonatomic, assign) CGFloat borderRadius;

@end

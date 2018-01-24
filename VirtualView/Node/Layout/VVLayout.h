//
//  VVLayout.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"
#import "VVLayer.h"

@interface VVLayout : VVBaseNode

@property(strong, nonatomic)VVLayer*   drawLayer;
@property(strong, nonatomic)UIColor*   borderColor;

@end

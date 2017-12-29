//
//  VVLayout.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVViewObject.h"
#import "VVLayer.h"

@interface VVLayout : VVViewObject

@property(strong, nonatomic)VVLayer*   drawLayer;
@property(strong, nonatomic)UIColor*   borderColor;

@end

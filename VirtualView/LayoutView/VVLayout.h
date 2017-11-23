//
//  VVLayout.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVViewObject.h"

@interface VVLayout : VVViewObject
@property(strong, nonatomic)CALayer*   drawLayer;
@property(strong, nonatomic)UIColor*   borderColor;
- (void)borderColorChange;
@end

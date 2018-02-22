//
//  VVPageView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVFrameLayout.h"

@interface VVPageView : VVFrameLayout

@property (nonatomic, assign) VVOrientation orientation;
@property (nonatomic, assign) BOOL autoSwitch;
@property (nonatomic, assign) BOOL canSlide;
@property (nonatomic, assign) NSTimeInterval stayTime;
@property (nonatomic, assign) NSTimeInterval autoSwitchTime;

@end

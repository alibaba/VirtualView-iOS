//
//  VVPageView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"

@interface VVPageView : VVBaseNode
@property(assign, nonatomic)BOOL    autoSwitch;
@property(assign, nonatomic)BOOL    canSlide;
@property(assign, nonatomic)int     orientation;
@property(assign, nonatomic)int     stayTime;
@property(assign, nonatomic)int     autoSwitchTime;//暂未实现
@property(assign, nonatomic)int     animatorTime;//暂未实现

@end

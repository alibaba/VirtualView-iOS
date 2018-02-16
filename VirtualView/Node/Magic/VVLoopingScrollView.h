//
//  VVLoopingScrollView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Fisrt & last item is used for looping.
 Please prepare them by yourself.
 */
@interface VVLoopingScrollView : UIScrollView

@property (nonatomic, assign) BOOL autoSwitch;
@property (nonatomic, assign) NSTimeInterval stayTime;
@property (nonatomic, assign) NSTimeInterval autoSwitchTime;

- (void)reset;
- (void)startAutoSwitch;
- (void)stopAutoSwitch;

@end

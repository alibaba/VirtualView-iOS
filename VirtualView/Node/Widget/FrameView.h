//
//  FrameView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameView : UIView
@property(assign, nonatomic)CGFloat  lineWidth;
@property(strong, nonatomic)UIColor* borderColor;
@property(assign, nonatomic)CGFloat borderRadius;
@end

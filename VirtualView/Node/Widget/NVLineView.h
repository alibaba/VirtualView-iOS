//
//  NVLineView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBaseNode.h"

@interface NVLineView : VVBaseNode
@property(assign, nonatomic)int       orientation;
@property(assign, nonatomic)VVLineStyle style;
@property(assign, nonatomic)CGFloat   lineWidth;
@property(assign, nonatomic)CGFloat   *lengths;
@property(strong, nonatomic)UIColor   *lineColor;
@end

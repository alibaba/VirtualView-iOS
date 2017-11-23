//
//  VVLineView.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVViewObject.h"


@interface VVLineView : VVViewObject
@property(assign, nonatomic)int       orientation;
@property(assign, nonatomic)LINESTYLE style;
@property(assign, nonatomic)CGFloat   lineWidth;
@property(assign, nonatomic)CGFloat   *lengths;
@property(strong, nonatomic)UIColor   *lineColor;
@end

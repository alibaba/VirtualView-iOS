//
//  VVTextView.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVViewObject.h"

@interface VVTextView : VVViewObject
@property(nonatomic, strong)NSString* text;
@property(nonatomic, assign)float size;
@property(nonatomic, assign)int lines;
@property(nonatomic, strong)UIColor* color;
@property(nonatomic, assign)BOOL bold;
@end

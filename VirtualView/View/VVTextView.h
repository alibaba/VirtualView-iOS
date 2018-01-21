//
//  VVTextView.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBaseNode.h"

@interface VVTextView : VVBaseNode
@property(nonatomic, strong)NSString* text;
@property(nonatomic, assign)float size;
@property(nonatomic, assign)int lines;
@property(nonatomic, strong)UIColor* color;
@property(nonatomic, assign)BOOL bold;
@end

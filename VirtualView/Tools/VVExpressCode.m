//
//  VVExpressCode.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVExpressCode.h"
@interface VVExpressCode ()
{
    Byte*  _codes;
    NSUInteger    _start, _end;
}
@end

@implementation VVExpressCode
-(id)initWith:(Byte[])bytes startPos:(NSUInteger)start lenght:(NSUInteger)len{
    self = [super init];
    if (self) {
        _codes = bytes;
        _start = start;
        _end   = start+len;
    }
    return self;
}
@end

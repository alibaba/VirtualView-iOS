//
//  VVLoader.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVLoader.h"
static VVLoader* _ins;
@interface VVLoader (){
    //
}
@end

@implementation VVLoader
+ (id)shareInstance{
    if (_ins==nil) {
        _ins = [VVLoader new];
        _ins.cacheDic = [NSMutableDictionary new];
    }
    return _ins;
}
@end
